import 'dart:convert';
import 'package:cojob/secure_storage.dart';
import 'package:http/http.dart' as http;

class APIService {
  final SecureStorage _secureStorage = SecureStorage();

  final _baseUrl = 'https://cojob-server.onrender.com/api/auth';
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
      return true;
    } else {
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
      final String userId = body['userId'].toString();
      await _secureStorage.storeUserId(userId);
      await _secureStorage.storeToken(token!);
      return body['token'];
    } else {
      return null;
    }
  }

  Future<bool> logoutUser() async {
    try {
      await _secureStorage.deleteToken();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> sendMessage(int receiverId, String message) async {
    final url = Uri.parse('$_baseUrl/messages/send');
    final token = await _secureStorage.getToken();
    final String? senderId = await _secureStorage.getUserId();
    if (senderId == null) {
      return false;
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'senderId': senderId,
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

  Future<Map<String, dynamic>?> fetchLastMessage(
      int userId1, int userId2) async {
    final url =
        Uri.parse('$_baseUrl/messages/last?userId1=$userId1&userId2=$userId2');
    final response = await http.get(
      url,
      headers: {},
    );
    if (response.body.isEmpty) {
      return {'message': 'No messages yet'};
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      return null;
    }
  }

  Future<bool> addTask(
      String name, String description, bool isDone, String timestamp) async {
    final url = Uri.parse('$_baseUrl/tasks/add');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
        'isDone': isDone,
        'timestamp': timestamp,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateTaskStatus(String taskId, bool isDone) async {
    final url = Uri.parse('$_baseUrl/tasks/update/$taskId');
    final response = await http.patch(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'isDone': isDone ? 1 : 0,
        }));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
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

  Future<List<dynamic>?> fetchTasks() async {
    final url = Uri.parse('$_baseUrl/tasks');
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
