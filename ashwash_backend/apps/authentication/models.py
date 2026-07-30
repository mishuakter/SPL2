from django.contrib.auth.models import AbstractUser
from django.db import models

class Category(models.Model):
    slug = models.SlugField(unique=True)
    title_en = models.CharField(max_length=100)
    title_bn = models.CharField(max_length=100)
    description_en = models.TextField()
    description_bn = models.TextField()
    icon = models.CharField(max_length=50, default='heart')
    color_hex = models.CharField(max_length=10, default='#EC4899')

    def __str__(self):
        return self.title_en

class User(AbstractUser):
    phone = models.CharField(max_length=20, blank=True, null=True)
    selected_category = models.ForeignKey(Category, on_delete=models.SET_NULL, null=True, blank=True, related_name='users')
    total_points = models.IntegerField(default=450)
    sessions_attended = models.IntegerField(default=5)
    tasks_completed = models.IntegerField(default=1)
    avatar = models.ImageField(upload_to='avatars/', null=True, blank=True)
    bio = models.TextField(blank=True, default='')

    def __str__(self):
        return self.email if self.email else self.username

class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile')
    language = models.CharField(max_length=10, choices=[('en', 'English'), ('bn', 'Bangla')], default='en')
    dark_mode = models.BooleanField(default=False)
    push_notifications = models.BooleanField(default=True)

    def __str__(self):
        return f"Profile of {self.user.username}"
