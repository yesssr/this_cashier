import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../constant.dart';
import '../models/penjualan.dart';
import '../services/penjualan.dart';
import '../utils/utils.dart';
import 'button.dart';

class ListHistoryTrx extends StatefulWidget {
  const ListHistoryTrx({
    super.key,
    required this.scrollController,
    required this.date,
    required this.search,
  });

  final PagingController<int, Penjualan> scrollController;
  final ValueNotifier<DateTime?> date;
  final ValueNotifier<String> search;

  @override
  State<ListHistoryTrx> createState() => _ListHistoryTrxState();
}

class _ListHistoryTrxState extends State<ListHistoryTrx> {
  static const _pageSize = 15;

  @override
  void initState() {
    widget.search.addListener(() {
      widget.scrollController.refresh();
    });
    widget.date.addListener(() {
      widget.scrollController.refresh();
    });
    widget.scrollController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.scrollController
        .removePageRequestListener((pageKey) => _fetchPage(pageKey));
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await PenjualanService.getPenjualans(
        limit: _pageSize,
        offset: pageKey,
        date: widget.date.value,
        search: widget.search.value,
      );
      final isLastPage = newItems.length < _pageSize;

      if (!mounted) return;

      if (isLastPage) {
        widget.scrollController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        widget.scrollController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      if (!mounted) return;
      widget.scrollController.error = error;
    }
  }

  Future<void> refresh() async {
    await Future.delayed(const Duration(seconds: 2));
    widget.scrollController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: PagedListView<int, Penjualan>.separated(
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey.shade400,
        ),
        pagingController: widget.scrollController,
        builderDelegate: PagedChildBuilderDelegate(
          noItemsFoundIndicatorBuilder: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Riwayat Transaksi Kosong !.",
                style: bodyLargeBold,
              ),
              Text(
                "Belum ada transaksi hari ini.",
                style: labelLargeMed,
              ),
            ],
          ),
          itemBuilder: (context, item, index) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                fit: FlexFit.tight,
                flex: 3,
                child: Text(
                  "${item.id}",
                  style: labelMedReg,
                  maxLines: 1,
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 3,
                child: Text(
                  "${item.pelanggan}",
                  style: labelMedReg,
                  maxLines: 1,
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 3,
                child: Text(
                  Utils.dateFormatter(item.tanggalPenjualan!),
                  style: labelMedReg,
                  maxLines: 1,
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 3,
                child: Text(
                  "Rp. ${Utils.priceFormatter(item.totalPrice)}",
                  style: labelMedReg,
                  maxLines: 1,
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: fillBtn(
                  nameField: "Detail",
                  context: context,
                  onPressed: () => PenjualanService.getDetailPenjualan(
                    context: context,
                    penjualan: item,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
