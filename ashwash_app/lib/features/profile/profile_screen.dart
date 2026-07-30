import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/localization/app_language_provider.dart';
import '../../core/services/auth_service.dart';
import '../auth/login_screen.dart';
import 'settings_screen.dart';
import 'report_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isBn = Provider.of<AppLanguageProvider>(context).isBangla;
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(isBn ? 'প্রোফাইল' : 'Profile', style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none_rounded), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // User Avatar & Name
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primary,
              child: Text(
                user?.username.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Text(user?.username ?? 'User', style: AppTypography.heading2(context)),
            Text(user?.email ?? 'user@example.com', style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 24),

            // Stats Cards Row
            Row(
              children: [
                Expanded(child: _buildStatBox(context, '2', isBn ? 'কোর্সসমূহ' : 'Courses', Icons.menu_book_rounded)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatBox(context, '5', isBn ? 'সেশন' : 'Sessions', Icons.calendar_today_rounded)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatBox(context, '450', isBn ? 'পয়েন্ট' : 'Points', Icons.military_tech_rounded)),
              ],
            ),
            const SizedBox(height: 24),

            // Menu List
            _buildMenuItem(
              context,
              isBn ? 'মানসিক স্বাস্থ্য রিপোর্ট' : 'Reports',
              Icons.assessment_outlined,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportScreen())),
            ),
            _buildMenuItem(
              context,
              isBn ? 'সেটিংস' : 'Settings',
              Icons.settings_outlined,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
            ),
            _buildMenuItem(
              context,
              isBn ? 'অর্জনসমূহ' : 'Achievements',
              Icons.emoji_events_outlined,
              () {},
            ),
            _buildMenuItem(
              context,
              isBn ? 'অগ্রগতি' : 'Progress',
              Icons.trending_up_rounded,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportScreen())),
            ),
            _buildMenuItem(
              context,
              isBn ? 'নোটিফিকেশন' : 'Notifications',
              Icons.notifications_outlined,
              () {},
            ),
            _buildMenuItem(
              context,
              isBn ? 'সাহায্য ও সহায়তা' : 'Help & Support',
              Icons.help_outline_rounded,
              () {},
            ),
            const SizedBox(height: 16),

            // Logout Button
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: AppColors.danger),
              title: Text(
                isBn ? 'লগআউট' : 'Logout',
                style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                authService.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(BuildContext context, String count, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 6),
          Text(count, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
