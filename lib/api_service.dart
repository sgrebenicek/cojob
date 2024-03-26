import 'dart:convert';
import 'package:cojob/secure_storage.dart';
import 'package:http/http.dart' as http;

class APIService {
  final SecureStorage _secureStorage = SecureStorage();

  final _baseUrl = 'http://localhost:3000/api/auth';
  Future<bool> registerUser(
      String firstName, String lastName, String email, String password) async {
    final url = Uri.parse('$_baseUrl/register');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      print('good');
      return true;
    } else {
      print('bad');
      return false;
    }
  }

  Future<String?> loginUser(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final String? token = body['token'];
      print(body);
      final String userId = body['userId'].toString();
      await _secureStorage.storeUserId(userId);
      await _secureStorage.storeToken(token!);
      return body['token'];
    } else {
      print('bad');
      return null;
    }
  }

  Future<bool> logoutUser() async {
    final String? token = await _secureStorage.getToken();
    if (token == null) {
      print('No token found');
      return false;
    }

    final url = Uri.parse('$_baseUrl/api/auth/logout');
    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': token,
      }),
    );

    if (response.statusCode == 200) {
      await _secureStorage.deleteToken();
      print('Logged out successfully');
      return true;
    } else {
      print('Failed to log out');
      return false;
    }
  }

  Future<bool> sendMessage(int receiverId, String message) async {
    final url = Uri.parse('$_baseUrl/messages/send');
    final token = await _secureStorage.getToken();
    final String? senderId =
        await _secureStorage.getUserId(); // Retrieve the actual userId
    if (senderId == null) {
      print('No userId found');
      return false;
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'senderId': senderId, // Use the actual userId
        'receiverId': receiverId,
        'message': message,
      }),
    );
    return response.statusCode == 201;
  }

  Future<List<dynamic>?> fetchMessages(int userId1, int userId2) async {
    final url =
        Uri.parse('$_baseUrl/messages?userId1=$userId1&userId2=$userId2');
    final token = await _secureStorage.getToken();
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Future<List<dynamic>?> fetchAllUsers() async {
    final url = Uri.parse('$_baseUrl/users');
    final token = await _secureStorage.getToken();
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
}
