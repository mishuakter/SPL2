import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/models/category_model.dart';
import '../../data/models/course_model.dart';
import '../../data/models/specialist_model.dart';
import '../../data/models/community_model.dart';

class ApiService {
  List<CategoryModel> getMockCategories() {
    return [
      CategoryModel(
        id: 1,
        slug: 'first-time-mother',
        titleEn: 'First Time Mother',
        titleBn: 'প্রথমবার মা হওয়া',
        descriptionEn: 'Support for new mothers navigating early motherhood',
        descriptionBn: 'নতুন মায়েদের মাতৃকালীন মানসিক ও শারীরিক সুস্থতার জন্য গাইডলাইন',
        icon: 'mother',
        colorHex: '#EC4899',
      ),
      CategoryModel(
        id: 2,
        slug: 'single-parent',
        titleEn: 'Single Parent',
        titleBn: 'একক অভিভাবক',
        descriptionEn: 'Resources and guidance for single parents',
        descriptionBn: 'একক অভিভাবকদের সন্তানের লালন-পালন ও মানসিক সুস্থতা',
        icon: 'heart',
        colorHex: '#8B5CF6',
      ),
      CategoryModel(
        id: 3,
        slug: 'special-child',
        titleEn: 'Parent of Special Child',
        titleBn: 'বিশেষ চাহিদাসম্পন্ন শিশুর অভিভাবক',
        descriptionEn: 'Specialized support for parents of children with special needs',
        descriptionBn: 'বিশেষ চাহিদাসম্পন্ন শিশুদের অভিভাবকদের জন্য বিশেষ পরামর্শ',
        icon: 'people',
        colorHex: '#3B82F6',
      ),
      CategoryModel(
        id: 4,
        slug: 'corporate-employee',
        titleEn: 'Corporate Employee',
        titleBn: 'কর্পোরেট চাকুরিজীবী',
        descriptionEn: 'Mental wellness support for working professionals',
        descriptionBn: 'কর্মজীবীদের কাজের মানসিক চাপ ও কর্মক্ষেত্রের ভারসাম্যের জন্য সহায়তা',
        icon: 'briefcase',
        colorHex: '#F97316',
      ),
      CategoryModel(
        id: 5,
        slug: 'university-student',
        titleEn: 'University Student',
        titleBn: 'বিশ্ববিদ্যালয় শিক্ষার্থী',
        descriptionEn: 'Stress, anxiety & academic pressure support for students',
        descriptionBn: 'শিক্ষার্থীদের পড়াশোনার চাপ, উদ্বেগ এবং ক্যরিয়ার বিষয়ক মানসিক গাইডলাইন',
        icon: 'school',
        colorHex: '#14B8A6',
      ),
    ];
  }

  List<CourseModel> getMockCourses() {
    return [
      CourseModel(
        id: 1,
        titleEn: 'New Mother Wellness Program',
        titleBn: 'নতুন মায়ের সুস্থতা প্রোগ্রাম',
        descriptionEn: 'Comprehensive support for first-time mothers covering postpartum care, bonding, and self-care.',
        descriptionBn: 'প্রথমবার মা হওয়া নারীদের জন্য প্রসূতি পরবর্তী যত্ন ও মানসিক সুস্থতা কোর্স।',
        durationWeeks: 8,
        totalTasks: 12,
        typeLabel: 'Both',
        price: 0.0,
        isFree: true,
        rating: 4.9,
      ),
      CourseModel(
        id: 2,
        titleEn: 'Postpartum Mental Health',
        titleBn: 'প্রসূতি পরবর্তী মানসিক স্বাস্থ্য',
        descriptionEn: 'Understanding and managing postpartum depression and anxiety for new mothers.',
        descriptionBn: 'নতুন মায়েদের পোস্টপার্টাম বিষণ্নতা ও উদ্বেগ দূর করার বৈজ্ঞানিক টিপস।',
        durationWeeks: 4,
        totalTasks: 6,
        typeLabel: 'Video',
        price: 0.0,
        isFree: true,
        rating: 4.8,
      ),
    ];
  }

  List<SpecialistModel> getMockSpecialists() {
    return [
      SpecialistModel(
        id: 1,
        name: 'Dr. Ayesha Rahman',
        titleEn: 'Clinical Psychologist',
        titleBn: 'ক্লিনিক্যাল সাইকোলজিস্ট',
        bioEn: 'Specialist in postpartum care, anxiety management, and relationship therapy.',
        bioBn: 'পোস্টপার্টাম কেয়ার, অ্যাংজাইটি ম্যানেজমেন্ট এবং কাপল থেরাপিতে বিশেষজ্ঞ।',
        experienceYears: 12,
        rating: 4.9,
        feeBdt: 1500,
        locationType: 'local',
        isAvailable: true,
        isOnline: true,
      ),
      SpecialistModel(
        id: 2,
        name: 'Dr. Kamal Ahmed',
        titleEn: 'Child Psychologist',
        titleBn: 'শিশু মনস্তত্ত্ববিদ',
        bioEn: 'Expert guidance for child development and parental counseling.',
        bioBn: 'শিশুর মানসিক বিকাশ ও প্যারেন্টিং বিষয়ক অভিজ্ঞ পরামর্শক।',
        experienceYears: 10,
        rating: 4.8,
        feeBdt: 1800,
        locationType: 'local',
        isAvailable: true,
        isOnline: true,
      ),
    ];
  }

  List<PostModel> getMockPosts() {
    return [
      PostModel(
        id: 1,
        authorAlias: 'Anonymous',
        content: 'I just completed my first week of anxiety management course. Feeling hopeful! 💜',
        tag: 'Success Story',
        isAnonymous: true,
        likesCount: 24,
        commentsCount: 8,
        isLiked: false,
        createdAt: '2 hours ago',
      ),
      PostModel(
        id: 2,
        authorAlias: 'Fatima K.',
        content: 'Any tips for first-time mothers dealing with postpartum anxiety?',
        tag: 'Question',
        isAnonymous: false,
        likesCount: 15,
        commentsCount: 12,
        isLiked: false,
        createdAt: '5 hours ago',
      ),
    ];
  }
}
