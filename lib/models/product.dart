class Product {
  int? id, stok;
  String? name, category, photo, price;

  Product({
    this.id,
    this.price,
    this.stok,
    this.name,
    this.category,
    this.photo,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      price: json['price'],
      stok: json['stok'],
      name: json['name'],
      photo: json['photo'],
      category: json['category'],
    );
  }
}
