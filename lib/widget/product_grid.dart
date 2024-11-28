import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../constant.dart';
import '../models/product.dart';
import '../services/products.dart';
import 'product_item.dart';

class ListProductGrid extends StatefulWidget {
  const ListProductGrid({
    super.key,
    required this.scrollController,
    required this.search,
    this.childAspectRatio,
    this.category,
    this.maxCrossAxisExtent,
    this.itemBuilder,
  });
  final PagingController<int, Product> scrollController;
  final double? childAspectRatio;
  final double? maxCrossAxisExtent;
  final Widget Function(BuildContext, Product, int)? itemBuilder;
  final String? category;
  final ValueNotifier<String> search;
  @override
  State<ListProductGrid> createState() => _ListProductGridState();
}

class _ListProductGridState extends State<ListProductGrid> {
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
      final newItems = await ProductService.getProducts(
        limit: _pageSize,
        offset: pageKey,
        category: widget.category,
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
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: RefreshIndicator(
        onRefresh: refresh,
        child: PagedGridView<int, Product>(
          pagingController: widget.scrollController,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: widget.maxCrossAxisExtent ?? 300,
            childAspectRatio: widget.childAspectRatio ?? 4 / 4,
          ),
          builderDelegate: PagedChildBuilderDelegate(
            noItemsFoundIndicatorBuilder: (context) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Produk Kosong !.",
                  style: bodyLargeBold,
                ),
                Text(
                  "Belum ada produk yang ditambahkan.",
                  style: labelLargeMed,
                ),
              ],
            ),
            itemBuilder: widget.itemBuilder ??
                (context, item, index) => ProductItem(
                      product: item,
                    ),
          ),
        ),
      ),
    );
  }
}
