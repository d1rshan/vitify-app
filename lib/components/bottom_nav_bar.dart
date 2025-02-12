import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:vitify/riverpod/providers.dart';

class MyBottomNavBar extends ConsumerWidget {
  const MyBottomNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 5),
      child: GNav(
        selectedIndex: ref.watch(selectedTabProvider),
        duration: const Duration(milliseconds: 100),
        onTabChange: (index) {
          ref.read(selectedTabProvider.notifier).state = index;
        },
        mainAxisAlignment: MainAxisAlignment.center,
        backgroundColor: Colors.transparent,
        activeColor: Theme.of(context).colorScheme.secondary,
        color: Theme.of(context).colorScheme.primary,
        tabBackgroundColor: Theme.of(context).colorScheme.primary,
        tabBorderRadius: 15,
        tabMargin: const EdgeInsets.symmetric(horizontal: 5),
        gap: 8,
        tabs: const [
          GButton(
            icon: Icons.calendar_month,
          ),
          GButton(
            icon: Icons.restaurant,
          ),
          GButton(
            icon: Icons.calculate,
          ),
          GButton(
            icon: Icons.settings,
          ),
        ],
      ),
    );
  }
}
