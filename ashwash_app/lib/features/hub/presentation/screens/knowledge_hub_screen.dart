import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/knowledge_hub_provider.dart';
import '../../../../core/providers/language_provider.dart';

class KnowledgeHubScreen extends StatelessWidget {
  const KnowledgeHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hubProvider = Provider.of<KnowledgeHubProvider>(context);
    final langProvider = Provider.of<LanguageProvider>(context);
    final isBn = langProvider.isBangla;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filterTabs = [
      {'key': 'ALL', 'labelEn': 'All', 'labelBn': 'সব'},
      {'key': 'ARTICLE', 'labelEn': 'Articles', 'labelBn': 'নিবন্ধ'},
      {'key': 'VIDEO', 'labelEn': 'Videos', 'labelBn': 'ভিডিও'},
      {'key': 'AUDIO', 'labelEn': 'Audio', 'labelBn': 'অডিও'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(isBn ? 'নলেজ হাব' : 'Knowledge Hub'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Banner Title Card (Matching Figma Page 4 & 5)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isBn ? 'নলেজ হাব' : 'Knowledge Hub',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          isBn ? 'মানসিক স্বাস্থ্যবিষয়ক সম্পদ ও তথ্য' : 'Psychological resources & learning',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Horizontal Content Filter Pills (Matching Figma Page 4 bottom-right)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Row(
              children: filterTabs.map((tab) {
                final isSelected = hubProvider.selectedResourceFilter == tab['key'];
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(
                      isBn ? tab['labelBn']! : tab['labelEn']!,
                      style: TextStyle(
                        color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                    selectedColor: AppColors.primary,
                    backgroundColor: isDark ? AppColors.surfaceDark : Colors.grey.shade200,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onSelected: (selected) {
                      hubProvider.setResourceFilter(tab['key']!);
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // Resources ListView (Matching Figma Cards)
          Expanded(
            child: hubProvider.isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: hubProvider.resources.length,
                    itemBuilder: (context, index) {
                      final item = hubProvider.resources[index];
                      final type = item['content_type'] ?? 'ARTICLE';
                      IconData iconData;
                      Color iconColor;

                      switch (type) {
                        case 'VIDEO':
                          iconData = Icons.videocam_rounded;
                          iconColor = AppColors.categoryMother;
                          break;
                        case 'AUDIO':
                          iconData = Icons.headphones_rounded;
                          iconColor = AppColors.categorySpecialChild;
                          break;
                        case 'DOCUMENT':
                          iconData = Icons.description_rounded;
                          iconColor = AppColors.categorySingleParent;
                          break;
                        default:
                          iconData = Icons.article_rounded;
                          iconColor = AppColors.primary;
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardDark : AppColors.cardLight,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: iconColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(iconData, color: iconColor, size: 24),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['title'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: iconColor.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              item['content_type_display'] ?? type,
                                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: iconColor),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(Icons.access_time_rounded, size: 12, color: Colors.grey.shade500),
                                          const SizedBox(width: 4),
                                          Text(
                                            item['duration_display'] ?? '',
                                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              item['description'] ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Action Button (Read / Watch / Listen Pill Button matching Figma)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  _openResourceDetail(context, item);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                ),
                                child: Text(
                                  type == 'VIDEO' ? 'Watch' : (type == 'AUDIO' ? 'Listen' : 'Read'),
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _openResourceDetail(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                item['title'] ?? '',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Chip(label: Text(item['content_type_display'] ?? '')),
                  const SizedBox(width: 8),
                  Text('Duration: ${item['duration_display']}'),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                item['description'] ?? '',
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close Resource'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
