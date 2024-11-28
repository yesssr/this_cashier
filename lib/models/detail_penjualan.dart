class DetailPenjualan {
  int? id, penjualanId, productId, qty;
  String? productName;
  double? subtotal, price;

  DetailPenjualan({
    this.id,
    this.penjualanId,
    this.productId,
    this.productName,
    this.qty,
    this.price,
    this.subtotal,
  });

  factory DetailPenjualan.fromJson(Map<String, dynamic> json) {
    return DetailPenjualan(
      id: json['id'],
      penjualanId: json['penjualan_id'],
      productId: json['product_id'],
      productName: json['product_name'],
      qty: json['jumlah_product'],
      price: json['price'],
      subtotal: json['subtotal'],
    );
  }
}
