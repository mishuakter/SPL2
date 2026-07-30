import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/localization/app_language_provider.dart';
import 'core/services/auth_service.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AshwashApp());
}

class AshwashApp extends StatelessWidget {
  const AshwashApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppThemeProvider()),
        ChangeNotifierProvider(create: (_) => AppLanguageProvider()),
        Provider(create: (_) => AuthService()),
      ],
      child: Consumer2<AppThemeProvider, AppLanguageProvider>(
        builder: (context, themeProvider, langProvider, child) {
          return MaterialApp(
            title: 'Ashwash (আশ্বাস)',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: AppThemeProvider.lightTheme,
            darkTheme: AppThemeProvider.darkTheme,
            home: const OnboardingScreen(),
          );
        },
      ),
    );
  }
}
