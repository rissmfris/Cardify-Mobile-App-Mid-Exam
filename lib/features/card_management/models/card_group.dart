import 'package:flutter/material.dart';

class CardGroup {
  final String id;
  final String title;
  final String groupType; // 'academic', 'organization', 'community'
  final Color backgroundColor;
  final List<String> items;

  const CardGroup({
    required this.id,
    required this.title,
    required this.groupType,
    required this.backgroundColor,
    required this.items,
  });

  CardGroup copyWith({
    String? id,
    String? title,
    String? groupType,
    Color? backgroundColor,
    List<String>? items,
  }) {
    return CardGroup(
      id: id ?? this.id,
      title: title ?? this.title,
      groupType: groupType ?? this.groupType,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      items: items ?? this.items,
    );
  }

  static List<CardGroup> get sampleGroups => [
        const CardGroup(
          id: 'grp_academic',
          title: 'Academic Card Group',
          groupType: 'academic',
          backgroundColor: Color(0xFF1E1E1E), // Slate dark
          items: [
            'Nirmana',
            'Teknologi Imersif',
            'Pemrograman Berorientasi Objek',
          ],
        ),
        const CardGroup(
          id: 'grp_organization',
          title: 'Organization Card Group',
          groupType: 'organization',
          backgroundColor: Color(0xFF0D62C3), // Vibrant blue
          items: [
            'Himapedia',
            'Perslima',
            'Badan Eksekutif Mahasiswa',
          ],
        ),
        const CardGroup(
          id: 'grp_community',
          title: 'Community Card Group',
          groupType: 'community',
          backgroundColor: Color(0xFF1E824C), // Forest green
          items: [
            'Bandung Book Party',
            'Bandung Bergerak ID',
            'AIESEC',
          ],
        ),
      ];
}

class CardTask {
  final String id;
  final String headerTitle;
  final String subject;
  final String taskName;
  final String dueDate;
  final String status;
  final String priority;
  final Color backgroundColor;
  final String? description;

  const CardTask({
    required this.id,
    required this.headerTitle,
    required this.subject,
    required this.taskName,
    required this.dueDate,
    this.status = 'On Progress',
    this.priority = 'Urgent',
    required this.backgroundColor,
    this.description,
  });

  CardTask copyWith({
    String? id,
    String? headerTitle,
    String? subject,
    String? taskName,
    String? dueDate,
    String? status,
    String? priority,
    Color? backgroundColor,
    String? description,
  }) {
    return CardTask(
      id: id ?? this.id,
      headerTitle: headerTitle ?? this.headerTitle,
      subject: subject ?? this.subject,
      taskName: taskName ?? this.taskName,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      description: description ?? this.description,
    );
  }

  static List<CardTask> get sampleAcademicTasks => [
        const CardTask(
          id: 'task_acad_1',
          headerTitle: 'Academic Card',
          subject: 'Nirmana',
          taskName: 'Membuat Nirmana 3D',
          dueDate: '12 September 2026',
          priority: 'Urgent',
          backgroundColor: Color(0xFF1E1E1E),
        ),
        const CardTask(
          id: 'task_acad_2',
          headerTitle: 'Academic Card',
          subject: 'Nirmana',
          taskName: 'Membuat Nirmana 3D',
          dueDate: '12 September 2026',
          priority: 'Medium',
          backgroundColor: Color(0xFF1E1E1E),
        ),
      ];

  static List<CardTask> get sampleOrganizationTasks => [
        const CardTask(
          id: 'task_org_1',
          headerTitle: 'Organization Card',
          subject: 'PERSLIMA',
          taskName: 'Liputan Dies Natalis',
          dueDate: '20 September 2026',
          priority: 'Medium',
          backgroundColor: Color(0xFF0D62C3),
        ),
        const CardTask(
          id: 'task_org_2',
          headerTitle: 'Organization Card',
          subject: 'Himapedia',
          taskName: 'Rapat Kerja Pengurus',
          dueDate: '22 September 2026',
          priority: 'Low',
          backgroundColor: Color(0xFF0D62C3),
        ),
      ];

  static List<CardTask> get sampleCommunityTasks => [
        const CardTask(
          id: 'task_comm_1',
          headerTitle: 'Community Card',
          subject: 'Dapur Seni Biru',
          taskName: 'Workshop Sketsa',
          dueDate: '25 September 2026',
          priority: 'Low',
          backgroundColor: Color(0xFF1E824C),
        ),
        const CardTask(
          id: 'task_comm_2',
          headerTitle: 'Community Card',
          subject: 'Bandung Book Party',
          taskName: 'Diskusi Buku Bulanan',
          dueDate: '28 September 2026',
          priority: 'Urgent',
          backgroundColor: Color(0xFF1E824C),
        ),
      ];

  static List<CardTask> getSampleTasksForGroup(String groupType) {
    final lower = groupType.toLowerCase();
    if (lower.contains('org')) {
      return sampleOrganizationTasks;
    } else if (lower.contains('comm')) {
      return sampleCommunityTasks;
    }
    return sampleAcademicTasks;
  }
}
