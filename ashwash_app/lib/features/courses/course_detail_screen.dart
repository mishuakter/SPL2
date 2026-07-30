import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/localization/app_language_provider.dart';
import '../../data/models/course_model.dart';

class CourseDetailScreen extends StatelessWidget {
  final CourseModel course;
  const CourseDetailScreen({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isBn = Provider.of<AppLanguageProvider>(context).isBangla;

    return Scaffold(
      appBar: AppBar(
        title: Text(isBn ? course.titleBn : course.titleEn),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_circle_fill_rounded, size: 60, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(
                    isBn ? 'ভিডিও পাঠ চালু করুন' : 'Watch Intro Lesson',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(isBn ? course.titleBn : course.titleEn, style: AppTypography.heading1(context)),
            const SizedBox(height: 8),
            Text(isBn ? course.descriptionBn : course.descriptionEn, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 24),
            Text(isBn ? 'কোর্স মডিউলসমূহ' : 'Course Modules', style: AppTypography.heading2(context)),
            const SizedBox(height: 12),
            _buildLessonItem(context, '1. Introduction to Wellness', '15 mins', true),
            _buildLessonItem(context, '2. Managing Daily Anxiety', '20 mins', false),
            _buildLessonItem(context, '3. Building Healthy Coping Habits', '25 mins', false),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonItem(BuildContext context, String title, String duration, bool isCompleted) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(
            isCompleted ? Icons.check_circle_rounded : Icons.play_circle_outline_rounded,
            color: isCompleted ? AppColors.success : AppColors.primary,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          Text(duration, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
