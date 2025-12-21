class UserModel {
  final int id;
  final String name;
  final String email;
  final String plan;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.plan,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      plan: json['plan'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'plan': plan,
  };
}
