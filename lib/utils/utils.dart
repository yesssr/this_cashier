import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:this_cashier/constant.dart';
import 'package:this_cashier/models/detail_penjualan.dart';
import '../widget/button.dart';

class Utils {
  static Future<String?> getUserToken() async {
    final prefs = await getPreferences();
    final token = prefs.getString("credentials");
    return token;
  }

  static void showTheDialog({
    required BuildContext context,
    required String title,
    required String content,
    bool? isDismissed,
  }) {
    showDialog(
      barrierDismissible: isDismissed ?? true,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: bodyLargeBold),
          content: Text(content, style: labelMedReg),
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        );
      },
    );
  }

  static void responseHandle({
    required BuildContext context,
    required http.Response response,
    required VoidCallback onSuccess,
  }) {
    switch (response.statusCode) {
      case 200:
      case 201:
        onSuccess();
        break;
      default:
        showTheDialog(
          context: context,
          title: "Error",
          content:
              jsonDecode(response.body)['message'].toString().toUpperCase(),
        );
    }
  }

  static void showTheSnackBar({
    required BuildContext context,
    required String content,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 1500),
        content: Text(content, style: labelMedMed),
        showCloseIcon: true,
      ),
    );
  }

  static showLoadingIndicator(BuildContext context) {
    AlertDialog alert = const AlertDialog(
      backgroundColor: Colors.transparent,
      content: Center(
        heightFactor: 1,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          color: secondaryColor,
          backgroundColor: Colors.transparent,
        ),
      ),
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static Future<SharedPreferences> getPreferences() async =>
      await SharedPreferences.getInstance();

  static priceFormatter(dynamic price) {
    final formatter = NumberFormat('#,##0', 'id_ID');
    return formatter.format(price);
  }

  static void showConfirmDialog({
    required BuildContext context,
    VoidCallback? onOke,
    String? title,
    String? content,
    VoidCallback? onNotOke,
    bool? isNegativeAction = false,
    Function(dynamic)? onValue,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(title ?? "Konfirmasi"),
          titleTextStyle: bodyLargeBold.copyWith(color: Colors.black),
          content: Text(content ?? "Yakin?"),
          contentTextStyle: labelMedReg.copyWith(color: Colors.black),
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                fillBtn(
                  nameField: isNegativeAction! ? "Ya" : "Tidak",
                  context: context,
                  negActions: true,
                  onPressed: onNotOke ?? () => Navigator.of(context).pop(),
                ),
                fillBtn(
                  context: context,
                  onPressed: onOke ?? () {},
                  nameField: isNegativeAction ? "Tidak" : "Ya",
                ),
              ],
            )
          ],
        );
      },
    ).then(onValue ?? (value) {});
  }

  static String? isNumber(String value, String nameField) {
    if (value.isEmpty) return "$nameField diperlukan!.";

    if (int.tryParse(value) == null) {
      return "Hanya berupa angka!.";
    }
    return null;
  }

  static String dateFormatter(String date) {
    DateTime dateTime = DateTime.parse(date);
    DateTime localDate = dateTime.toLocal();
    String formattedDate = DateFormat('yyyy-MM-dd').format(localDate);
    return formattedDate;
  }

  static const _receiptPageFormat = PdfPageFormat(
    227,
    double.infinity,
    marginAll: 10,
  );

  static Future<pw.Document> generateReceiptPdf({
    required String trxCode,
    required String totalBill,
    required String totalPayment,
    required String kembalian,
    required String paymentTime,
    required List<DetailPenjualan> items,
  }) async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: _receiptPageFormat,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text("BUKTI PEMBAYARAN",
                  style: const pw.TextStyle(fontSize: 14)),
              pw.Divider(),
              ...items.map(
                (e) => pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Flexible(
                      child: pw.Text(
                        "${e.productName} \nRp. ${Utils.priceFormatter(e.price)} x${e.qty}",
                      ),
                    ),
                    pw.Flexible(
                      child: pw.Text(
                        "Rp. ${Utils.priceFormatter(e.subtotal)}",
                      ),
                    ),
                  ],
                ),
              ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text("Total tagihan:"),
                  pw.Text("Rp. $totalBill"),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text("Total pembayaran:"),
                  pw.Text("Rp. $totalPayment"),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text("Kembalian:"),
                  pw.Text("Rp. $kembalian"),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text("Tgl transaksi:"),
                  pw.Text(paymentTime),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text("Kode transaksi"),
                  pw.Text(trxCode),
                ],
              ),
            ],
          );
        },
      ),
    );

    return doc;
  }

  static Future<void> savePdfFile(
    Uint8List pdfData,
    String kodeTransaksi,
  ) async {
    final blob = html.Blob([pdfData], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: url)
      ..setAttribute("download", 'detail-transaksi-$kodeTransaksi.pdf')
      ..click();

    html.Url.revokeObjectUrl(url);
  }
}
