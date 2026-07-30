from rest_framework import generics, permissions, status
from rest_framework.views import APIView
from rest_framework.response import Response
from .models import Course, Lesson, UserCourseProgress, UserLessonProgress
from .serializers import CourseSerializer, UserCourseProgressSerializer, LessonSerializer

class CourseListView(generics.ListAPIView):
    serializer_class = CourseSerializer
    permission_classes = [permissions.AllowAny]

    def get_queryset(self):
        queryset = Course.objects.all()
        category_id = self.request.query_params.get('category_id')
        search = self.request.query_params.get('search')

        if category_id:
            queryset = queryset.filter(category_id=category_id)
        if search:
            queryset = queryset.filter(title_en__icontains=search)

        return queryset

class CourseDetailView(generics.RetrieveAPIView):
    queryset = Course.objects.all()
    serializer_class = CourseSerializer
    permission_classes = [permissions.AllowAny]

class CompleteLessonView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request, lesson_id):
        try:
            lesson = Lesson.objects.get(id=lesson_id)
        except Lesson.DoesNotExist:
            return Response({'error': 'Lesson not found'}, status=status.HTTP_404_NOT_FOUND)

        UserLessonProgress.objects.get_or_create(user=request.user, lesson=lesson, defaults={'is_completed': True})

        course = lesson.module.course
        all_lessons_count = Lesson.objects.filter(module__course=course).count() or 1
        completed_count = UserLessonProgress.objects.filter(
            user=request.user, lesson__module__course=course, is_completed=True
        ).count()

        pct = int((completed_count / all_lessons_count) * 100)
        progress, _ = UserCourseProgress.objects.get_or_create(
            user=request.user, course=course
        )
        progress.completed_lessons_count = completed_count
        progress.total_lessons_count = all_lessons_count
        progress.progress_percentage = pct
        progress.is_completed = (pct >= 100)
        progress.save()

        return Response(UserCourseProgressSerializer(progress).data)

class UserEnrolledCoursesView(generics.ListAPIView):
    serializer_class = UserCourseProgressSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return UserCourseProgress.objects.filter(user=self.request.user)
