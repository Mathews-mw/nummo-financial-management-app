class User {
  final int id;
  final String name;
  final String email;
  final String password;
  final String? avatarUrl;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.avatarUrl,
  });

  set id(int id) {
    this.id = id;
  }

  set name(String name) {
    this.name = name;
  }

  set email(String email) {
    this.email = email;
  }

  set password(String password) {
    this.password = password;
  }

  set avatarUrl(String? avatarUrl) {
    this.avatarUrl = avatarUrl;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    final user = User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      avatarUrl: json['avatarUrl'],
    );

    return user;
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, password: $password,  avatarUrl: $avatarUrl)';
  }
}
