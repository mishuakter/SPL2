import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/localization/app_language_provider.dart';
import '../../core/services/mind_games_repository.dart';
import 'breathing_exercise_screen.dart';
import 'memory_match_screen.dart';
import 'mood_match_screen.dart';

class MindGamesHubScreen extends StatefulWidget {
  const MindGamesHubScreen({Key? key}) : super(key: key);

  @override
  State<MindGamesHubScreen> createState() => _MindGamesHubScreenState();
}

class _MindGamesHubScreenState extends State<MindGamesHubScreen> {
  final MindGamesRepository _repo = MindGamesRepository();
  int _breathingBest = 0;
  int _memoryBest = 0;
  int _moodBest = 0;

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  void _loadScores() async {
    final bBest = await _repo.getBestScore('breathing');
    final mBest = await _repo.getBestScore('memory_match');
    final moBest = await _repo.getBestScore('mood_match');

    if (mounted) {
      setState(() {
        _breathingBest = bBest;
        _memoryBest = mBest;
        _moodBest = moBest;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBn = Provider.of<AppLanguageProvider>(context).isBangla;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isBn ? 'মাইন্ড গেমস' : 'Mind Games',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              isBn ? 'মানসিক প্রশান্তি ও অনুশীলনী' : 'Mental Wellness & Focus Games',
              style: AppTypography.heading1(context),
            ),
            const SizedBox(height: 6),
            Text(
              isBn
                  ? 'বিজ্ঞানভিত্তিক মাইন্ডফুলনেস গেমের মাধ্যমে চাপ কমান ও মনোযোগ বাড়ান'
                  : 'Reduce stress & boost focus with science-backed mindfulness games',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Game 1 Card: Breathing Exercise
            _buildGameCard(
              title: isBn ? 'শ্বাস-প্রশ্বাসের ব্যায়াম' : 'Breathing Exercise',
              subtitle: isBn ? 'ইনহেল (৪সে) • হোল্ড (৪সে) • এক্সহেল (৪সে)' : 'Inhale (4s) • Hold (4s) • Exhale (4s)',
              imagePath: 'assets/images/breathing_exercise_icon.jpg',
              bestScore: _breathingBest,
              gradientColors: [const Color(0xFF8B5CF6), const Color(0xFF6D28D9)],
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => const BreathingExerciseScreen()));
                _loadScores();
              },
            ),
            const SizedBox(height: 16),

            // Game 2 Card: Memory Match
            _buildGameCard(
              title: isBn ? 'মেমরি ম্যাচ' : 'Memory Match',
              subtitle: isBn ? 'কার্ড উল্টে জোড়া মিলানোর অনুশীলন' : 'Flip cards to match wellness symbols',
              imagePath: 'assets/images/memory_match_icon.jpg',
              bestScore: _memoryBest,
              gradientColors: [const Color(0xFFEC4899), const Color(0xFFBE185D)],
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => const MemoryMatchScreen()));
                _loadScores();
              },
            ),
            const SizedBox(height: 16),

            // Game 3 Card: Mood Match
            _buildGameCard(
              title: isBn ? 'মুড ম্যাচ' : 'Mood Match',
              subtitle: isBn ? 'পরিস্থিতির সাথে সঠিক আবেগ ম্যাচ করুন' : 'Match emotions with daily scenarios',
              imagePath: 'assets/images/mood_match_icon.jpg',
              bestScore: _moodBest,
              gradientColors: [const Color(0xFFF97316), const Color(0xFFC2410C)],
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => const MoodMatchScreen()));
                _loadScores();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard({
    required String title,
    required String subtitle,
    required String imagePath,
    required int bestScore,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    imagePath,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Best Score: $bestScore',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
