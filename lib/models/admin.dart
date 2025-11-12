class Admin {
  final int id;
  final String name;
  final String email;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Admin({
    required this.id,
    required this.name,
    required this.email,
    this.createdAt,
    this.updatedAt,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Pour la création d'un admin
  Map<String, dynamic> toCreateJson() {
    return {
      'name': name,
      'email': email,
      'password': 'password', // À remplacer par un mot de passe sécurisé
    };
  }

  // Pour la mise à jour d'un admin
  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name,
      'email': email,
    };
  }

  @override
  String toString() {
    return 'Admin{id: $id, name: $name, email: $email}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Admin &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}