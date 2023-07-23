class CustomUser {
  String uid;
  String name;
  String username;
  String email;
  String password;
  String imagePath;

  CustomUser({required this.uid, required this.name, required this.username, required this.email, required this.password, required this.imagePath});

  Map<String, String> toMap() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'image': imagePath,
    };
  }
}

class UserUID {
  String uid;
  UserUID({required this.uid});
}