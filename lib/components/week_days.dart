import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitify/riverpod/providers.dart';

class WeekDays extends ConsumerWidget {
  final PageController controller;
  WeekDays({super.key, required this.controller});

  final List<String> days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDayProvider);
    // Adjust width logic
    return SizedBox(
      width: MediaQuery.sizeOf(context).width - 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          7,
          (index) => GestureDetector(
            onTap: () {
              // animation of pages goes here ig
              ref.read(selectedDayProvider.notifier).state = index;

              // controller.animateToPage(index,
              //     duration: Duration(milliseconds: 200),
              //     curve: Curves.bounceInOut);
            },
            child: Container(
              alignment: Alignment.center,
              width: (MediaQuery.sizeOf(context).width - 40) / 8,
              height: (MediaQuery.sizeOf(context).height * 0.07 > 55)
                  ? MediaQuery.sizeOf(context).height * 0.07
                  : 55,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(15),
                color: (index == selectedDay)
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary,
              ),
              padding: const EdgeInsets.all(15),
              child: Text(
                days[index],
                style: TextStyle(
                  color: (index == selectedDay)
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
