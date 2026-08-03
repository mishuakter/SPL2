from django.urls import path
from .views import DashboardSummaryView
from .specialist_views import SpecialistDashboardSummaryView

urlpatterns = [
    path('summary/', DashboardSummaryView.as_view(), name='dashboard_summary'),
    path('overview/', DashboardSummaryView.as_view(), name='dashboard_overview'),
    path('specialist-summary/', SpecialistDashboardSummaryView.as_view(), name='specialist_dashboard_summary'),
]
