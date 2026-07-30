import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/localization/app_language_provider.dart';
import '../../core/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<AppLanguageProvider>(context);
    final themeProvider = Provider.of<AppThemeProvider>(context);
    final isBn = langProvider.isBangla;

    return Scaffold(
      appBar: AppBar(
        title: Text(isBn ? 'সেটিংস' : 'Settings', style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // APPEARANCE
          _buildSectionHeader(isBn ? 'অ্যাপিয়ারেন্স' : 'APPEARANCE'),
          SwitchListTile(
            secondary: const Icon(Icons.wb_sunny_outlined, color: AppColors.primary),
            title: Text(isBn ? 'ডার্ক মোড' : 'Dark Mode'),
            subtitle: Text(themeProvider.isDarkMode ? 'Dark mode active' : 'Light mode active'),
            activeColor: AppColors.primary,
            value: themeProvider.isDarkMode,
            onChanged: (val) => themeProvider.toggleTheme(val),
          ),
          const SizedBox(height: 20),

          // LANGUAGE
          _buildSectionHeader(isBn ? 'ভাষা' : 'LANGUAGE'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !isBn ? AppColors.primary : Colors.grey.shade200,
                      foregroundColor: !isBn ? Colors.white : Colors.black87,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () => langProvider.setLanguage('en'),
                    child: const Text('English', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isBn ? AppColors.primary : Colors.grey.shade200,
                      foregroundColor: isBn ? Colors.white : Colors.black87,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () => langProvider.setLanguage('bn'),
                    child: const Text('বাংলা', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // NOTIFICATIONS
          _buildSectionHeader(isBn ? 'নোটিফিকেশন' : 'NOTIFICATIONS'),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_active_outlined, color: AppColors.primary),
            title: Text(isBn ? 'পুশ নোটিফিকেশন' : 'Push Notifications'),
            subtitle: Text(isBn ? 'টাস্ক এবং সেশনের খবর পান' : 'Get notified about tasks and sessions'),
            activeColor: AppColors.primary,
            value: _pushNotifications,
            onChanged: (val) => setState(() => _pushNotifications = val),
          ),
          const SizedBox(height: 20),

          // PRIVACY & SECURITY
          _buildSectionHeader(isBn ? 'গোপনীয়তা ও নিরাপত্তা' : 'PRIVACY & SECURITY'),
          ListTile(
            leading: const Icon(Icons.lock_outline_rounded, color: AppColors.primary),
            title: Text(isBn ? 'পাসওয়ার্ড পরিবর্তন' : 'Change Password'),
            subtitle: Text(isBn ? 'আপনার পাসওয়ার্ড আপডেট করুন' : 'Update your password'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.primary),
            title: Text(isBn ? 'গোপনীয়তা সেটিংস' : 'Privacy Settings'),
            subtitle: Text(isBn ? 'আপনার তথ্য ও ডেটা পরিচালনা করুন' : 'Manage your data and privacy'),
            onTap: () {},
          ),
          const SizedBox(height: 20),

          // ABOUT
          _buildSectionHeader(isBn ? 'সম্পর্কে' : 'ABOUT'),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded, color: AppColors.primary),
            title: const Text('Ashwash v1.0.0'),
            subtitle: const Text('Mental Wellness Support Platform'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.1),
      ),
    );
  }
}
