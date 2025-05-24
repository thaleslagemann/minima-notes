import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minima_notes/core/theme/theme.dart';
import 'package:minima_notes/core/widgets/minima_drawer.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> settings = [
      'Test',
      'Notes',
      'Account',
      'Acessibility',
    ];

    return Scaffold(
      drawer: MinimaDrawer(index: 1),
      appBar: AppBar(
        backgroundColor: AppTheme.grey10,
        title: const Text(
          'Settings',
          style: TextStyle(color: AppTheme.white),
        ),
        foregroundColor: AppTheme.white,
        actions: const [],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: AppTheme.white),
              child: ListView.builder(
                itemCount: settings.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(settings[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
