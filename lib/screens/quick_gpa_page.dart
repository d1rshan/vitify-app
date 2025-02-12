import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:vitify/components/courses_listview.dart';
import 'package:vitify/riverpod/providers.dart';

class QuickGpaPage extends ConsumerWidget {
  const QuickGpaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gpa = ref.watch(gpaProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Gpa Calculator',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 15),
        Expanded(child: CoursesListView()),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1.5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    'GPA: ${gpa.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ref.read(courseGradesProvider.notifier).update((state) {
                      return List.filled(state.length, null);
                    });
                    ref.read(gpaProvider.notifier).state = 0;
                    var box = Hive.box('vitify');
                    box.delete('course_grades');
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      'Reset',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
