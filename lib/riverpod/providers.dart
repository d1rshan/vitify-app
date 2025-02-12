import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitify/models/course.dart';

// TIME TABLE AND MESS MENU PAGE
final greetingProvider = Provider<String>((ref) {
  final hour = DateTime.now().hour;

  if (hour < 12) {
    return 'Good Morning';
  } else if (hour < 16) {
    return 'Good Afternoon';
  } else {
    return 'Good Evening';
  }
});

final nameProvider = StateProvider<String>((ref) => '');
final selectedDayProvider = StateProvider<int>((ref) {
  int today = DateTime.now().weekday;
  return (today == 7) ? 0 : today;
});

// TIME TABLE PAGE
final timetableProvider = StateProvider<List<List<Course>>>((ref) => []);

// MESS MENU PAGE
final messMenuProvider = StateProvider<List>((ref) => []);

// QUICK GPA CALC PAGE
final coursesProvider = StateProvider<List<Course>>((ref) => []);
final courseGradesProvider = StateProvider<List<String?>>((ref) => []);
final gpaProvider = StateProvider<double>((ref) => 0.0);

// UNIVERSAL (whatev)
final selectedTabProvider = StateProvider<int>((ref) => 0);
final themeProvider = StateProvider<bool>((ref) => false);

// SETUP PAGE
final selectedMessProvider = StateProvider<String?>((ref) => null);

// StateNotifier to manage form state
class FormStateNotifier extends StateNotifier<bool> {
  FormStateNotifier() : super(false);

  void checkFields(String name, String timetable, String? mess) {
    state = name.isNotEmpty && timetable.isNotEmpty && mess != null;
  }
}

// Riverpod provider for form state
final formStateProvider = StateNotifierProvider<FormStateNotifier, bool>((ref) {
  return FormStateNotifier();
});
