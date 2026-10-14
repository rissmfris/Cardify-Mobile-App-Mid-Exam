/// Domain models for Academic Schedule in Cardify.
class ScheduleEntry {
  final String id;
  final String subject;
  final String time;

  const ScheduleEntry({
    required this.id,
    required this.subject,
    required this.time,
  });

  ScheduleEntry copyWith({
    String? id,
    String? subject,
    String? time,
  }) {
    return ScheduleEntry(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      time: time ?? this.time,
    );
  }
}

class DaySchedule {
  final String dayName;
  final List<ScheduleEntry> entries;

  const DaySchedule({
    required this.dayName,
    required this.entries,
  });

  DaySchedule copyWith({
    String? dayName,
    List<ScheduleEntry>? entries,
  }) {
    return DaySchedule(
      dayName: dayName ?? this.dayName,
      entries: entries ?? this.entries,
    );
  }

  /// Default mock schedule dataset derived directly from the design document.
  static List<DaySchedule> get sampleWeeklySchedule => [
        const DaySchedule(
          dayName: 'Monday',
          entries: [
            ScheduleEntry(
              id: 'mon-1',
              subject: 'Psikologi Persepsi',
              time: '09.20 - 12.00',
            ),
            ScheduleEntry(
              id: 'mon-2',
              subject: 'Algoritma & Struktur Data',
              time: '13.00 - 16.00',
            ),
          ],
        ),
        const DaySchedule(
          dayName: 'Tuesday',
          entries: [
            ScheduleEntry(
              id: 'tue-1',
              subject: 'Landasan Pendidikan',
              time: '07.00 - 08.40',
            ),
            ScheduleEntry(
              id: 'tue-2',
              subject: 'Olahraga & Kebugaran',
              time: '08.40 - 10.20',
            ),
          ],
        ),
        const DaySchedule(
          dayName: 'Wednesday',
          entries: [
            ScheduleEntry(
              id: 'wed-1',
              subject: 'Psikologi Pendidikan',
              time: '07.50 - 09.30',
            ),
            ScheduleEntry(
              id: 'wed-2',
              subject: 'Design Thinking',
              time: '09.30 - 12.00',
            ),
            ScheduleEntry(
              id: 'wed-3',
              subject: 'Pendidikan Kewarganegaraan',
              time: '13.00 - 14.40',
            ),
          ],
        ),
        const DaySchedule(
          dayName: 'Thursday',
          entries: [
            ScheduleEntry(
              id: 'thu-1',
              subject: 'Pengelolaan Kelas',
              time: '08.30 - 10.20',
            ),
            ScheduleEntry(
              id: 'thu-2',
              subject: 'Kurikulum & Pembelajaran',
              time: '10.20 - 12.00',
            ),
          ],
        ),
        const DaySchedule(
          dayName: 'Friday',
          entries: [],
        ),
      ];
}
