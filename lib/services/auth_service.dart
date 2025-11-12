import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  String? _token;
  bool _isAdmin = false;

  String? get token => _token;
  bool get isAdmin => _isAdmin;
  bool get isLoggedIn => _token != null;

  Future<void> login(String email, String password, {bool admin = false}) async {
    // Simulation de connexion - À remplacer par votre logique réelle
    final prefs = await SharedPreferences.getInstance();
    
    if (admin) {
      // Connexion admin
      _token = 'admin_token_${DateTime.now().millisecondsSinceEpoch}';
      _isAdmin = true;
      await prefs.setString('admin_token', _token!);
    } else {
      // Connexion utilisateur normal
      _token = 'user_token_${DateTime.now().millisecondsSinceEpoch}';
      _isAdmin = false;
      await prefs.setString('user_token', _token!);
    }
    
    notifyListeners();
  }

  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final adminToken = prefs.getString('admin_token');
    final userToken = prefs.getString('user_token');
    
    if (adminToken != null) {
      _token = adminToken;
      _isAdmin = true;
    } else if (userToken != null) {
      _token = userToken;
      _isAdmin = false;
    }
    
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('admin_token');
    await prefs.remove('user_token');
    
    _token = null;
    _isAdmin = false;
    notifyListeners();
  }
}