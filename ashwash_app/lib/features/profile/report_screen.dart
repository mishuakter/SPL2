import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/localization/app_language_provider.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isBn = Provider.of<AppLanguageProvider>(context).isBangla;

    return Scaffold(
      appBar: AppBar(
        title: Text(isBn ? 'মানসিক স্বাস্থ্য রিপোর্ট' : 'Mental Health Report', style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Blue Header Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Text(
                    isBn ? 'আপনার যাত্রার সম্পূর্ণ রিপোর্ট' : 'Complete record of your journey',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(isBn ? 'রিপোর্ট ডাউনলোড শুরু হয়েছে...' : 'Downloading report PDF...')),
                      );
                    },
                    icon: const Icon(Icons.download_rounded, size: 20),
                    label: Text(isBn ? 'রিপোর্ট ডাউনলোড করুন' : 'Download Report', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Overview Section
            Text(isBn ? 'সংক্ষিপ্ত সারমর্ম' : 'Overview', style: AppTypography.heading2(context)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildOverviewTile('2', isBn ? 'কোর্সে এনরোলড' : 'Courses Enrolled', Icons.menu_book_rounded),
                _buildOverviewTile('3', isBn ? 'পাঠ সম্পন্ন' : 'Lessons Completed', Icons.trending_up_rounded),
                _buildOverviewTile('5', isBn ? 'সেশনে অংশগ্রহণ' : 'Sessions Attended', Icons.calendar_today_rounded),
                _buildOverviewTile('450', isBn ? 'পয়েন্ট অর্জিত' : 'Points Earned', Icons.military_tech_rounded),
              ],
            ),
            const SizedBox(height: 24),

            // Doctor Feedback Section
            Text(isBn ? 'বিশেষজ্ঞের মতামত' : 'Specialist Notes', style: AppTypography.heading2(context)),
            const SizedBox(height: 12),
            _buildDoctorFeedbackCard(
              'Dr. Ayesha Rahman',
              'April 15, 2026',
              'Great progress in managing anxiety. Patient shows significant improvement in coping strategies.',
            ),
            const SizedBox(height: 12),
            _buildDoctorFeedbackCard(
              'Dr. Ayesha Rahman',
              'April 22, 2026',
              'Patient is actively participating in sessions and completing homework assignments regularly.',
            ),
            const SizedBox(height: 24),

            // Treatment Timeline
            Text(isBn ? 'চিকিৎসার টাইমলাইন' : 'Treatment Timeline', style: AppTypography.heading2(context)),
            const SizedBox(height: 12),
            _buildTimelineItem('Apr 1, 2026', 'Started New Mother Wellness Program'),
            _buildTimelineItem('Apr 5, 2026', 'First session with Dr. Ayesha Rahman'),
            _buildTimelineItem('Apr 12, 2026', 'Completed Module 1'),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTile(String count, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 4),
          Text(count, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildDoctorFeedbackCard(String name, String date, String note) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary.withOpacity(0.2),
                child: const Text('D', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (_) => const Icon(Icons.star, color: Colors.amber, size: 16)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(note, style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.3)),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String date, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            child: const Icon(Icons.check, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
