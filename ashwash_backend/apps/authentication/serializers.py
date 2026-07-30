from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models import Category, UserProfile

User = get_user_model()

class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ['id', 'slug', 'title_en', 'title_bn', 'description_en', 'description_bn', 'icon', 'color_hex']

class UserProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserProfile
        fields = ['language', 'dark_mode', 'push_notifications']

class UserSerializer(serializers.ModelSerializer):
    profile = UserProfileSerializer(read_only=True)
    selected_category = CategorySerializer(read_only=True)
    selected_category_id = serializers.PrimaryKeyRelatedField(
        queryset=Category.objects.all(), source='selected_category', write_only=True, required=False, allow_null=True
    )

    class Meta:
        model = User
        fields = [
            'id', 'username', 'email', 'first_name', 'last_name', 'phone',
            'selected_category', 'selected_category_id', 'total_points',
            'sessions_attended', 'tasks_completed', 'avatar', 'bio', 'profile'
        ]

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ['username', 'email', 'password', 'first_name', 'last_name', 'phone']

    def create(self, validated_data):
        user = User.objects.create_user(
            username=validated_data['username'],
            email=validated_data.get('email', ''),
            password=validated_data['password'],
            first_name=validated_data.get('first_name', ''),
            last_name=validated_data.get('last_name', ''),
            phone=validated_data.get('phone', '')
        )
        UserProfile.objects.create(user=user)
        return user
