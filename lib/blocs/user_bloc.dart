import 'dart:async';
import 'package:cojob/api_service.dart';
import 'package:cojob/models/user.dart';

class UserBloc {
  final _userController = StreamController<List<User>>();

  Stream<List<User>> get users => _userController.stream;

  void fetchUsers() async {
    try {
      final users = await ApiService.fetchUsers();
      _userController.sink.add(users);
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  void createUser(User user) async {
    try {
      await ApiService.createUser(user);
      fetchUsers();
    } catch (e) {
      print('Error creating user: $e');
    }
  }

  void dispose() {
    _userController.close();
  }
}
