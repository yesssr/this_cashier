class CartItem {
  int id;
  String title;
  String photo;
  double price;
  int qty;
  int maxStock;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.qty,
    required this.maxStock,
    required this.photo,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['photo'] = photo;
    data['price'] = price;
    data['qty'] = qty;
    data['maxStock'] = maxStock;
    return data;
  }
}
