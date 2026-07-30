from rest_framework import serializers
from .models import Post, Comment, Like, Report

class CommentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Comment
        fields = ['id', 'post', 'author_alias', 'content', 'created_at']
        read_only_fields = ['id', 'author_alias', 'created_at']

class PostSerializer(serializers.ModelSerializer):
    comments = CommentSerializer(many=True, read_only=True)
    is_liked = serializers.SerializerMethodField()

    class Meta:
        model = Post
        fields = [
            'id', 'author_alias', 'content', 'tag', 'is_anonymous',
            'likes_count', 'comments_count', 'is_liked', 'created_at', 'comments'
        ]
        read_only_fields = ['id', 'likes_count', 'comments_count', 'created_at']

    def get_is_liked(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            return Like.objects.filter(post=obj, user=request.user).exists()
        return False
