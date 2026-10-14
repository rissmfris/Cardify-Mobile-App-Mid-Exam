import 'package:flutter/material.dart';
import 'card_item.dart';

class NotificationItem {
  final String id;
  final String title;
  final String subtitle;
  final String? secondaryDetail;
  final String cardTypeLabel;
  final String timeAgo;
  final String sectionGroup; // "Today", "Yesterday", "Wednesday"
  final CardCategory category;
  final Color indicatorColor;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    this.secondaryDetail,
    required this.cardTypeLabel,
    required this.timeAgo,
    required this.sectionGroup,
    required this.category,
    required this.indicatorColor,
  });

  static const List<NotificationItem> sampleNotifications = [
    // Today
    NotificationItem(
      id: 'n1',
      title: 'Desain dan Pemrograman Website',
      subtitle: 'Tomorrow, 14:00-16:00',
      cardTypeLabel: 'Schedule',
      timeAgo: '5h ago',
      sectionGroup: 'Today',
      category: CardCategory.academic,
      indicatorColor: Color(0xFF1E1E1E), // Slate dark
    ),
    NotificationItem(
      id: 'n2',
      title: 'Nirmana',
      subtitle: 'Membuat Nirmana 3D',
      secondaryDetail: 'Due date: Tomorrow, 23:59',
      cardTypeLabel: 'Academic Card',
      timeAgo: '6h ago',
      sectionGroup: 'Today',
      category: CardCategory.academic,
      indicatorColor: Color(0xFF1E1E1E), // Slate dark
    ),
    NotificationItem(
      id: 'n3',
      title: 'Rapat Bidang',
      subtitle: 'Rapat Bidang Kreatif',
      secondaryDetail: 'Tomorrow, 19.30 - 20:30',
      cardTypeLabel: 'Organization Card',
      timeAgo: '11h ago',
      sectionGroup: 'Today',
      category: CardCategory.organization,
      indicatorColor: Color(0xFF22C55E), // Vibrant Green
    ),

    // Yesterday
    NotificationItem(
      id: 'n4',
      title: 'Asset Sosmed',
      subtitle: 'Membuat Kebutuhan Asset Sosmed',
      secondaryDetail: 'Due date: Tomorrow, 23:59',
      cardTypeLabel: 'PKM Card',
      timeAgo: '1d ago',
      sectionGroup: 'Yesterday',
      category: CardCategory.pkm,
      indicatorColor: Color(0xFFF59E0B), // Warm Amber
    ),
    NotificationItem(
      id: 'n5',
      title: 'Proposal Final',
      subtitle: 'Finalisasi Proposal PKM-RE',
      secondaryDetail: 'Due date: Tomorrow, 23:59',
      cardTypeLabel: 'PKM Card',
      timeAgo: '1d ago',
      sectionGroup: 'Yesterday',
      category: CardCategory.pkm,
      indicatorColor: Color(0xFFF59E0B), // Warm Amber
    ),

    // Wednesday
    NotificationItem(
      id: 'n6',
      title: 'Teknologi Imersif',
      subtitle: 'Tomorrow, 14:00-16:00',
      cardTypeLabel: 'Schedule',
      timeAgo: '2d ago',
      sectionGroup: 'Wednesday',
      category: CardCategory.academic,
      indicatorColor: Color(0xFF1E1E1E), // Slate dark
    ),
    NotificationItem(
      id: 'n7',
      title: 'Rapat Umum 1',
      subtitle: 'Rapat Umum MBPM 1',
      secondaryDetail: 'Tomorrow, 19:30 - 20:30',
      cardTypeLabel: 'Organization Card',
      timeAgo: '2d ago',
      sectionGroup: 'Wednesday',
      category: CardCategory.organization,
      indicatorColor: Color(0xFF22C55E), // Vibrant Green
    ),
  ];
}
