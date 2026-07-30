import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/localization/app_language_provider.dart';
import '../../core/services/mind_games_repository.dart';

class MoodMatchScreen extends StatefulWidget {
  const MoodMatchScreen({Key? key}) : super(key: key);

  @override
  State<MoodMatchScreen> createState() => _MoodMatchScreenState();
}

class _MoodMatchScreenState extends State<MoodMatchScreen> {
  int _score = 0;
  int _currentIndex = 0;
  String? _selectedMood;
  bool _showFeedback = false;
  bool _isCorrect = false;

  final MindGamesRepository _repo = MindGamesRepository();

  final List<Map<String, String>> _questions = [
    {
      'situationEn': 'Achieving your daily mindfulness goal',
      'situationBn': 'আপনার দৈনিক মাইন্ডফুলনেস লক্ষ্য অর্জন',
      'correctMood': 'Happy',
      'emoji': '😊',
    },
    {
      'situationEn': 'Feeling overwhelmed before a big exam or presentation',
      'situationBn': 'পরীক্ষা বা প্রেজেন্টেশনের আগে মানসিক চাপ অনুভব করা',
      'correctMood': 'Anxious',
      'emoji': '😰',
    },
    {
      'situationEn': 'Listening to soft ocean waves during meditation',
      'situationBn': 'মেডিটেশনের সময় শান্ত সাগরের ঢেউয়ের শব্দ শোনা',
      'correctMood': 'Calm',
      'emoji': '🧘',
    },
    {
      'situationEn': 'Losing an important project or missing a goal',
      'situationBn': 'একটি গুরুত্বপূর্ণ প্রজেক্টে ব্যর্থ হওয়া',
      'correctMood': 'Sad',
      'emoji': '😔',
    },
    {
      'situationEn': 'Receiving unexpected good news from a family member',
      'situationBn': 'পরিবারের সদস্যের কাছ থেকে অপ্রত্যাশিত শুভ সংবাদ পাওয়া',
      'correctMood': 'Excited',
      'emoji': '😃',
    },
  ];

  final List<Map<String, String>> _moodOptions = [
    {'mood': 'Happy', 'emoji': '😊'},
    {'mood': 'Anxious', 'emoji': '😰'},
    {'mood': 'Calm', 'emoji': '🧘'},
    {'mood': 'Sad', 'emoji': '😔'},
    {'mood': 'Excited', 'emoji': '😃'},
    {'mood': 'Angry', 'emoji': '😠'},
  ];

  void _onMoodSelect(String mood) {
    if (_showFeedback) return;

    final currentQuestion = _questions[_currentIndex];
    final correct = mood == currentQuestion['correctMood'];

    setState(() {
      _selectedMood = mood;
      _showFeedback = true;
      _isCorrect = correct;
      if (correct) {
        _score += 5;
      }
    });

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      if (_currentIndex < _questions.length - 1) {
        setState(() {
          _currentIndex++;
          _showFeedback = false;
          _selectedMood = null;
        });
      } else {
        _onGameComplete();
      }
    });
  }

  void _onGameComplete() async {
    await _repo.saveGameScore(
      gameId: 'mood_match',
      score: _score,
      durationSeconds: 45,
    );

    if (mounted) {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    final isBn = Provider.of<AppLanguageProvider>(context, listen: false).isBangla;

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
                decoration: const BoxDecoration(color: Color(0xFFFEF3C7), shape: BoxShape.circle),
                child: const Icon(Icons.stars_rounded, color: AppColors.warning, size: 48),
              ),
              const SizedBox(height: 16),
              Text(
                isBn ? 'চমৎকার সম্পন্ন হয়েছে!' : 'Great Emotional Awareness!',
                style: AppTypography.heading1(context),
              ),
              const SizedBox(height: 8),
              Text(
                isBn
                    ? 'আপনি বিভিন্ন পরিস্থিতির সাথে সঠিক আবেগ শনাক্ত করতে পেরেছেন!'
                    : 'You accurately matched emotional responses to situations!',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  isBn ? 'মোট অর্জিত পয়েন্ট: +$_score' : 'Total Points: +$_score',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary),
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
                    Navigator.pop(context);
                  },
                  child: Text(isBn ? 'সম্পন্ন' : 'Complete', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isBn = Provider.of<AppLanguageProvider>(context).isBangla;
    final currentQ = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(isBn ? 'মুড ম্যাচ' : 'Mood Match', style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_currentIndex + 1} / ${_questions.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      isBn ? 'স্কোর: +$_score' : 'Score: +$_score',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_currentIndex + 1) / _questions.length,
                  minHeight: 6,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.all(24),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    const Text('🤔', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 14),
                    Text(
                      isBn ? currentQ['situationBn']! : currentQ['situationEn']!,
                      textAlign: TextAlign.center,
                      style: AppTypography.heading2(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              Text(
                isBn ? 'উপযুক্ত আবেগ নির্বাচন করুন:' : 'Match with the correct emotion:',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 14),

              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.2,
                  ),
                  itemCount: _moodOptions.length,
                  itemBuilder: (context, index) {
                    final item = _moodOptions[index];
                    final mood = item['mood']!;
                    final isSelected = _selectedMood == mood;

                    Color cardBg = Theme.of(context).cardColor;
                    Color borderColor = Colors.grey.shade300;

                    if (_showFeedback && isSelected) {
                      cardBg = _isCorrect ? AppColors.success.withOpacity(0.15) : AppColors.danger.withOpacity(0.15);
                      borderColor = _isCorrect ? AppColors.success : AppColors.danger;
                    }

                    return GestureDetector(
                      onTap: () => _onMoodSelect(mood),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(item['emoji']!, style: const TextStyle(fontSize: 22)),
                            const SizedBox(width: 8),
                            Text(mood, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
