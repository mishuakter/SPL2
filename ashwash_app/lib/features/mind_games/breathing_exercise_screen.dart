import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/localization/app_language_provider.dart';
import '../../core/services/mind_games_repository.dart';

class BreathingExerciseScreen extends StatefulWidget {
  const BreathingExerciseScreen({Key? key}) : super(key: key);

  @override
  State<BreathingExerciseScreen> createState() => _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  Timer? _timer;
  int _secondsElapsed = 0;
  int _completedCycles = 0;
  int _score = 0;
  bool _isPlaying = false;
  String _phaseTextEn = 'Press Start to Begin';
  String _phaseTextBn = 'শুরু করতে স্টার্ট চাপুন';

  final MindGamesRepository _repo = MindGamesRepository();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _scaleAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  void _startExercise() {
    setState(() {
      _isPlaying = true;
      _secondsElapsed = 0;
      _completedCycles = 0;
      _score = 0;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _secondsElapsed++;
      });
    });

    _runBreathingCycle();
  }

  void _runBreathingCycle() async {
    if (!_isPlaying || !mounted) return;

    // Phase 1: Inhale (4s)
    setState(() {
      _phaseTextEn = 'Inhale deeply... (4s)';
      _phaseTextBn = 'দীর্ঘ শ্বাস নিন... (৪ সে)';
    });
    _animController.forward(from: 0.0);
    await Future.delayed(const Duration(seconds: 4));
    if (!_isPlaying || !mounted) return;

    // Phase 2: Hold (4s)
    setState(() {
      _phaseTextEn = 'Hold your breath... (4s)';
      _phaseTextBn = 'শ্বাস ধরে রাখুন... (৪ সে)';
    });
    await Future.delayed(const Duration(seconds: 4));
    if (!_isPlaying || !mounted) return;

    // Phase 3: Exhale (4s)
    setState(() {
      _phaseTextEn = 'Exhale slowly... (4s)';
      _phaseTextBn = 'ধীরে ধীরে শ্বাস ছাড়ুন... (৪ সে)';
    });
    _animController.reverse();
    await Future.delayed(const Duration(seconds: 4));
    if (!_isPlaying || !mounted) return;

    // Cycle Completed
    setState(() {
      _completedCycles++;
      _score += 10;
    });

    // Continue Next Cycle
    _runBreathingCycle();
  }

  void _stopExercise() async {
    _timer?.cancel();
    _animController.stop();
    setState(() {
      _isPlaying = false;
    });

    await _repo.saveGameScore(
      gameId: 'breathing',
      score: _score,
      durationSeconds: _secondsElapsed,
    );

    if (mounted) {
      _showResultModal();
    }
  }

  void _showResultModal() {
    final isBn = Provider.of<AppLanguageProvider>(context, listen: false).isBangla;

    String ratingEn = 'Needs Practice';
    String ratingBn = 'অনুশীলন প্রয়োজন';
    Color ratingColor = AppColors.warning;

    if (_completedCycles >= 5) {
      ratingEn = 'Excellent!';
      ratingBn = 'চমৎকার!';
      ratingColor = AppColors.success;
    } else if (_completedCycles >= 3) {
      ratingEn = 'Good Job!';
      ratingBn = 'ভালো কাজ!';
      ratingColor = AppColors.primary;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: ratingColor.withOpacity(0.15), shape: BoxShape.circle),
                child: Icon(Icons.sentiment_very_satisfied_rounded, color: ratingColor, size: 48),
              ),
              const SizedBox(height: 16),
              Text(
                isBn ? ratingBn : ratingEn,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: ratingColor),
              ),
              const SizedBox(height: 12),
              Text(
                isBn
                    ? 'আপনি $_completedCycles টি পূর্ণ শ্বাস-প্রশ্বাসের চক্র সম্পন্ন করেছেন!'
                    : 'You completed $_completedCycles full breathing cycles!',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, color: AppColors.warning),
                    const SizedBox(width: 8),
                    Text(
                      isBn ? 'অর্জিত স্কোর: +$_score' : 'Score Earned: +$_score',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(isBn ? 'সম্পন্ন' : 'Done', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBn = Provider.of<AppLanguageProvider>(context).isBangla;

    return Scaffold(
      appBar: AppBar(
        title: Text(isBn ? 'শ্বাস-প্রশ্বাসের ব্যায়াম' : 'Breathing Exercise', style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMetricBadge(isBn ? 'চক্র' : 'Cycles', '$_completedCycles'),
                  _buildMetricBadge(isBn ? 'স্কোর' : 'Score', '+$_score'),
                  _buildMetricBadge(isBn ? 'সময়' : 'Time', '${_secondsElapsed}s'),
                ],
              ),
              const Spacer(),

              // Breathing Animated Circle
              AnimatedBuilder(
                animation: _scaleAnim,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnim.value,
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.8),
                            AppColors.secondary.withOpacity(0.9),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 30 * _scaleAnim.value,
                            spreadRadius: 10 * _scaleAnim.value,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          child: const Icon(Icons.air_rounded, color: Colors.white, size: 60),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),

              Text(
                isBn ? _phaseTextBn : _phaseTextEn,
                textAlign: TextAlign.center,
                style: AppTypography.heading2(context),
              ),
              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isPlaying ? AppColors.danger : AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _isPlaying ? _stopExercise : _startExercise,
                  child: Text(
                    _isPlaying
                        ? (isBn ? 'সেশন শেষ করুন' : 'Finish Exercise')
                        : (isBn ? 'শুরু করুন' : 'Start Exercise'),
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricBadge(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primary)),
        ],
      ),
    );
  }
}
