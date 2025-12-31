import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://67caa2aa102d684575c61fec.mockapi.io/flutterproject/users';

  // Fetch all users
  static Future<List<Map<String, dynamic>>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        print("API Error: ${response.statusCode} - ${response.body}");
        throw Exception('Failed to fetch users');
      }
    } catch (e) {
      print("Error fetching users: $e");
      throw Exception('Failed to fetch users');
    }
  }

  // Fetch only favorite users
  static Future<List<Map<String, dynamic>>> fetchFavoriteUsers() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> users = jsonDecode(response.body);
        return users
            .where((user) => user is Map<String, dynamic> && user['isFavorite'] == true) // FIXED
            .map((user) => Map<String, dynamic>.from(user))
            .toList();
      } else {
        print("API Error: ${response.statusCode} - ${response.body}");
        throw Exception('Failed to fetch favorite users');
      }
    } catch (e) {
      print("Error fetching favorite users: $e");
      return [];
    }
  }

  // Add a new user
  static Future<void> addUser(Map<String, dynamic> user) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user),
      );

      if (response.statusCode != 201) {
        print("Failed to add user: ${response.body}");
        throw Exception('Failed to add user');
      }
    } catch (e) {
      print("Error adding user: $e");
      throw Exception('Failed to add user');
    }
  }

  // Update an existing user
  static Future<Map<String, dynamic>?> updateUser(String userId, Map<String, dynamic> updatedData) async {
    if (userId.isEmpty) {
      print("Error: User ID is empty.");
      return null;
    }

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$userId'), // FIXED: Use correct URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Failed to update user: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error updating user: $e");
      return null;
    }
  }

  // Delete a user
  static Future<bool> deleteUser(String userId) async {
    if (userId.isEmpty) {
      print("Error: User ID is empty.");
      return false;
    }

    try {
      final response = await http.delete(Uri.parse('$baseUrl/$userId')); // FIXED

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print("Failed to delete user: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error deleting user: $e");
      return false;
    }
  }
}
