class User {
  final String firstName;
  final String lastName;
  final String email;
  final String password;


  User({required this.firstName, required this.lastName, required this.email, required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['username'],
      lastName: json['username'],
      email: json['email'],
      password: json['password'],
    );
  }
}
