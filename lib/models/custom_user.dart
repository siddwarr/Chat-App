class CustomUser {
  String uid;
  String name;
  String username;
  String email;
  String password;

  CustomUser({required this.uid, required this.name, required this.username, required this.email, required this.password});

  Map<String, String> toMap() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'email': email,
      'password': password,
    };
  }
}

class UserUID {
  String uid;
  UserUID({required this.uid});
}