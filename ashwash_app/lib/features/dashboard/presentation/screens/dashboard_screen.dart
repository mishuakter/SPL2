import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/dashboard_provider.dart';
import '../../../../core/providers/language_provider.dart';
import '../widgets/mood_selector_widget.dart';
import '../widgets/progress_summary_card.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/emergency_unit_banner.dart';
import '../widgets/my_courses_list.dart';
import '../../../mood/presentation/screens/progress_details_screen.dart';
import '../../../hub/presentation/screens/knowledge_hub_screen.dart';
import '../../../hub/presentation/screens/mind_games_screen.dart';
import '../../../courses/presentation/screens/course_catalog_screen.dart';
import '../../../courses/presentation/screens/course_detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    final langProvider = Provider.of<LanguageProvider>(context);
    final isBn = langProvider.isBangla;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'আশ্বাস',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, size: 28),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notifications: 2 new updates available.')),
                  );
                },
              ),
              if (dashboardProvider.hasUnreadNotifications)
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.emergency,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: dashboardProvider.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: () => dashboardProvider.fetchDashboardData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Greeting Header (Matching Figma Page 4)
                    Row(
                      children: [
                        Text(
                          isBn ? 'স্বাগতম!' : 'Welcome back! 👋',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Saturday, July 25',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 1. Mood Tracker Sentiment Card
                    const MoodSelectorWidget(),
                    const SizedBox(height: 24),

                    // 2. Your Progress Section
                    ProgressSummaryCard(
                      onViewAll: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProgressDetailsScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // 3. Quick Actions 2x2 Grid
                    QuickActionsGrid(
                      onActionTap: (route) {
                        if (route == 'knowledge_hub') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const KnowledgeHubScreen()),
                          );
                        } else if (route == 'mind_game') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const MindGamesScreen()),
                          );
                        } else if (route == 'browse_courses') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CourseCatalogScreen(
                                categoryId: 'FIRST_TIME_MOTHER',
                                categoryTitle: 'First Time Mother',
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Navigating to $route...')),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 24),

                    // 4. Big Red Emergency Unit Banner Button
                    EmergencyUnitBanner(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Emergency Hotline Triggered: Connecting to specialist...'),
                            backgroundColor: AppColors.emergency,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // 5. My Courses Section
                    MyCoursesList(
                      onViewAll: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CourseCatalogScreen(
                              categoryId: 'FIRST_TIME_MOTHER',
                              categoryTitle: 'First Time Mother',
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }
}
