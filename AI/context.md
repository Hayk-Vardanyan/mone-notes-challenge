# Context for an AI assistant working on this repo

This is a small offline Flutter notes app built on top of a pre-existing internal
boilerplate. Read this before touching anything — the boilerplate carries a lot
of scaffolding that looks like it wants a backend and mostly doesn't have one.

## What this app actually is

One feature: notes. A note is a plain-text `title` + `body`, nothing else. No
rich text, no markdown, no tags, no folders, no sync, no auth, no backend. If
you find yourself reaching for a rendering/parsing library for note content,
stop — that's out of scope by design, not an oversight.

Everything lives under `lib/features/notes/`. `lib/features/home/` exists only
because `AppRouter`'s initial route resolves to a class named `HomePage`
(auto_route derives the route name from the page class name via
`replaceInRouteName: 'Page,Route'`) — it's a one-line pass-through to
`NotesListPage`, not a real feature.

## Architecture — match what's already there, don't introduce a second way

- **DI**: `get_it` + `injectable`. New services/stores get `@singleton` or
  `@LazySingleton(as: SomeInterface)` and are resolved via `getIt<T>()`.
  Constructor injection, not service locators sprinkled through business logic
  — `getIt<T>()` calls belong in widgets/pages, not inside stores/repositories
  (stores take their dependencies as constructor params).
- **State management**: MobX (`mobx` + `flutter_mobx`), not Bloc/Riverpod/Provider-as-state.
  The pattern is always: `class Foo = _Foo with _$Foo;` +
  `abstract class _Foo with Store { ... }`, with `@observable`/`@computed`/`@action`.
  Look at `lib/features/notes/presentation/stores/notes_store.dart` before writing
  a new store. Read UI state with `Observer(builder: ...)`, not `context.watch`
  or `StreamBuilder` on the store directly.
- **Routing**: `auto_route`. Routes are declared in `lib/core/navigation/app_router.dart`
  and generated into `app_router.gr.dart`. Page widgets get `@RoutePage()`.
  **You must run build_runner after adding/changing a route** (see Codegen below)
  — the route class (`FooRoute`) does not exist until generation runs, and the
  IDE/analyzer will show real-looking errors ("undefined name FooRoute") that
  are not bugs in your code, just generation being stale.
- **Persistence**: `shared_preferences`, used as a single JSON blob for the
  whole notes list (`SharedPreferencesNotesRepository`). Don't add a database
  package (`sqflite`, `drift`, `isar`, ...) for this — the data model and
  volume don't need one, and doing so would contradict the "small thing done
  well" spirit of this repo.
- **Models**: `freezed` + `json_serializable`. `@freezed sealed class Foo with _$Foo`,
  factory constructor, `factory Foo.fromJson(...)`. Every freezed model needs both
  `part 'foo.freezed.dart';` and `part 'foo.g.dart';` if it's JSON-serializable.

## Codegen — the single most common source of false "errors"

This repo uses `build_runner` for freezed, json_serializable, mobx_codegen,
injectable, auto_route, and flutter_gen. After changing any file that has a
`part 'x.g.dart'`/`part 'x.gr.dart'`/`part 'x.freezed.dart'` directive, an
`@RoutePage()`, an `@injectable`/`@singleton` annotation, or after adding an
asset file, **you must run**:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Until you do, the analyzer will report errors like "The method 'copyWith' isn't
defined", "Target of URI hasn't been generated", or "Undefined name
'FooRoute'" for code that is actually correct. Do not "fix" these by writing
the generated code by hand, and do not remove the annotation/part directive to
make the error go away — run the generator. Generated files (`*.g.dart`,
`*.gr.dart`, `*.freezed.dart`, `*.config.dart`, `injectable.config.dart`) are
not committed; assume they don't exist until you generate them.

## Design fidelity

The UI comes from a Figma file with view-only access — no Dev Mode, no
inspect panel, no exported assets, and no measurement tooling, per the
challenge brief's explicit instruction to match the design by eye rather
than to a spec. Visual values in
`lib/features/notes/presentation/notes_theme.dart` (colors, spacing, type
sizes) were approximated through careful visual comparison against the
design and screenshots of it, aiming to preserve the overall spacing
rhythm and visual hierarchy rather than reproduce exact pixel values —
treat them as close approximations, not measured constants. If you're
changing a notes screen, match that file's tokens rather than inventing
new colors/sizes inline.

The Figma frames also have real gaps and internal contradictions (an info
button with no destination screen, two different editor-header icon sets across
frames, no defined "Recent" time window, no bundled Nunito font). These are
listed with the reasoning behind each call in `README.md` under "Design
notes." Don't silently "fix" a Figma inconsistency by picking a different
interpretation without checking that section first — it documents which
reading was already chosen and why, and a change should update that doc too.

## Things this codebase should never do

- Never use `Dismissible` for the swipe gestures — it's explicitly excluded by
  the challenge brief this app was built against; swipe-to-favorite/delete is
  hand-rolled in `SwipeableNoteCard`.
- Never add a rich-text/markdown rendering package or a "formatting" feature
  that actually does something — the formatting toolbar in the editor is
  intentionally decorative.
- Never add a backend, auth, or sync — this app has none and isn't supposed to.
- Don't reach for `Dismissible`, a new state management library, or a new DI
  approach "because it's simpler" — consistency with the one pattern already
  in the repo matters more than local optimality for a codebase this size.
- Don't hardcode pixel widths/heights for note content (title/body text,
  cards). The brief requires the UI to survive arbitrary widths and text-scale
  settings; every layout decision here was made with that constraint, and a
  hardcoded size is very likely to be a responsiveness regression, not a
  simplification.

## Testing

`test/widget_test.dart` renders the notes list across a matrix of widths and
text scales using a fake `NotesRepository` — no real `SharedPreferences`, no
real DI graph beyond what that test registers by hand. If you add a test for
another screen, follow the same pattern (`getIt.reset()` + register fakes
in `setUp`/inline, don't rely on the production DI graph in `injectable.config.dart`
being fully wired, since some services there hit real platform channels
network stacks that don't exist in the test environment).
