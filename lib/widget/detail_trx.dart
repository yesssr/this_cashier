import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:this_cashier/constant.dart';
import 'package:this_cashier/models/penjualan.dart';
import 'package:this_cashier/widget/button.dart';

import '../models/detail_penjualan.dart';
import '../utils/utils.dart';
import 'detail_order_result.dart';

class DetailTrx extends StatelessWidget {
  const DetailTrx({
    super.key,
    required this.penjualan,
    required this.listDetailPenjualan,
  });

  final Penjualan penjualan;
  final List<DetailPenjualan> listDetailPenjualan;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(
        "Detail Transaksi",
        style: bodyLargeBold,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailOrderResult(
            title: "KODE TRANSAKSI",
            content: "${penjualan.id}",
          ),
          DetailOrderResult(
            title: "TOTAL TAGIHAN",
            content: Utils.priceFormatter(penjualan.totalPrice).toString(),
          ),
          DetailOrderResult(
            title: "NOMINAL BAYAR",
            content: Utils.priceFormatter(penjualan.totalPayment).toString(),
          ),
          DetailOrderResult(
            title: "KEMBALIAN",
            content: Utils.priceFormatter(
                    penjualan.totalPayment! - penjualan.totalPrice!)
                .toString(),
          ),
          DetailOrderResult(
            title: "WAKTU PEMBAYARAN",
            content: Utils.dateFormatter(penjualan.tanggalPenjualan!),
          ),
          Text(
            "PRODUK :",
            style: labelLargeMed,
          ),
          const SizedBox(height: 8),
          ...listDetailPenjualan
              .map(
                (detailPenjualan) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 150),
                      child: Text(
                        "${detailPenjualan.productName} \n ${detailPenjualan.price}     x${detailPenjualan.qty}",
                        style: labelMedReg,
                      ),
                    ),
                    Text(
                      "Rp. ${Utils.priceFormatter(detailPenjualan.subtotal)}",
                      style: labelMedReg,
                      maxLines: 3,
                    ),
                  ],
                ),
              )
              .toList(),
        ],
      ),
      actions: [
        otlBtn(
          nameField: "Tutup",
          negActions: true,
          fixedMobileSize: true,
          context: context,
          onPressed: () => Navigator.of(context).pop(),
        ),
        fillBtn(
          nameField: "Print",
          fixedMobileSize: true,
          context: context,
          onPressed: () async {
            final pdfDoc = await Utils.generateReceiptPdf(
              trxCode: "${penjualan.id}",
              totalBill: Utils.priceFormatter(penjualan.totalPrice).toString(),
              kembalian: Utils.priceFormatter(
                  penjualan.totalPayment! - penjualan.totalPrice!),
              totalPayment:
                  Utils.priceFormatter(penjualan.totalPayment).toString(),
              paymentTime: Utils.dateFormatter(penjualan.tanggalPenjualan!),
              items: listDetailPenjualan,
            );
            // Utils.savePdfFile(await pdfDoc.save(), "${penjualan.id}");
            await Printing.layoutPdf(
              onLayout: (format) => pdfDoc.save(),
            );
          },
        ),
      ],
    );
  }
}
