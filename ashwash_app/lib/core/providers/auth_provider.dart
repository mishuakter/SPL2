import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_endpoints.dart';
import '../network/api_service.dart';
import '../../data/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _loadUserFromStorage();
  }

  Future<void> _loadUserFromStorage() async {
    _isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(ApiService.tokenKey);
      if (token != null) {
        final profileData = await ApiService.get(ApiEndpoints.profile, requireAuth: true);
        _currentUser = UserModel.fromJson(profileData);
      }
    } catch (e) {
      _errorMessage = e.toString();
      logout();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await ApiService.post(ApiEndpoints.login, {
        'email': email,
        'password': password,
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(ApiService.tokenKey, data['access']);
      await prefs.setString(ApiService.refreshKey, data['refresh']);

      if (data['user'] != null) {
        _currentUser = UserModel.fromJson(data['user']);
      } else {
        await fetchProfile();
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await ApiService.post(ApiEndpoints.register, {
        'email': email,
        'username': email,
        'password': password,
        'password_confirm': password,
        'first_name': firstName,
        'last_name': lastName,
        'role': role,
      });

      final prefs = await SharedPreferences.getInstance();
      if (data['access'] != null) {
        await prefs.setString(ApiService.tokenKey, data['access']);
        await prefs.setString(ApiService.refreshKey, data['refresh']);
      }

      if (data['user'] != null) {
        _currentUser = UserModel.fromJson(data['user']);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchProfile() async {
    try {
      final data = await ApiService.get(ApiEndpoints.profile, requireAuth: true);
      _currentUser = UserModel.fromJson(data);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    }
  }

  Future<bool> setCategoryPreference(String categoryId) async {
    try {
      await ApiService.post(
        ApiEndpoints.categoryPreference,
        {'category': categoryId},
        requireAuth: true,
      );
      await fetchProfile();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ApiService.tokenKey);
    await prefs.remove(ApiService.refreshKey);
    _currentUser = null;
    notifyListeners();
  }
}
