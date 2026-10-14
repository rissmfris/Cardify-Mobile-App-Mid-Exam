import 'package:flutter/material.dart';

enum CardCategory {
  all,
  academic,
  organization,
  community,
  pkm,
}

class CardItem {
  final String id;
  final CardCategory category;
  final String headerTitle;
  final String subtitle;
  final String taskName;
  final String dueDate;
  final String status;
  final String priority;
  final Color backgroundColor;

  const CardItem({
    required this.id,
    required this.category,
    required this.headerTitle,
    required this.subtitle,
    required this.taskName,
    required this.dueDate,
    this.status = 'On Progress',
    this.priority = 'Urgent',
    required this.backgroundColor,
  });

  CardItem copyWith({
    String? id,
    CardCategory? category,
    String? headerTitle,
    String? subtitle,
    String? taskName,
    String? dueDate,
    String? status,
    String? priority,
    Color? backgroundColor,
  }) {
    return CardItem(
      id: id ?? this.id,
      category: category ?? this.category,
      headerTitle: headerTitle ?? this.headerTitle,
      subtitle: subtitle ?? this.subtitle,
      taskName: taskName ?? this.taskName,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  static const List<CardItem> sampleCards = [
    CardItem(
      id: '1',
      category: CardCategory.academic,
      headerTitle: 'Academic Card',
      subtitle: 'Nirmana',
      taskName: 'Membuat Nirmana 3D',
      dueDate: '12 September 2026',
      priority: 'Urgent',
      backgroundColor: Color(0xFF1E1E1E), // Slate dark
    ),
    CardItem(
      id: '2',
      category: CardCategory.organization,
      headerTitle: 'Organization Card',
      subtitle: 'Himapedia',
      taskName: 'Rapat Umum 2 MBPM',
      dueDate: '12 September 2026',
      priority: 'Medium',
      backgroundColor: Color(0xFF0D62C3), // Vibrant blue
    ),
    CardItem(
      id: '3',
      category: CardCategory.community,
      headerTitle: 'Community Card',
      subtitle: 'Creative Bandung Book Party',
      taskName: 'Feeds Content',
      dueDate: '12 September 2026',
      priority: 'Low',
      backgroundColor: Color(0xFF1E824C), // Emerald green
    ),
  ];
}
