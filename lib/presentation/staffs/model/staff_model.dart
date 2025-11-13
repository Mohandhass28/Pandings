class StaffModel {
  final String id;
  final String name;
  final String role; // Example: 'manager', 'staff', 'owner'

  StaffModel({
    required this.id,
    required this.name,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
    };
  }

  factory StaffModel.fromMap(Map<String, dynamic> map) {
    return StaffModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? '',
    );
  }
}
