import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitify/components/messmenu_listview.dart';
import 'package:vitify/components/week_days.dart';
import 'package:vitify/riverpod/providers.dart';

class MessMenuPage extends ConsumerStatefulWidget {
  const MessMenuPage({super.key});

  @override
  ConsumerState<MessMenuPage> createState() => _MessMenuPageState();
}

class _MessMenuPageState extends ConsumerState<MessMenuPage> {
  late String name;
  late String greeting;
  late PageController controller;

  @override
  void initState() {
    super.initState();
    name = ref.read(nameProvider);
    greeting = ref.read(greetingProvider);
    controller = PageController(initialPage: ref.read(selectedDayProvider));
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(selectedDayProvider, (prev, next) {
      controller.animateToPage(next,
          duration: Duration(milliseconds: 150), curve: Curves.bounceInOut);
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '$greeting,\n$name',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: WeekDays(
            controller: controller,
          ),
        ),
        const SizedBox(height: 15),
        Expanded(
          child: PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            pageSnapping: true,
            controller: controller,
            itemCount: 7,
            itemBuilder: (context, index) => GestureDetector(
              onHorizontalDragEnd: (details) {
                int selectedDay = ref.read(selectedDayProvider);
                if (details.primaryVelocity! > 0 && selectedDay > 0) {
                  // Right Swipe
                  ref.read(selectedDayProvider.notifier).update((state) {
                    return index - 1;
                  });
                } else if (details.primaryVelocity! < 0 && selectedDay < 6) {
                  // Left Swipe
                  ref.read(selectedDayProvider.notifier).update((state) {
                    return index + 1;
                  });
                }
              },
              child: MessMenuListviewBuilder(index: index),
            ),
          ),
        ),
      ],
    );
  }
}
