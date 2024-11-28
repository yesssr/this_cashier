import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:printing/printing.dart';
import 'package:this_cashier/widget/detail_trx.dart';

import '../constant.dart';
import '../models/detail_penjualan.dart';
import '../models/penjualan.dart';
import '../providers/cart.dart';
import '../utils/utils.dart';
import '../widget/button.dart';
import '../widget/detail_order_result.dart';

class PenjualanService {
  static const _apiPenjualan = "$serverUrl/penjualan";

  static Future<List<Penjualan>> getPenjualans({
    required int limit,
    required int offset,
    String? search,
    DateTime? date,
  }) async {
    final token = await Utils.getUserToken();
    String url = "$_apiPenjualan?limit=$limit&offset=$offset";
    if (search != null && search.isNotEmpty) {
      url += "&search=$search";
    } else {
      url += "&date=${date?.year}-${date?.month}-${date?.day}";
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    final data = jsonDecode(response.body)['data'];
    return List<Penjualan>.from(data.map((e) => Penjualan.fromJson(e)));
  }

  static Future<void> getDetailPenjualan({
    required BuildContext context,
    required Penjualan penjualan,
  }) async {
    Utils.showLoadingIndicator(context);
    final token = await Utils.getUserToken();
    String url = "$_apiPenjualan/${penjualan.id}";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (context.mounted) {
      Navigator.of(context).pop();
      Utils.responseHandle(
        context: context,
        response: response,
        onSuccess: () {
          final data = jsonDecode(response.body)['data'];
          final listDetailPenjualan = List<DetailPenjualan>.from(
            data.map((e) => DetailPenjualan.fromJson(e)),
          );
          showDialog(
            context: context,
            builder: (context) => DetailTrx(
              penjualan: penjualan,
              listDetailPenjualan: listDetailPenjualan,
            ),
          );
        },
      );
    }
  }

  static Future<void> postPenjualan({
    required BuildContext context,
    required double totalPrice,
    required double totalPayment,
    required int? pelangganId,
    required Cart cart,
  }) async {
    if (pelangganId == null) {
      Utils.showTheDialog(
        context: context,
        title: "Error",
        content: "PELANGGAN DIPERLUKAN!.",
      );
      return;
    }
    Utils.showLoadingIndicator(context);
    final token = await Utils.getUserToken();
    final uri = Uri.parse(_apiPenjualan);

    Map<String, dynamic> data = {
      "pelanggan_id": pelangganId,
      "total_harga": totalPrice,
      "total_bayar": totalPayment,
      "kembalian": totalPayment - totalPrice,
      "items": cart.items.values.toList(),
    };

    http.Response response = await http.post(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    if (context.mounted) {
      Navigator.of(context).pop();
      Utils.responseHandle(
        context: context,
        response: response,
        onSuccess: () async {
          final items = cart.items.values.toList();
          cart.emptyCart();
          final result = jsonDecode(response.body)['data'];
          String tanggalPenjualan = result['tanggal_penjualan'];
          String penjualanId = "${result['id']}";
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              scrollable: true,
              title: Text("Order Berhasil", style: bodyLargeBold),
              content: Center(
                child: Column(
                  children: [
                    DetailOrderResult(
                      title: "TOTAL TAGIHAN",
                      content: Utils.priceFormatter(totalPrice).toString(),
                    ),
                    DetailOrderResult(
                      title: "NOMINAL BAYAR",
                      content: Utils.priceFormatter(totalPayment).toString(),
                    ),
                    DetailOrderResult(
                      title: "KEMBALIAN",
                      content: Utils.priceFormatter(totalPayment - totalPrice)
                          .toString(),
                    ),
                    DetailOrderResult(
                      title: "WAKTU PEMBAYARAN",
                      content: tanggalPenjualan,
                    ),
                  ],
                ),
              ),
              actions: [
                otlBtn(
                  nameField: "Tutup",
                  negActions: true,
                  fixedMobileSize: true,
                  context: context,
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(true);
                  },
                ),
                fillBtn(
                  nameField: "Print",
                  fixedMobileSize: true,
                  context: context,
                  onPressed: () async {
                    final pdfDoc = await Utils.generateReceiptPdf(
                      trxCode: penjualanId,
                      totalBill: Utils.priceFormatter(totalPrice).toString(),
                      kembalian:
                          Utils.priceFormatter(totalPayment - totalPrice),
                      totalPayment:
                          Utils.priceFormatter(totalPayment).toString(),
                      paymentTime: tanggalPenjualan,
                      items: items
                          .map(
                            (e) => DetailPenjualan(
                              productName: e.title,
                              price: e.price,
                              qty: e.qty,
                              subtotal: e.price * e.qty,
                            ),
                          )
                          .toList(),
                    );
                    // Utils.savePdfFile(await pdfDoc.save(), "${penjualan.id}");
                    await Printing.layoutPdf(
                      onLayout: (format) => pdfDoc.save(),
                    );
                  },
                ),
              ],
              shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
          );
        },
      );
    }
  }
}
