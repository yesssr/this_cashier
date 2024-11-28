class Pelanggan {
  int? id;
  String? name, address, phone;

  Pelanggan({
    this.id,
    this.name,
    this.address,
    this.phone,
  });

  factory Pelanggan.fromJson(Map<String, dynamic> json) {
    return Pelanggan(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
    );
  }
}
