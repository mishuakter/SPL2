class ApiEndpoints {
  // Base API URL (Configured for Physical Android Device via USB using ADB Reverse)
  static const String baseUrl = 'http://127.0.0.1:8000/api/v1';

  // Authentication Endpoints
  static const String register = '$baseUrl/auth/register/';
  static const String login = '$baseUrl/auth/login/';
  static const String tokenRefresh = '$baseUrl/auth/token/refresh/';
  static const String profile = '$baseUrl/auth/profile/';
  static const String categoryPreference = '$baseUrl/auth/category-preference/';
  static const String categories = '$baseUrl/auth/categories/';
  static const String selectCategory = '$baseUrl/auth/select-category/';

  // Dashboard Endpoints
  static const String dashboardOverview = '$baseUrl/dashboard/overview/';
  static const String dashboardSummary = '$baseUrl/dashboard/summary/';

  // Mood & Progress Endpoints
  static const String moodLogs = '$baseUrl/mood/logs/';
  static const String mentalHealthReport = '$baseUrl/mood/report/';
  static const String moodAnalytics = '$baseUrl/mood/analytics/';

  // Knowledge Hub & Mind Games Endpoints
  static const String hubResources = '$baseUrl/hub/resources/';
  static const String resources = '$baseUrl/knowledge/resources/';
  static const String mindGames = '$baseUrl/hub/mind-games/';
  static const String gameScore = '$baseUrl/hub/mind-games/score/';

  // Courses & Assignments Endpoints
  static const String courses = '$baseUrl/courses/';
  static const String enrolledCourses = '$baseUrl/courses/enrolled/';

  // Assessment Endpoints
  static const String questionnaires = '$baseUrl/assessment/questionnaires/';
  static const String submitAssessment = '$baseUrl/assessment/submit/';

  // Appointments & Specialists
  static const String specialists = '$baseUrl/appointments/specialists/';
  static const String bookings = '$baseUrl/appointments/bookings/';

  // Community & Payments
  static const String posts = '$baseUrl/community/posts/';
  static const String payments = '$baseUrl/payments/initiate/';
}