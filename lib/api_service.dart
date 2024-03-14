import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cojob/models/user.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000';

  static Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse("$baseUrl/users"));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<void> createUser(User user) async {
    final response = await http.post(
      Uri.parse("$baseUrl/users"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'firstName': user.firstName,
          'lastName': user.lastName,
          'email': user.email,
          'password': user.password,
        },
      ),
    );
    if (response.statusCode != 201) {
      throw Exception(response.statusCode);
    }
  }
}
