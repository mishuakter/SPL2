import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/language_provider.dart';

class QuickActionsGrid extends StatelessWidget {
  final Function(String route) onActionTap;

  const QuickActionsGrid({super.key, required this.onActionTap});

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);
    final isBn = langProvider.isBangla;

    final List<Map<String, dynamic>> actions = [
      {
        'id': 'knowledge_hub',
        'title': isBn ? 'নলেজ হাব' : 'Knowledge Hub',
        'icon': Icons.menu_book_rounded,
        'bgColor': const Color(0xFF6366F1), // Indigo
      },
      {
        'id': 'mind_game',
        'title': isBn ? 'মাইন্ড গেম' : 'Mind Game',
        'icon': Icons.sports_esports_rounded,
        'bgColor': const Color(0xFF8B5CF6), // Purple
      },
      {
        'id': 'browse_courses',
        'title': isBn ? 'কোর্স ব্রাউজ' : 'Browse Courses',
        'icon': Icons.collections_bookmark_rounded,
        'bgColor': const Color(0xFF0284C7), // Blue/Cyan
      },
      {
        'id': 'book_session',
        'title': isBn ? 'সেশন বুকিং' : 'Book Session',
        'icon': Icons.calendar_today_rounded,
        'bgColor': const Color(0xFFEC4899), // Pink
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isBn ? 'দ্রুত সেবা' : 'Quick Actions',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.6,
          ),
          itemBuilder: (context, index) {
            final action = actions[index];
            return Container(
              decoration: BoxDecoration(
                color: action['bgColor'],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: (action['bgColor'] as Color).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onActionTap(action['id']),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            action['icon'],
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            action['title'],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
