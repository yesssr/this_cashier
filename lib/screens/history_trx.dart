import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../constant.dart';
import '../models/penjualan.dart';
import '../widget/history_list.dart';
import '../widget/search_text_field.dart';
import '../widget/title.dart';

class HistoryTrxScreen extends StatefulWidget {
  const HistoryTrxScreen({super.key});

  @override
  State<HistoryTrxScreen> createState() => _HistoryTrxScreenState();
}

class _HistoryTrxScreenState extends State<HistoryTrxScreen> {
  final Duration debounceTime = const Duration(milliseconds: 500);
  Timer? _debounce;
  ValueNotifier<String> searchQuery = ValueNotifier<String>("");
  final controller = PagingController<int, Penjualan>(firstPageKey: 0);
  final ValueNotifier<DateTime> currentDate = ValueNotifier(DateTime.now());

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: secondaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != currentDate.value) {
      currentDate.value = pickedDate;
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    currentDate.dispose();
    searchQuery.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleAndDate(title: "Riwayat Transaksi"),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 7,
                child: SearchTextField(
                  hintText: "Cari kode transaksi...",
                  icon: const Icon(Icons.search),
                  onChanged: (query) {
                    _debounce?.cancel();
                    _debounce = Timer(debounceTime, () {
                      searchQuery.value = query;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Flexible(
                flex: 3,
                child: ValueListenableBuilder(
                  valueListenable: currentDate,
                  builder: (context, value, child) => GestureDetector(
                    onTap: () => _selectDate(context),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        height: 48,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Tanggal Penjualan :",
                              style: labelMedReg,
                            ),
                            Text(
                              "${currentDate.value.year}-${currentDate.value.month}-${currentDate.value.day}",
                              style: labelMedReg,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.black),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                fit: FlexFit.tight,
                flex: 3,
                child: Text(
                  "Kode Transaksi",
                  style: titleSmall.copyWith(fontSize: 16),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 3,
                child: Text(
                  "Nama Pelanggan",
                  style: titleSmall.copyWith(fontSize: 16),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 3,
                child: Text(
                  "Tanggal Penjualan",
                  style: titleSmall.copyWith(fontSize: 16),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 3,
                child: Text(
                  "Total Harga",
                  style: titleSmall.copyWith(fontSize: 16),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: Text(
                  "Aksi",
                  style: titleSmall.copyWith(fontSize: 16),
                ),
              ),
            ],
          ),
          const Divider(color: Colors.black),
          Expanded(
            child: ListHistoryTrx(
              scrollController: controller,
              date: currentDate,
              search: searchQuery,
            ),
          )
        ],
      ),
    );
  }
}
