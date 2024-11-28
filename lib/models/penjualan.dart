class Penjualan {
  int? id, pelangganId;
  double? totalPrice, totalPayment, kembalian;
  String? pelanggan, tanggalPenjualan;

  Penjualan({
    this.id,
    this.pelangganId,
    this.pelanggan,
    this.tanggalPenjualan,
    this.totalPrice,
    this.totalPayment,
    this.kembalian,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['pelanggan_id'] = pelangganId;
    data['pelanggan'] = pelanggan;
    data['tanggal_penjualan'] = tanggalPenjualan;
    data['total_harga'] = totalPrice;
    data['total_bayar'] = totalPayment;
    data['kembalian'] = kembalian;
    return data;
  }

  factory Penjualan.fromJson(Map<String, dynamic> json) {
    return Penjualan(
      id: json['id'],
      pelangganId: json['pelanggan_id'],
      pelanggan: json['pelanggan'],
      tanggalPenjualan: json['tanggal_penjualan'],
      totalPrice: json['total_harga'],
      totalPayment: json['total_bayar'],
      kembalian: json['kembalian'],
    );
  }
}
