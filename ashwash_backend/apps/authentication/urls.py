from django.urls import path
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from .views import (
    RegisterView, ProfileView, CategoryListView, SelectCategoryView, UpdatePreferencesView
)

urlpatterns = [
    path('register/', RegisterView.as_view(), name='register'),
    path('login/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('profile/', ProfileView.as_view(), name='profile'),
    path('categories/', CategoryListView.as_view(), name='categories'),
    path('select-category/', SelectCategoryView.as_view(), name='select_category'),
    path('preferences/', UpdatePreferencesView.as_view(), name='update_preferences'),
]
