import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitify/models/course.dart';
import 'package:vitify/riverpod/providers.dart';

// TO-DO:
// text theme to be matched from theme.dart throughout the app

class TimeTableListViewBuilder extends ConsumerWidget {
  final int index;

  const TimeTableListViewBuilder({
    super.key,
    required this.index,
  });

  String getNormalTime(String timeSlot) {
    List<String> times = timeSlot.split(' - '); // Split the string by " - "

    String convertTo12Hour(String time) {
      int hour = int.parse(time.split(':')[0]);
      int minute = int.parse(time.split(':')[1]);

      String period = hour >= 12 ? 'PM' : 'AM';
      hour = hour % 12;
      hour = hour == 0 ? 12 : hour; // Convert 0 hour to 12 for AM

      return '$hour:${minute.toString().padLeft(2, '0')}$period';
    }

    String startTime = convertTo12Hour(times[0]);
    String endTime = convertTo12Hour(times[1]);

    return '$startTime - $endTime';
  }

  void onTap(
    BuildContext context,
    Course course,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(25),
          height: 231,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.courseName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    course.courseCode,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'Faculty: ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: course.facultyName,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: 'Venue: ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: course.venue,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      course.slot,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timetable = ref.watch(timetableProvider);
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: timetable[index].length,
      itemBuilder: (context, innerIndex) {
        String timeSlot = timetable[index][innerIndex].timeSlot ?? 'default';
        Course course = timetable[index][innerIndex];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: InkWell(
            // splashColor: Colors.greenAccent,
            borderRadius: BorderRadius.circular(15),
            onTap: () => onTap(context, course),
            child: Container(
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.courseCode,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(getNormalTime(timeSlot)),
                    ],
                  ),
                  const Icon(
                    Icons.keyboard_arrow_right,
                    size: 28,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
