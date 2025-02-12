import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:vitify/models/course.dart';
import 'package:vitify/riverpod/providers.dart';
import 'package:vitify/screens/main_page.dart';

class SetupPage extends ConsumerStatefulWidget {
  const SetupPage({super.key});

  @override
  ConsumerState<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends ConsumerState<SetupPage> {
  final List<String> messOptions = ["Veg", "Non-Veg", "Special"];
  final timetableController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.addListener(updateFormState);
    timetableController.addListener(updateFormState);
  }

  void updateFormState() {
    ref.read(formStateProvider.notifier).checkFields(
          nameController.text,
          timetableController.text,
          ref.read(selectedMessProvider),
        );
  }

  @override
  void dispose() {
    nameController.dispose();
    timetableController.dispose();
    super.dispose();
  }

  Future<void> fetchMessMenu(WidgetRef ref, String? userMess) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      DocumentSnapshot doc =
          await firestore.collection("mess").doc(userMess).get();

      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List menu = [];

        for (int i = 0; i < 7; i++) {
          List tempList = [];
          for (int j = 0; j < 4; j++) {
            String temp = data[i.toString()][j].replaceAll('\\n', '\n');
            tempList.add(temp);
          }
          menu.add(tempList);
        }

        ref.read(messMenuProvider.notifier).update((state) {
          return menu;
        });

        var box = Hive.box('vitify');
        box.put('mess_menu', menu);
      }
    } catch (e) {
      debugPrint("Error fetching mess menu: $e");
      // debugPrintStack(stackTrace: stack);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedMess = ref.watch(selectedMessProvider);
    final isButtonEnabled = ref.watch(formStateProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Setup Your Profile',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 15),
              Expanded(
                child: ListView(
                  physics: const ClampingScrollPhysics(),
                  children: [
                    Text(
                      'Your Name',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      style: Theme.of(context).textTheme.titleMedium,
                      controller: nameController,
                      decoration: InputDecoration(
                        fillColor: Colors.black,
                        hintText: 'Enter your name',
                        hintStyle: Theme.of(context).textTheme.bodyMedium,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Select Your Mess',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    // ),
                    const SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary, // Background color of the button
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton(
                            iconSize: 28,
                            icon: const Icon(Icons.arrow_drop_down_rounded),
                            iconEnabledColor:
                                Theme.of(context).colorScheme.secondary,
                            dropdownColor:
                                Theme.of(context).colorScheme.primary,
                            isExpanded: true,
                            value: selectedMess,
                            hint: Text(
                              'Mess',
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
                            borderRadius: BorderRadius.circular(15),
                            items: messOptions.map((mess) {
                              return DropdownMenuItem<String>(
                                value: mess,
                                child: Text(
                                  mess,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              ref.read(selectedMessProvider.notifier).state =
                                  value;
                              updateFormState();
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Your timetable',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      height: 400,
                      child: TextField(
                        textAlignVertical: TextAlignVertical.top,
                        maxLines: null,
                        expands: true,
                        keyboardType: TextInputType.multiline,
                        controller: timetableController,
                        style: Theme.of(context).textTheme.titleMedium,
                        decoration: InputDecoration(
                          constraints: const BoxConstraints(minHeight: 100),
                          hintText: 'Paste your timetable here!',
                          hintStyle: Theme.of(context).textTheme.bodyMedium,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              width: 1.5,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: isButtonEnabled
                          ? () async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => const Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                              );

                              // STORING TIMETABLE, NAME

                              String text = timetableController.text;
                              String name = nameController.text;
                              var box = Hive.box('vitify');
                              await box.put('timetable_text', text);
                              await box.put('user_name', name);
                              // Fetches mess menu from firebase & stores it
                              await fetchMessMenu(ref, selectedMess);

                              final courses =
                                  await compute<String, List<Course>>(
                                TimetableManager.parseTimetable,
                                text,
                              );
                              final timetable = await compute<List<Course>,
                                  List<List<Course>>>(
                                TimetableManager.organizeByDay,
                                courses,
                              );
                              ref.read(coursesProvider.notifier).update((ref) {
                                return courses;
                              });

                              ref
                                  .read(timetableProvider.notifier)
                                  .update((ref) {
                                return timetable;
                              });

                              ref
                                  .read(courseGradesProvider.notifier)
                                  .update((ref) {
                                return List.filled(courses.length, null);
                              });

                              ref.read(nameProvider.notifier).state = name;

                              await Future.delayed(Duration(seconds: 2));
                              if (!context.mounted) return;
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => MainPage()));
                            }
                          : null,
                      child: AnimatedContainer(
                        duration: Durations.long1,
                        curve: Curves.easeIn,
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isButtonEnabled
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
