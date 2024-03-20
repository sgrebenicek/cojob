import 'dart:convert';
import 'package:cojob/secure_storage.dart';
import 'package:http/http.dart' as http;

class APIService {
  final SecureStorage _secureStorage = SecureStorage();
  Future<bool> registerUser(
      String firstName, String lastName, String email, String password) async {
    final url = Uri.parse('http://localhost:3000/api/auth/register');
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
    final url = Uri.parse('http://localhost:3000/api/auth/login');
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
      print(token);
      await _secureStorage.storeToken(token!);
      return body['token'];
    } else {
      print('bad');
      return null;
    }
  }
}
