import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/localization/app_language_provider.dart';
import '../../core/services/mind_games_repository.dart';

class MemoryMatchScreen extends StatefulWidget {
  const MemoryMatchScreen({Key? key}) : super(key: key);

  @override
  State<MemoryMatchScreen> createState() => _MemoryMatchScreenState();
}

class _MemoryMatchScreenState extends State<MemoryMatchScreen> {
  String _difficulty = 'Easy';
  List<String> _cards = [];
  List<bool> _cardFlipped = [];
  List<bool> _cardMatched = [];

  int _firstFlippedIndex = -1;
  bool _isProcessing = false;
  int _moves = 0;
  int _matchesFound = 0;
  int _totalPairs = 2;
  int _secondsElapsed = 0;
  Timer? _timer;
  bool _gameStarted = false;

  final MindGamesRepository _repo = MindGamesRepository();

  final List<String> _allSymbols = ['🌸', '🍃', '💜', '🌙', '☀️', '💧'];

  @override
  void initState() {
    super.initState();
    _startNewGame('Easy');
  }

  void _startNewGame(String level) {
    _timer?.cancel();
    setState(() {
      _difficulty = level;
      _moves = 0;
      _matchesFound = 0;
      _secondsElapsed = 0;
      _firstFlippedIndex = -1;
      _isProcessing = false;
      _gameStarted = true;

      if (level == 'Easy') {
        _totalPairs = 2;
      } else if (level == 'Medium') {
        _totalPairs = 4;
      } else {
        _totalPairs = 6;
      }

      List<String> selectedSymbols = _allSymbols.sublist(0, _totalPairs);
      _cards = [...selectedSymbols, ...selectedSymbols]..shuffle();

      _cardFlipped = List.generate(_cards.length, (_) => false);
      _cardMatched = List.generate(_cards.length, (_) => false);
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && _gameStarted) {
        setState(() => _secondsElapsed++);
      }
    });
  }

  void _onCardTap(int index) {
    if (_isProcessing || _cardFlipped[index] || _cardMatched[index]) return;

    setState(() {
      _cardFlipped[index] = true;
    });

    if (_firstFlippedIndex == -1) {
      _firstFlippedIndex = index;
    } else {
      _moves++;
      _isProcessing = true;
      int secondIndex = index;

      if (_cards[_firstFlippedIndex] == _cards[secondIndex]) {
        setState(() {
          _cardMatched[_firstFlippedIndex] = true;
          _cardMatched[secondIndex] = true;
          _matchesFound++;
          _firstFlippedIndex = -1;
          _isProcessing = false;
        });

        if (_matchesFound == _totalPairs) {
          _onGameComplete();
        }
      } else {
        Timer(const Duration(milliseconds: 800), () {
          if (mounted) {
            setState(() {
              _cardFlipped[_firstFlippedIndex] = false;
              _cardFlipped[secondIndex] = false;
              _firstFlippedIndex = -1;
              _isProcessing = false;
            });
          }
        });
      }
    }
  }

  void _onGameComplete() async {
    _timer?.cancel();
    setState(() => _gameStarted = false);

    int baseScore = _totalPairs * 20;
    int movePenalty = _moves * 2;
    int calculatedScore = (baseScore - movePenalty).clamp(10, 200);

    await _repo.saveGameScore(
      gameId: 'memory_match',
      score: calculatedScore,
      durationSeconds: _secondsElapsed,
    );

    if (mounted) {
      _showCompletionDialog(calculatedScore);
    }
  }

  void _showCompletionDialog(int score) {
    final isBn = Provider.of<AppLanguageProvider>(context, listen: false).isBangla;

    int stars = 3;
    if (_moves > _totalPairs * 2.5) {
      stars = 1;
    } else if (_moves > _totalPairs * 1.5) {
      stars = 2;
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => Icon(
                    Icons.star_rounded,
                    size: 40,
                    color: index < stars ? AppColors.warning : Colors.grey.shade300,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isBn ? 'অভিনন্দন!' : 'Congratulations!',
                style: AppTypography.heading1(context),
              ),
              const SizedBox(height: 8),
              Text(
                isBn
                    ? 'আপনি ${_secondsElapsed} সেকেন্ডে এবং $_moves পদক্ষেপে সকল জোড়া মেলাতে সক্ষম হয়েছেন!'
                    : 'Matched all pairs in ${_secondsElapsed}s with $_moves moves!',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  isBn ? 'স্কোর: +$score' : 'Score: +$score',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _startNewGame(_difficulty);
                      },
                      icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
                      label: Text(isBn ? 'আবার খেলুন' : 'Replay', style: const TextStyle(color: AppColors.primary)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
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
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBn = Provider.of<AppLanguageProvider>(context).isBangla;

    return Scaffold(
      appBar: AppBar(
        title: Text(isBn ? 'মেমরি ম্যাচ' : 'Memory Match', style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ['Easy', 'Medium', 'Hard'].map((level) {
                  final isSelected = _difficulty == level;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(level),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (selected) {
                        if (selected) _startNewGame(level);
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMetricTile(isBn ? 'পদক্ষেপ' : 'Moves', '$_moves'),
                  _buildMetricTile(isBn ? 'জোড়া' : 'Matches', '$_matchesFound/$_totalPairs'),
                  _buildMetricTile(isBn ? 'সময়' : 'Time', '${_secondsElapsed}s'),
                ],
              ),
              const SizedBox(height: 30),

              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _totalPairs > 4 ? 3 : 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: _cards.length,
                  itemBuilder: (context, index) {
                    final isFlipped = _cardFlipped[index] || _cardMatched[index];
                    return GestureDetector(
                      onTap: () => _onCardTap(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: isFlipped ? AppColors.primary : AppColors.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _cardMatched[index] ? AppColors.success : AppColors.primary.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            isFlipped ? _cards[index] : '🧘',
                            style: TextStyle(fontSize: isFlipped ? 36 : 28),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => _startNewGame(_difficulty),
                  icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
                  label: Text(isBn ? 'রিস্টার্ট করুন' : 'Restart Game', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
        ],
      ),
    );
  }
}
