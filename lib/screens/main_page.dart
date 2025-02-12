import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitify/components/bottom_nav_bar.dart';
import 'package:vitify/riverpod/providers.dart';
import 'package:vitify/screens/mess_menu_page.dart';
import 'package:vitify/screens/quick_gpa_page.dart';
import 'package:vitify/screens/settings_page.dart';
import 'package:vitify/screens/timetable_page.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTabProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: SafeArea(
        child: SizedBox.expand(
          child: IndexedStack(
            index: selectedTab,
            children: [
              // PAGE 1 -> TIMETABLE
              TimetablePage(),

              // PAGE 2 -> MESS MENU
              MessMenuPage(),

              // PAGE 3 -> GPA CALC
              QuickGpaPage(),

              // PAGE 4 -> SETTINGS
              const SettingsPage(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }
}
