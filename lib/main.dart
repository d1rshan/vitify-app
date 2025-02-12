import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vitify/firebase_options.dart';
import 'package:vitify/models/course.dart';
import 'package:vitify/riverpod/providers.dart';
import 'package:vitify/screens/main_page.dart';
import 'package:vitify/screens/setup_page.dart';
import 'package:vitify/themes/theme.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures await operations first and then app runs
  await Hive.initFlutter();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var box = await Hive.openBox('vitify');

  final dynamic text = box.get('timetable_text', defaultValue: '');

  final dynamic isDarkMode = box.get('theme_data', defaultValue: false);
  final dynamic list = box.get('course_grades', defaultValue: []);
  final name = box.get('user_name', defaultValue: '');
  final messMenu = box.get('mess_menu', defaultValue: [
    ['', '', '', ''],
    ['', '', '', ''],
    ['', '', '', ''],
    ['', '', '', ''],
    ['', '', '', ''],
    ['', '', '', ''],
    ['', '', '', '']
  ]);

  List<String?> courseGrades = [];
  final bool isTimetableSet = text.isNotEmpty;

  late List<Course> courses;
  late List<List<Course>> timetable;

  if (isTimetableSet) {
    courses = await compute<String, List<Course>>(
      TimetableManager.parseTimetable,
      text,
    );
    timetable = await compute<List<Course>, List<List<Course>>>(
      TimetableManager.organizeByDay,
      courses,
    );
  } else {
    courses = [];
    timetable = [];
  }

  if (list.isNotEmpty) {
    for (int i = 0; i < list.length; i++) {
      courseGrades.add(list[i]);
    }
  } else {
    courseGrades = List.filled(courses.length, null);
  }

  runApp(
    ProviderScope(
      overrides: [
        messMenuProvider.overrideWith((ref) => messMenu),
        nameProvider.overrideWith((ref) => name),
        coursesProvider.overrideWith((ref) => courses),
        timetableProvider.overrideWith((ref) => timetable),
        courseGradesProvider.overrideWith((ref) => courseGrades),
        themeProvider.overrideWith((ref) => isDarkMode),
      ],
      child: MyApp(
        isTimetableSet: isTimetableSet,
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final bool isTimetableSet;

  const MyApp({super.key, required this.isTimetableSet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'vitify',
      theme: lightMode,
      darkTheme: darkMode,
      debugShowCheckedModeBanner: false,
      themeMode: ref.watch(themeProvider) ? ThemeMode.dark : ThemeMode.light,
      home: Builder(
        builder: (context) {
          if (isTimetableSet) return MainPage();
          return SetupPage();
        },
      ),
      routes: <String, Widget Function(BuildContext)>{
        '/setupPage': (BuildContext context) => SetupPage(),
        '/mainPage': (BuildContext context) => MainPage(),
      },
    );
  }
}
