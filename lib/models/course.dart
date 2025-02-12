class Course {
  late String courseName;
  late String courseCode;
  late String slot;
  late String venue;
  late String facultyName;
  late String facultyDepartment;
  late double credits;

  String? timeSlot;

  List<DayTimeSlot> dayTimeSlots = [];

  Course({
    required this.courseName,
    required this.courseCode,
    required this.slot,
    required this.venue,
    required this.facultyName,
    required this.facultyDepartment,
    required this.credits,
    this.timeSlot,
    this.dayTimeSlots = const [],
  });
}

class TimeSlot {
  final String start;
  final String end;

  TimeSlot(this.start, this.end);
}

class DayTimeSlot {
  final String day;
  final TimeSlot time;

  DayTimeSlot(this.day, this.time);
}

class TimetableManager {
  // Theory time slots
  static final List<TimeSlot> theoryTimeSlots = [
    TimeSlot('08:00', '08:50'),
    TimeSlot('08:55', '09:45'),
    TimeSlot('09:50', '10:40'),
    TimeSlot('10:45', '11:35'),
    TimeSlot('11:40', '12:30'),
    TimeSlot('12:35', '13:25'),
    TimeSlot('14:00', '14:50'),
    TimeSlot('14:55', '15:45'),
    TimeSlot('15:50', '16:40'),
    TimeSlot('16:45', '17:35'),
    TimeSlot('17:40', '18:30'),
    TimeSlot('18:35', '19:25'),
  ];

  // Lab time slots
  static final List<TimeSlot> labTimeSlots = [
    TimeSlot('08:00', '08:50'),
    TimeSlot('08:50', '09:40'),
    TimeSlot('09:50', '10:40'),
    TimeSlot('10:40', '11:30'),
    TimeSlot('11:40', '12:30'),
    TimeSlot('12:30', '13:20'),
    TimeSlot('14:00', '14:50'),
    TimeSlot('14:50', '15:40'),
    TimeSlot('15:50', '16:40'),
    TimeSlot('16:40', '17:30'),
    TimeSlot('17:40', '18:30'),
    TimeSlot('18:30', '19:20'),
  ];

  // Complete slot mapping
  static final Map<String, Map<String, int>> slotDayMapping = {
    'MON': {
      'A1': 0,
      'F1': 1,
      'D1': 2,
      'TB1': 3,
      'TG1': 4,
      'S11': 5,
      'A2': 6,
      'F2': 7,
      'D2': 8,
      'TB2': 9,
      'TG2': 10,
      'S3': 11,
      'L1': 0,
      'L2': 1,
      'L3': 2,
      'L4': 3,
      'L5': 4,
      'L6': 5,
      'L31': 6,
      'L32': 7,
      'L33': 8,
      'L34': 9,
      'L35': 10,
      'L36': 11
    },
    'TUE': {
      'B1': 0,
      'G1': 1,
      'E1': 2,
      'TC1': 3,
      'TAA1': 4,
      'B2': 6,
      'G2': 7,
      'E2': 8,
      'TC2': 9,
      'TAA2': 10,
      'S1': 11,
      'L7': 0,
      'L8': 1,
      'L9': 2,
      'L10': 3,
      'L11': 4,
      'L12': 5,
      'L37': 6,
      'L38': 7,
      'L39': 8,
      'L40': 9,
      'L41': 10,
      'L42': 11
    },
    'WED': {
      'C1': 0,
      'A1': 1,
      'F1': 2,
      'TD1': 3,
      'TBB1': 4,
      'C2': 6,
      'A2': 7,
      'F2': 8,
      'TD2': 9,
      'TBB2': 10,
      'S4': 11,
      'L13': 0,
      'L14': 1,
      'L15': 2,
      'L16': 3,
      'L17': 4,
      'L18': 5,
      'L43': 6,
      'L44': 7,
      'L45': 8,
      'L46': 9,
      'L47': 10,
      'L48': 11
    },
    'THU': {
      'D1': 0,
      'B1': 1,
      'G1': 2,
      'TE1': 3,
      'TCC1': 4,
      'D2': 6,
      'B2': 7,
      'G2': 8,
      'TE2': 9,
      'TCC2': 10,
      'S2': 11,
      'L19': 0,
      'L20': 1,
      'L21': 2,
      'L22': 3,
      'L23': 4,
      'L24': 5,
      'L49': 6,
      'L50': 7,
      'L51': 8,
      'L52': 9,
      'L53': 10,
      'L54': 11
    },
    'FRI': {
      'E1': 0,
      'C1': 1,
      'TA1': 2,
      'TF1': 3,
      'TDD1': 4,
      'S15': 5,
      'E2': 6,
      'C2': 7,
      'TA2': 8,
      'TF2': 9,
      'TDD2': 10,
      'L25': 0,
      'L26': 1,
      'L27': 2,
      'L28': 3,
      'L29': 4,
      'L30': 5,
      'L55': 6,
      'L56': 7,
      'L57': 8,
      'L58': 9,
      'L59': 10,
      'L60': 11
    }
  };

  static List<List<Course>> organizeByDay(List<Course> courses) {
    List<List<Course>> weekSchedule = List.generate(7, (index) => []);

    for (var course in courses) {
      // Split multiple slots if present (e.g., "L9+L10+L13+L14")
      var slots = course.slot.split('+');

      for (var slotCode in slots) {
        slotCode = slotCode.trim();
        bool isLab = slotCode.startsWith('L');

        // Check each day's slot mapping
        slotDayMapping.forEach((day, slots) {
          if (slots.containsKey(slotCode)) {
            int timeIndex = slots[slotCode]!;
            TimeSlot timeSlot =
                isLab ? labTimeSlots[timeIndex] : theoryTimeSlots[timeIndex];

            // Create a copy of the course with the specific time
            var courseCopy = Course(
                courseName: course.courseName,
                courseCode: course.courseCode,
                slot: slotCode,
                venue: course.venue,
                facultyName: course.facultyName,
                facultyDepartment: course.facultyDepartment,
                credits: course.credits,
                timeSlot: '${timeSlot.start} - ${timeSlot.end}');

            // Add to appropriate day
            switch (day) {
              case 'MON':
                weekSchedule[1].add(courseCopy);
                break;
              case 'TUE':
                weekSchedule[2].add(courseCopy);
                break;
              case 'WED':
                weekSchedule[3].add(courseCopy);
                break;
              case 'THU':
                weekSchedule[4].add(courseCopy);
                break;
              case 'FRI':
                weekSchedule[5].add(courseCopy);
                break;
            }
          }
        });
      }
    }

    // Sort each day's courses by time slot
    for (var daySchedule in weekSchedule) {
      daySchedule
          .sort((a, b) => (a.timeSlot ?? '').compareTo(b.timeSlot ?? ''));
    }

    return weekSchedule;
  }

  static List<Course> parseTimetable(String timetableText) {
    final coursePattern = RegExp(
      r'([A-Z]{4}\d{3}[A-Z]{1,2})\s*-\s*([^\n]+?)\s*\n\s*' // Course code and name
      r'\([^)]+\)\s*\n\s*' // Course type in parentheses
      r'\d+\s+\d+\s+\d+\s+\d+\s+(\d+\.?\d*)\s*\n' // Credits pattern
      r'[^\n]*\n\s*Regular\s*\n\s*' // Skip category and course option
      r'[A-Z0-9]+\s*\n\s*' // Skip class number
      r'([A-Z0-9+]+(?:\+[A-Z0-9]+)*)\s*-\s*\n\s*' // Slot
      r'([A-Z0-9 -]+?)\s*\n\s*' // Venue
      r'([^-\n]+?)\s*-\s*\n\s*' // Faculty name
      r'([A-Z]+)', // Faculty department
      multiLine: true,
      dotAll: true,
    );

    final matches = coursePattern.allMatches(timetableText);
    return matches.map((match) {
      return Course(
        courseCode: match.group(1) ?? '',
        courseName: match.group(2)?.trim() ?? '',
        credits: double.parse(match.group(3)?.trim() ?? ''),
        slot: match.group(4)?.trim() ?? '',
        venue: match.group(5)?.trim() ?? '',
        facultyName: match.group(6)?.trim() ?? '',
        facultyDepartment: match.group(7)?.trim() ?? '',
      );
    }).toList();
  }
}
