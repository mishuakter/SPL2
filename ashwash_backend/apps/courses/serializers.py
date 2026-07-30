from rest_framework import serializers
from .models import Course, Module, Lesson, Assignment, UserCourseProgress, UserLessonProgress

class AssignmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Assignment
        fields = ['id', 'instruction_en', 'instruction_bn']

class LessonSerializer(serializers.ModelSerializer):
    assignments = AssignmentSerializer(many=True, read_only=True)

    class Meta:
        model = Lesson
        fields = ['id', 'title_en', 'title_bn', 'content_en', 'content_bn', 'video_url', 'duration_minutes', 'order', 'assignments']

class ModuleSerializer(serializers.ModelSerializer):
    lessons = LessonSerializer(many=True, read_only=True)

    class Meta:
        model = Module
        fields = ['id', 'title_en', 'title_bn', 'order', 'lessons']

class CourseSerializer(serializers.ModelSerializer):
    modules = ModuleSerializer(many=True, read_only=True)
    category_name = serializers.CharField(source='category.title_en', read_only=True, allow_null=True)

    class Meta:
        model = Course
        fields = [
            'id', 'category', 'category_name', 'title_en', 'title_bn',
            'description_en', 'description_bn', 'duration_weeks', 'total_tasks',
            'type_label', 'price', 'is_free', 'rating', 'modules'
        ]

class UserCourseProgressSerializer(serializers.ModelSerializer):
    course_title_en = serializers.CharField(source='course.title_en', read_only=True)
    course_title_bn = serializers.CharField(source='course.title_bn', read_only=True)

    class Meta:
        model = UserCourseProgress
        fields = [
            'id', 'course', 'course_title_en', 'course_title_bn',
            'completed_lessons_count', 'total_lessons_count', 'progress_percentage',
            'is_completed', 'updated_at'
        ]
