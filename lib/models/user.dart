class User {
  int? id, roleId;
  String? username, phone, photo, role, slug, credentials;

  User({
    this.id,
    this.roleId,
    this.username,
    this.phone,
    this.photo,
    this.role,
    this.slug,
    this.credentials,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      roleId: json['role_id'],
      username: json['username'],
      phone: json['phone'],
      photo: json['photo'],
      role: json['role'],
      slug: json['slug'],
      credentials: json['credentials'],
    );
  }
}
