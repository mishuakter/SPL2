import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/localization/app_language_provider.dart';
import '../../core/services/api_service.dart';
import '../../data/models/specialist_model.dart';
import 'booking_screen.dart';

class SpecialistListScreen extends StatefulWidget {
  const SpecialistListScreen({Key? key}) : super(key: key);

  @override
  State<SpecialistListScreen> createState() => _SpecialistListScreenState();
}

class _SpecialistListScreenState extends State<SpecialistListScreen> {
  String _selectedTab = 'All';

  @override
  Widget build(BuildContext context) {
    final isBn = Provider.of<AppLanguageProvider>(context).isBangla;
    final specialists = ApiService().getMockSpecialists();

    return Scaffold(
      appBar: AppBar(
        title: Text(isBn ? 'বিশেষজ্ঞ গণ' : 'Experts', style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none_rounded), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs (All, Local, International)
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['All', 'Local', 'International'].map((tab) {
                final isSelected = _selectedTab == tab;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(tab),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold),
                    onSelected: (selected) {
                      setState(() => _selectedTab = tab);
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // Specialist List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: specialists.length,
              itemBuilder: (context, index) {
                final spec = specialists[index];
                return _buildSpecialistCard(spec, isBn);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialistCard(SpecialistModel spec, bool isBn) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary.withOpacity(0.15),
                child: Text(
                  spec.name.split(' ').last[0],
                  style: const TextStyle(color: AppColors.primary, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(spec.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            isBn ? 'উপলব্ধ' : 'Available',
                            style: const TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(isBn ? spec.titleBn : spec.titleEn, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(
                      '⭐ ${spec.rating} • ${spec.experienceYears} years exp',
                      style: const TextStyle(color: AppColors.warning, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '৳${spec.feeBdt}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => BookingScreen(specialist: spec)));
                },
                child: Text(isBn ? 'সেশন বুক করুন' : 'Book Session', style: const TextStyle(color: Colors.white, fontSize: 13)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
