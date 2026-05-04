class UserModel {
  final String name;
  final String phone;
  final String role;

  UserModel({required this.name, required this.phone, required this.role});

  // ডাটাবেজ থেকে ডাটা মডেলে রূপান্তর
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? 'User',
    );
  }
}
