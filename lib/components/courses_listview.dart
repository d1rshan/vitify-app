import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:vitify/models/course.dart';
import 'package:vitify/riverpod/providers.dart';

class CoursesListView extends ConsumerStatefulWidget {
  const CoursesListView({super.key});

  @override
  ConsumerState<CoursesListView> createState() => CoursesListViewState();
}

class CoursesListViewState extends ConsumerState<CoursesListView> {
  late List<Course> courses;
  @override
  void initState() {
    super.initState();
    courses = ref.read(coursesProvider); // read or watch here
  }

  final Map<String, double> gradePoints = {
    'S': 10.0,
    'A': 9.0,
    'B': 8.0,
    'C': 7.0,
    'D': 6.0,
  };

  void calculateGpa(courseGrades) {
    // final courseGrades = ref.read(courseGradesProvider);

    if (courseGrades.isNotEmpty && !courseGrades.contains(null)) {
      double totalPoints = 0;
      double totalCredits = 0;
      for (var i = 0; i < courses.length; i++) {
        totalPoints += courses[i].credits * gradePoints[courseGrades[i]!]!;
        totalCredits += courses[i].credits;
      }

      ref.read(gpaProvider.notifier).update((state) {
        return totalPoints / totalCredits;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseGrades = ref.watch(courseGradesProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!courseGrades.contains(null)) {
        calculateGpa(courseGrades);
      }
    });

    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    courses[index].courseName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Credits: ${courses[index].credits}'),
                ],
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary, // Background color of the button
                // border: Border.all(color: Colors.black, width: 1.5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: DropdownButton<String>(
                iconSize: 28,
                icon: const Icon(Icons.arrow_drop_down_rounded),
                iconEnabledColor: Theme.of(context).colorScheme.secondary,
                underline: Container(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                dropdownColor: Theme.of(context).colorScheme.primary,
                focusColor: Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                value: courseGrades[index],
                hint: Text(
                  'Grade  ',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                items: gradePoints.keys.map((String grade) {
                  return DropdownMenuItem<String>(
                    value: grade,
                    child: Text(
                      grade,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  ref.read(courseGradesProvider.notifier).update((state) {
                    state[index] = value;
                    return [...state]; // Return a new list to trigger rebuild
                  });
                  if (!courseGrades.contains(null)) {
                    // calculateGpa();
                    var box = Hive.box('vitify');
                    box.put('course_grades', courseGrades);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
