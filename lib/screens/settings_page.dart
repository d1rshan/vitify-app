import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:vitify/riverpod/providers.dart';
import 'package:vitify/screens/setup_page.dart';

// TO DO -> on clearing details, reset all the states
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            'Settings',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dark Mode',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                CupertinoSwitch(
                  thumbColor: Theme.of(context).colorScheme.secondary,
                  inactiveTrackColor: Theme.of(context).colorScheme.primary,
                  activeTrackColor: Theme.of(context).colorScheme.primary,
                  value: ref.watch(themeProvider),
                  onChanged: (value) {
                    ref.read(themeProvider.notifier).state = value;
                    var box = Hive.box('vitify');
                    box.put('theme_data', value);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CupertinoActivityIndicator(),
                ),
              );

              ref.read(themeProvider.notifier).state = false;

              await Future.delayed(Duration(seconds: 2));

              // RESET STATES
              ref.read(selectedDayProvider.notifier).update((ref) {
                int today = DateTime.now().weekday;
                return (today == 7) ? 0 : today;
              });

              ref.read(selectedTabProvider.notifier).state = 0;
              ref.read(selectedMessProvider.notifier).state = null;
              // ref.read(messMenuProvider.notifier).state = [];
              ref.read(gpaProvider.notifier).state = 0;
              var box = Hive.box('vitify');
              await box.deleteAll([
                'timetable_text',
                'theme_data',
                'course_grades',
                'mess_menu',
                'user_name'
              ]);

              // COURSES AND TIMETABLE PROVIDER, Course Grades (+ NAME) WILL BE RESET AT SETUPPAGE AGAIN
              if (!context.mounted) return;
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => SetupPage(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                'Edit your details\n(This will reset your data!)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
