# Notes

A small local notes app built from the [Notes App UI Figma prototype](https://www.figma.com/design/bqlPzHETqc3WPr0wdGoBH2/Notes-App-UI--M-one-task---Copy-) for the M-One Flutter Challenge.


## Running it

```bash
flutter pub get
(cd scripts && bash gen.sh)
flutter run
```

`scripts/gen.sh` runs `build_runner` (freezed/json/mobx/injectable/auto_route/flutter_gen — none of the generated `*.g.dart`/`*.gr.dart`/`*.freezed.dart`/`*.config.dart` files are committed) and then `easy_localization:generate` for `lib/gen/locale_keys.g.dart`. Nothing else needs configuring — the app is fully offline, there's no backend, and it targets iOS/Android/desktop/web via plain Flutter.

To run the widget tests:

```bash
flutter test
```

## Architecture

This repo started life as an existing internal Flutter boilerplate (`get_it`/`injectable` for DI, `auto_route` for navigation, `mobx`/`flutter_mobx` for state, `theme_tailor`/`flutter_gen` for theming and assets, `freezed`/`json_serializable` for models). The notes feature was built to fit that shape rather than replacing it:

```
lib/features/notes/
  data/
    models/note.dart                     # freezed Note (id, title, body, isFavorite, createdAt, updatedAt)
    repositories/notes_repository_impl.dart  # SharedPreferencesNotesRepository
  domain/
    repositories/notes_repository.dart   # abstract NotesRepository
  presentation/
    stores/notes_store.dart     # NotesStore (MobX)
    pages/                      # NotesListPage, SearchPage, NoteEditorPage, NoteReadingPage
    widgets/
    notes_theme.dart            # colors/text styles approximated from the Figma design by eye
```

`lib/features/home/presentation/pages/home_page.dart` is kept only because `AppRouter`'s initial route is wired to a class literally named `HomePage` (auto_route infers the route name from the page class); it just renders `NotesListPage`.

**State management: MobX.** The project already had `mobx`/`flutter_mobx`/`injectable` wired up and in use (`ConnectivityStore`, `LoadingState`, etc.), so `NotesStore` follows the same `@singleton` + `_PrivateStore with Store` pattern instead of introducing a second state management library (Bloc, Riverpod, ...) into a codebase that didn't have one. For a single CRUD-ish feature like this, MobX's `@observable`/`@computed`/`@action` gave reactive list/filter/search updates with very little boilerplate. It also suits a small app like this well and is a reliable, mature choice — no need to reach for something heavier.

**Persistence: `shared_preferences`.** Also already a dependency (used by `StorageUtils` for auth tokens). Notes are plain title/body strings with no sync target and a small expected data volume, so the whole list is serialized to one JSON blob and written back to `SharedPreferences` after every mutation — no need for a real database. Every store mutation (`createNote`, `updateNote`, `toggleFavorite`, `deleteNote`, swipe-triggered undo) awaits the write before returning, which reduces — but doesn't fully eliminate — the chance of losing an action if the process is killed immediately afterward; `shared_preferences` doesn't expose a flush/fsync confirmation, so this is best-effort rather than a hard durability guarantee.

**Gestures.** `Dismissible` isn't used per the brief. `SwipeableNoteCard` (`lib/features/notes/presentation/widgets/swipeable_note_card.dart`) is a hand-rolled horizontal-drag widget driven by a single `AnimationController`: dragging right reveals the favorite action (matches frame 04), dragging left past a threshold commits a delete (matches frame 03, where the row is already drawn fully red — I read that as "delete commits on release past the threshold" rather than "reveal, then tap"). Only one direction is ever open, a new drag always calls `controller.stop()` before taking over so it interrupts cleanly instead of fighting the in-flight snap animation, and the underlying `Note` model never changes shape based on gesture state.

## What is still wrong with this

- **Swipe-to-delete has no confirmation**, matching the design (frame 03 has no "are you sure" dialog, unlike editing). I added a 4-second "Undo" snackbar as a safety net, but if it's dismissed or missed, the note is gone — this is the biggest usability risk I shipped and, if I had more time, I'd either add a proper confirmation or make undo durable (e.g. keep the last deleted note around until the next app launch).
- **The favorite/delete swipe actions have no non-gesture equivalent.** A screen reader or keyboard-only user can't favorite or delete a note from the list at all — this is the accessibility gap I'm least happy about.
- The editor's dirty-check is a plain string/bool comparison recomputed on every keystroke; it's cheap here because notes are short plain text, but it's not something I'd want to scale up.
- No loading/error affordance while a save is in flight (it's effectively instant against `SharedPreferences`, but the code doesn't defend against a slow disk).
- Test coverage is thin: `test/widget_test.dart` covers the list screen across widths/text scales/content states, and `test/features/notes/note_editor_page_test.dart` covers back/save navigation on the editor. Search, the save/discard dialog choices, and the swipe gesture itself are still untested.
- I did not wire the formatting toolbar to anything (per the brief, it's static), but I also didn't visually verify it against the Figma frame pixel-for-pixel — it's a best-effort icon row, not a faithful redraw.
- I verified the empty-state and editor screens against the design on an iOS Simulator but did not click through the full save/discard/search/swipe flow on a real device in this session — that's a gap I'd close before calling this done.

## Design notes

- **Frames 05 vs. 06:** I built **06 — Filter View** and left out 05 — Favorites List. Both answer "how do I find my favorite notes," but 06's filter-chip pattern (`All` / `Favorites` / `Recent`) reuses the exact same list/card component as the main screen, while 05's grouped-sections layout is a structurally different list. Building 06 kept one list implementation instead of two, and it's the one that generalizes to a third state ("Recent") the grouped layout can't express.
- **The info (ⓘ) button** appears on every list header (02/04/06) but no frame shows what it opens. Rather than invent a feature the design doesn't specify, I wired it to a minimal "about" dialog as a placeholder — that's an assumption on my part, not a product requirement the design calls for, and I'd confirm the intended destination with design/product before shipping it for real.
- **The editor header icon is inconsistent across frames.** 09/10 (and the Save/Discard dialog frames 12/13, which inherit the same header) show a "visibility" (eye) icon; frame 11 — Editor Favorite — shows a star/favorite icon in the same slot instead. Since notes are plain text with no rendering/preview model, a "preview" toggle doesn't correspond to anything real, so I standardized on frame 11's favorite-toggle across all editor screens and treated the eye icon in 09/10/12/13 as a copy-paste leftover rather than a second feature to build.
- **Frames 12 and 13 aren't explicitly wired together**, but read as a two-step confirmation: 12 ("Save changes?") offers Discard/Save, and 13 ("Are you sure you want to discard...") offers Discard/Keep. I implemented them as a chain — tapping Discard on 12 opens 13 as a second confirmation — since that's the only reading that gives frame 13 a reason to exist as a separate screen.
- **Swipe-to-delete (03) is drawn already fully red** with the trash icon centered, unlike swipe-to-favorite (04) which shows a narrower, partial reveal. I read this as two different interaction models (delete commits past a drag threshold; favorite reveals-then-taps) rather than the same pattern at two points in time — see the Gestures section above.
- **Nunito** is used throughout the Figma file. View-only access means no font files or license terms were available to bundle, and adding a downloaded font felt out of scope for "no third-party packages" in spirit, so the app falls back to the platform default font. Sizing/weight/spacing follow the frames; the typeface doesn't.
- **No frame shows an empty result for the Favorites or Recent filters**, or for a note with an empty title. I added plain-text fallbacks ("No favorite notes yet", "Nothing edited in the last 7 days", falling back to the note body or "Untitled note" when the title is blank) rather than leaving those states blank.
- **"Recent" has no defined window.** I implemented it as "edited in the last 7 days" — an assumption, not something drawn anywhere.

## Responsiveness

No screen uses a fixed pixel width for content — cards, headers, and the FAB all use flexible layout (`Expanded`, `Wrap`, unconstrained text wrapping) inside a `ResponsivePageBody` that caps content at a max width and centers it on screens wider than a phone, instead of letting it stretch edge-to-edge or float stranded in the middle. Text fields and note titles/bodies have no `maxLines` cap, so device text-scale settings grow the layout instead of clipping or overflowing it.

Checked via:
- `flutter test`, which renders the list at widths 320/414/800/1200 crossed with text scales 1.0/1.3/2.0 and both empty and populated content states (`test/widget_test.dart`).
- A manual run on an iPhone 16 Pro simulator (iOS 18.6) to confirm the empty state against the Figma frame by eye; I did not get to repeat that pass at a large text scale or on a tablet-sized simulator in this session.

## AI usage

See [`AI/context.md`](AI/context.md) for the brief I used. This app was built with AI assistance (Claude Code) end to end — architecture, implementation, review, refactoring, testing, and this documentation. The Figma file was only ever viewed (the challenge grants view access, not Dev Mode), and every visual decision came from looking at the design and comparing it against the running app by eye, the same way any engineer without export/inspect access would work.
