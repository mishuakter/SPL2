from rest_framework import generics, permissions
from .models import Specialist, Appointment
from .serializers import SpecialistSerializer, AppointmentSerializer

class SpecialistListView(generics.ListAPIView):
    serializer_class = SpecialistSerializer
    permission_classes = [permissions.AllowAny]

    def get_queryset(self):
        queryset = Specialist.objects.all()
        loc_type = self.request.query_params.get('type') # local, international
        category_id = self.request.query_params.get('category_id')

        if loc_type and loc_type != 'all':
            queryset = queryset.filter(location_type=loc_type)
        if category_id:
            queryset = queryset.filter(category_id=category_id)

        return queryset

class SpecialistDetailView(generics.RetrieveAPIView):
    queryset = Specialist.objects.all()
    serializer_class = SpecialistSerializer
    permission_classes = [permissions.AllowAny]

class AppointmentListCreateView(generics.ListCreateAPIView):
    serializer_class = AppointmentSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Appointment.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
