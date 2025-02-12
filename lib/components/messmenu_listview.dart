import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitify/riverpod/providers.dart';

class MessMenuListviewBuilder extends ConsumerWidget {
  final int index;
  const MessMenuListviewBuilder({super.key, required this.index});

  String getText(int index) {
    if (index == 0) {
      return "Breakfast";
    } else if (index == 1) {
      return "Lunch";
    } else if (index == 2) {
      return "Snacks";
    }
    return "Dinner";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messMenu = ref.watch(messMenuProvider);
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, innerIndex) {
        return Container(
          width: MediaQuery.sizeOf(context).width - 60,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getText(innerIndex),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                messMenu[index][innerIndex],
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
