import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _usersMapKey = 'users';
  static const String _currentUserEmailKey = 'current_user_email';

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Login user
  static Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    // Load existing users map
    final usersMapString = prefs.getString(_usersMapKey);
    Map<String, dynamic> usersMap = {};
    if (usersMapString != null) {
      try {
        usersMap = jsonDecode(usersMapString) as Map<String, dynamic>;
      } catch (_) {
        usersMap = {};
      }
    }

    // Use existing user or create new
    UserModel user;
    if (usersMap.containsKey(email)) {
      final existing = usersMap[email] as Map<String, dynamic>;
      user = UserModel.fromJson(Map<String, dynamic>.from(existing));
    } else {
      user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: email.split('@').first,
        email: email,
      );
      usersMap[email] = user.toJson();
      await prefs.setString(_usersMapKey, jsonEncode(usersMap));
    }

    // Set current session info
    await prefs.setString(_currentUserEmailKey, email);
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    return await prefs.setBool(_isLoggedInKey, true);
  }

  // Save user data
  static Future<bool> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(user.toJson());
    await prefs.setString(_userKey, jsonString);
    // Also persist into users map keyed by email to survive logout/login
    final usersMapString = prefs.getString(_usersMapKey);
    Map<String, dynamic> usersMap = {};
    if (usersMapString != null) {
      try {
        usersMap = jsonDecode(usersMapString) as Map<String, dynamic>;
      } catch (_) {}
    }
    usersMap[user.email] = user.toJson();
    await prefs.setString(_usersMapKey, jsonEncode(usersMap));
    await prefs.setString(_currentUserEmailKey, user.email);
    return await prefs.setBool(_isLoggedInKey, true);
  }

  // Get current user
  static Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson == null) return null;
    
    try {
      // Parse the JSON string back to a map
      final Map<String, dynamic> userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      // Fallback: handle legacy Dart Map.toString format
      try {
        final legacyMap = _parseLegacyMapString(userJson);
        if (legacyMap != null) {
          return UserModel.fromJson(legacyMap);
        }
      } catch (_) {}
      // Fallback 2: try users map with current email
      try {
        final email = prefs.getString(_currentUserEmailKey);
        final usersMapString = prefs.getString(_usersMapKey);
        if (email != null && usersMapString != null) {
          final usersMap = jsonDecode(usersMapString) as Map<String, dynamic>;
          if (usersMap.containsKey(email)) {
            final data = Map<String, dynamic>.from(usersMap[email]);
            return UserModel.fromJson(data);
          }
        }
      } catch (_) {}
      return null;
    }
  }

  // Update user profile
  static Future<bool> updateProfile(UserModel updatedUser) async {
    return await saveUser(updatedUser);
  }

  // Logout user
  static Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    // Do not delete the users map to retain user data across logins
    await prefs.remove(_userKey);
    return await prefs.setBool(_isLoggedInKey, false);
  }

  // Attempts to parse a legacy map produced by Map.toString()
  // Example: {id: 123, name: John, email: john@a.com, createdAt: 2024-08-01T12:00:00.000Z}
  static Map<String, dynamic>? _parseLegacyMapString(String input) {
    final trimmed = input.trim();
    if (!trimmed.startsWith('{') || !trimmed.endsWith('}')) return null;
    final body = trimmed.substring(1, trimmed.length - 1);
    final result = <String, dynamic>{};
    for (final pair in body.split(', ')) {
      final idx = pair.indexOf(':');
      if (idx <= 0) continue;
      final key = pair.substring(0, idx).trim();
      var value = pair.substring(idx + 1).trim();
      if (value.startsWith("'") && value.endsWith("'")) {
        value = value.substring(1, value.length - 1);
      }
      if (value.startsWith('"') && value.endsWith('"')) {
        value = value.substring(1, value.length - 1);
      }
      // special handling for createdAt
      if (key == 'createdAt') {
        try {
          result[key] = DateTime.parse(value).toIso8601String();
        } catch (_) {
          result[key] = DateTime.now().toIso8601String();
        }
      } else {
        result[key] = value == 'null' ? null : value;
      }
    }
    // minimal validation
    if (!result.containsKey('id') || !result.containsKey('name') || !result.containsKey('email')) {
      return null;
    }
    result['createdAt'] = (result['createdAt'] ?? DateTime.now().toIso8601String());
    return result;
  }
}
