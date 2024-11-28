import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/product.dart';
import '../widget/button.dart';
import '../widget/product_form.dart';
import '../widget/product_grid.dart';
import '../widget/product_item_inventory.dart';
import '../widget/search_text_field.dart';
import '../widget/tab_bar.dart';
import '../widget/title.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final Duration debounceTime = const Duration(milliseconds: 500);
  Timer? _debounce;
  ValueNotifier<String> searchQuery = ValueNotifier<String>("");
  final allCategoryController = PagingController<int, Product>(firstPageKey: 0);
  final newCategoryController = PagingController<int, Product>(firstPageKey: 0);
  final bundleCategoryController =
      PagingController<int, Product>(firstPageKey: 0);
  final foodCategoryController =
      PagingController<int, Product>(firstPageKey: 0);
  final drinkCategoryController =
      PagingController<int, Product>(firstPageKey: 0);
  final snackCategoryController =
      PagingController<int, Product>(firstPageKey: 0);

  var listTab = const [
    Tab(text: "Semua"),
    Tab(text: "Terbaru"),
    Tab(text: "Paket"),
    Tab(text: "Makanan"),
    Tab(text: "Minuman"),
    Tab(text: "Snack"),
  ];

  void refreshPage() {
    allCategoryController.refresh();
    newCategoryController.refresh();
    bundleCategoryController.refresh();
    foodCategoryController.refresh();
    drinkCategoryController.refresh();
    snackCategoryController.refresh();
  }

  Function(dynamic)? onFunctionReturnTrue(value) {
    if (value is bool && value == true) refreshPage();
    return null;
  }

  double itemRatio = 6 / 3;
  double maxSizeItem = 500;

  @override
  void dispose() {
    super.dispose();
    allCategoryController.dispose();
    newCategoryController.dispose();
    bundleCategoryController.dispose();
    foodCategoryController.dispose();
    drinkCategoryController.dispose();
    snackCategoryController.dispose();
    searchQuery.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleAndDate(title: "Stok"),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: fillBtn(
              nameField: "Tambah produk",
              context: context,
              onPressed: () => showDialog(
                context: context,
                builder: (context) => const ProductForm(),
              ).then(onFunctionReturnTrue),
            ),
          ),
          const SizedBox(height: 16),
          SearchTextField(
            hintText: "Cari produk...",
            icon: const Icon(Icons.search),
            onChanged: (query) {
              _debounce?.cancel();
              _debounce = Timer(
                debounceTime,
                () {
                  searchQuery.value = query;
                },
              );
            },
          ),
          Expanded(
            child: DefaultTabController(
              length: listTab.length,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyTabBar(tabs: listTab),
                  Expanded(
                    child: TabBarView(
                      children: [
                        ListProductGrid(
                          scrollController: allCategoryController,
                          search: searchQuery,
                          childAspectRatio: itemRatio,
                          maxCrossAxisExtent: maxSizeItem,
                          itemBuilder: (ctx, item, index) =>
                              ProductItemInventory(
                            product: item,
                            onValue: onFunctionReturnTrue,
                          ),
                        ),
                        ListProductGrid(
                          scrollController: newCategoryController,
                          category: "new",
                          search: searchQuery,
                          childAspectRatio: itemRatio,
                          maxCrossAxisExtent: maxSizeItem,
                          itemBuilder: (ctx, item, index) =>
                              ProductItemInventory(
                            product: item,
                            onValue: onFunctionReturnTrue,
                          ),
                        ),
                        ListProductGrid(
                          scrollController: bundleCategoryController,
                          category: "Paket",
                          search: searchQuery,
                          childAspectRatio: itemRatio,
                          maxCrossAxisExtent: maxSizeItem,
                          itemBuilder: (ctx, item, index) =>
                              ProductItemInventory(
                            product: item,
                            onValue: onFunctionReturnTrue,
                          ),
                        ),
                        ListProductGrid(
                          scrollController: foodCategoryController,
                          category: "Makanan",
                          search: searchQuery,
                          childAspectRatio: itemRatio,
                          maxCrossAxisExtent: maxSizeItem,
                          itemBuilder: (ctx, item, index) =>
                              ProductItemInventory(
                            product: item,
                            onValue: onFunctionReturnTrue,
                          ),
                        ),
                        ListProductGrid(
                          scrollController: drinkCategoryController,
                          category: "Minuman",
                          search: searchQuery,
                          childAspectRatio: itemRatio,
                          maxCrossAxisExtent: maxSizeItem,
                          itemBuilder: (ctx, item, index) =>
                              ProductItemInventory(
                            product: item,
                            onValue: onFunctionReturnTrue,
                          ),
                        ),
                        ListProductGrid(
                          scrollController: snackCategoryController,
                          category: "Snack",
                          search: searchQuery,
                          childAspectRatio: itemRatio,
                          maxCrossAxisExtent: maxSizeItem,
                          itemBuilder: (ctx, item, index) =>
                              ProductItemInventory(
                            product: item,
                            onValue: onFunctionReturnTrue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
