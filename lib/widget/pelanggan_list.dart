import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../constant.dart';
import '../models/pelanggan.dart';
import '../services/pelanggan.dart';

class ListPelanggans extends StatefulWidget {
  const ListPelanggans({
    super.key,
    required this.scrollController,
    this.filter,
    required this.search,
  });

  final PagingController<int, Pelanggan> scrollController;
  final String? filter;
  final ValueNotifier<String> search;

  @override
  State<ListPelanggans> createState() => _ListPelanggansState();
}

class _ListPelanggansState extends State<ListPelanggans> {
  static const _pageSize = 15;

  @override
  void initState() {
    widget.search.addListener(() {
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
      final newItems = await PelangganService.getPelanggans(
        limit: _pageSize,
        offset: pageKey,
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
    return PagedListView<int, Pelanggan>(
      pagingController: widget.scrollController,
      builderDelegate: PagedChildBuilderDelegate(
        itemBuilder: (context, item, index) => ListTile(
          title: Text(
            "${item.name}",
            style: titleSmall,
          ),
          onTap: () {},
        ),
      ),
    );
  }
}
