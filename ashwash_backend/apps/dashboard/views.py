from rest_framework import permissions, status
from rest_framework.views import APIView
from rest_framework.response import Response
from apps.courses.models import UserCourseProgress
from apps.mood_tracker.models import MoodLog
from apps.appointments.models import Appointment

class DashboardSummaryView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        user = request.user
        latest_mood = MoodLog.objects.filter(user=user).first()
        recent_courses = UserCourseProgress.objects.filter(user=user)[:3]

        enrolled_courses_data = []
        for c in recent_courses:
            enrolled_courses_data.append({
                'course_id': c.course.id,
                'title_en': c.course.title_en,
                'title_bn': c.course.title_bn,
                'completed_lessons': c.completed_lessons_count,
                'total_lessons': c.total_lessons_count,
                'progress_percentage': c.progress_percentage
            })

        upcoming_appointments_count = Appointment.objects.filter(user=user, status='confirmed').count()

        quote = {
            'quote_en': "Every step forward is progress. Keep going!",
            'quote_bn': "প্রতিটি পদক্ষেপই অগ্রগতি। এগিয়ে যান!"
        }

        return Response({
            'user': {
                'username': user.username,
                'email': user.email,
                'points': user.total_points,
                'sessions_attended': user.sessions_attended,
                'tasks_completed': user.tasks_completed,
            },
            'latest_mood': latest_mood.mood if latest_mood else 'happy',
            'course_progress_percentage': 43, # Overall aggregate
            'enrolled_courses': enrolled_courses_data,
            'upcoming_appointments_count': upcoming_appointments_count,
            'daily_quote': quote
        })
