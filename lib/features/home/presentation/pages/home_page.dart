import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../notes/presentation/pages/notes_list_page.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const NotesListPage();
  }
}
