import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../core/navigation/app_navigator.dart';
import '../../../../injectable.dart';
import '../notes_theme.dart';
import '../stores/notes_store.dart';
import '../widgets/note_card.dart';
import '../widgets/notes_icon_button.dart';
import '../widgets/notes_illustration_state.dart';
import '../widgets/responsive_page_body.dart';

@RoutePage()
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final NotesStore _store;
  late final TextEditingController _controller;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _store = getIt<NotesStore>();
    _controller = TextEditingController(text: _store.searchQuery);
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navigator = getIt<AppNavigator>();

    return Scaffold(
      backgroundColor: NotesColors.background,
      body: SafeArea(
        child: ResponsivePageBody(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                _SearchField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onChanged: _store.setSearchQuery,
                  onBack: () => navigator.pop(),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Observer(
                    builder: (context) {
                      if (_store.searchQuery.trim().isEmpty) {
                        return const SizedBox.shrink();
                      }
                      final results = _store.searchResults;
                      if (results.isEmpty) {
                        return const NotesIllustrationState(
                          assetPath: 'assets/images/no_search_results.png',
                          message: 'File not found. Try searching again.',
                        );
                      }
                      return ListView.separated(
                        itemCount: results.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final note = results[index];
                          return NoteCard(
                            note: note,
                            showFavoriteBadge: true,
                            onTap: () => navigator.push(
                              NoteReadingRoute(noteId: note.id),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onBack,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NotesIconButton(
          icon: Icons.arrow_back,
          semanticLabel: 'Back',
          onTap: onBack,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Material(
            color: NotesColors.surfaceButton,
            borderRadius: BorderRadius.circular(30),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              style: const TextStyle(color: NotesColors.textPrimary, fontSize: 17),
              decoration: InputDecoration(
                hintText: 'Search by the keyword...',
                hintStyle: const TextStyle(color: NotesColors.textMuted, fontSize: 17),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                suffixIcon: ValueListenableBuilder(
                  valueListenable: controller,
                  builder: (context, value, _) {
                    if (value.text.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return IconButton(
                      icon: const Icon(Icons.close, color: NotesColors.textMuted),
                      onPressed: () {
                        controller.clear();
                        onChanged('');
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
