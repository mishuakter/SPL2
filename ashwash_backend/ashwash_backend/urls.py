from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/auth/', include('apps.authentication.urls')),
    path('api/mood/', include('apps.mood_tracker.urls')),
    path('api/assessment/', include('apps.assessment.urls')),
    path('api/knowledge/', include('apps.knowledge_hub.urls')),
    path('api/courses/', include('apps.courses.urls')),
    path('api/appointments/', include('apps.appointments.urls')),
    path('api/community/', include('apps.community.urls')),
    path('api/payments/', include('apps.payments.urls')),
    path('api/dashboard/', include('apps.dashboard.urls')),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
