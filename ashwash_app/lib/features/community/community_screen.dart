import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/localization/app_language_provider.dart';
import '../../core/services/api_service.dart';
import '../../data/models/community_model.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  String _selectedTag = 'All';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<String> _tags = ['All', 'Success Story', 'Question', 'Support'];

  @override
  Widget build(BuildContext context) {
    final isBn = Provider.of<AppLanguageProvider>(context).isBangla;

    return Scaffold(
      appBar: AppBar(
        title: Text(isBn ? 'কমিউনিটি' : 'Community', style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none_rounded), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Filter Tags Bar
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _tags.length,
              itemBuilder: (context, index) {
                final tag = _tags[index];
                final isSelected = _selectedTag == tag;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(tag),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (selected) {
                      setState(() => _selectedTag = tag);
                    },
                  ),
                );
              },
            ),
          ),

          // Realtime StreamBuilder from Cloud Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('community_posts')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text(isBn ? 'ত্রুটি ঘটেছে' : 'Error loading posts'));
                }

                List<PostModel> postsList = [];

                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  postsList = snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return PostModel(
                      id: doc.id.hashCode,
                      authorAlias: data['authorAlias'] ?? 'Anonymous',
                      content: data['content'] ?? '',
                      tag: data['tag'] ?? 'Support',
                      isAnonymous: data['isAnonymous'] ?? true,
                      likesCount: data['likesCount'] ?? 0,
                      commentsCount: data['commentsCount'] ?? 0,
                      isLiked: false,
                      createdAt: 'Just now',
                    );
                  }).toList();

                  // Filter by tag if selected
                  if (_selectedTag != 'All') {
                    postsList = postsList.where((p) => p.tag == _selectedTag).toList();
                  }
                } else {
                  // Fallback Mock Posts if Firestore collection is empty
                  postsList = ApiService().getMockPosts();
                  if (_selectedTag != 'All') {
                    postsList = postsList.where((p) => p.tag == _selectedTag).toList();
                  }
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: postsList.length,
                  itemBuilder: (context, index) {
                    final post = postsList[index];
                    return _buildPostCard(post, isBn);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _showAddPostDialog(context, isBn),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildPostCard(PostModel post, bool isBn) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary.withOpacity(0.15),
                child: Text(
                  post.authorAlias.isNotEmpty ? post.authorAlias[0].toUpperCase() : 'A',
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.authorAlias, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(post.createdAt, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  post.tag,
                  style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(post.content, style: const TextStyle(fontSize: 14, height: 1.4)),
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border_rounded, size: 20, color: AppColors.primary),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isBn ? 'লাইক দেওয়া হয়েছে!' : 'Liked post!')),
                  );
                },
              ),
              Text('${post.likesCount}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(width: 20),
              const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: Colors.grey),
              const SizedBox(width: 6),
              Text('${post.commentsCount}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.flag_outlined, size: 18, color: Colors.grey),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isBn ? 'পোস্ট রিপোর্ট করা হয়েছে' : 'Post reported')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddPostDialog(BuildContext context, bool isBn) {
    final controller = TextEditingController();
    String selectedPostTag = 'Support';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 24,
                left: 24,
                right: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(isBn ? 'নতুন পোস্ট লিখুন (বেনামী)' : 'New Post (Anonymous)', style: AppTypography.heading2(context)),
                  const SizedBox(height: 12),
                  DropdownButton<String>(
                    value: selectedPostTag,
                    isExpanded: true,
                    items: ['Success Story', 'Question', 'Support'].map((tag) {
                      return DropdownMenuItem(value: tag, child: Text(tag));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setModalState(() => selectedPostTag = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: isBn ? 'আপনার অনুভূতি বা অভিজ্ঞতা শেয়ার করুন...' : 'Share your feelings or experiences...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () async {
                        final text = controller.text.trim();
                        if (text.isEmpty) return;

                        final user = _auth.currentUser;
                        final author = user?.email?.split('@')[0] ?? 'Anonymous Member';

                        // Live write to Cloud Firestore
                        await _firestore.collection('community_posts').add({
                          'authorAlias': author,
                          'content': text,
                          'tag': selectedPostTag,
                          'isAnonymous': true,
                          'likesCount': 0,
                          'commentsCount': 0,
                          'authorUid': user?.uid ?? 'anonymous',
                          'timestamp': FieldValue.serverTimestamp(),
                        });

                        if (mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(isBn ? 'পোস্ট সরাসরি প্রকাশিত হয়েছে!' : 'Post published to Firebase!')),
                          );
                        }
                      },
                      child: Text(isBn ? 'পাবলিশ করুন' : 'Publish Post', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
