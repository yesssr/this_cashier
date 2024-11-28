import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:this_cashier/widget/button.dart';

import '../constant.dart';
import '../models/product.dart';
import '../providers/cart.dart';
import '../widget/list_order.dart';
import '../widget/product_grid.dart';
import '../widget/search_text_field.dart';
import '../widget/tab_bar.dart';
import '../widget/title.dart';
import 'payment.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return Row(
      children: [
        Flexible(
          flex: 6,
          child: Container(
            color: primaryColor,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      flex: 4,
                      child: TitleAndDate(title: "Transaksi"),
                    ),
                    Flexible(
                      flex: 6,
                      child: SearchTextField(
                        hintText: "Cari makanan, minuman, snack dll...",
                        onChanged: (query) {
                          _debounce?.cancel();
                          _debounce = Timer(debounceTime, () {
                            searchQuery.value = query;
                          });
                        },
                      ),
                    ),
                  ],
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
                              ),
                              ListProductGrid(
                                scrollController: newCategoryController,
                                category: "new",
                                search: searchQuery,
                              ),
                              ListProductGrid(
                                scrollController: bundleCategoryController,
                                category: "Paket",
                                search: searchQuery,
                              ),
                              ListProductGrid(
                                scrollController: foodCategoryController,
                                category: "Makanan",
                                search: searchQuery,
                              ),
                              ListProductGrid(
                                scrollController: drinkCategoryController,
                                category: "Minuman",
                                search: searchQuery,
                              ),
                              ListProductGrid(
                                scrollController: snackCategoryController,
                                category: "Snack",
                                search: searchQuery,
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
          ),
        ),
        Flexible(
          flex: 4,
          fit: FlexFit.tight,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(8),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: const Offset(
                    1,
                    3,
                  ),
                ),
              ],
            ),
            child: Column(
              children: [
                const Expanded(child: ListOrderWidget()),
                const SizedBox(height: 8),
                Consumer<Cart>(
                  builder: (context, value, child) => MouseRegion(
                    cursor: value.items.isEmpty
                        ? SystemMouseCursors.forbidden
                        : SystemMouseCursors.click,
                    child: AbsorbPointer(
                      absorbing: value.items.isEmpty ? true : false,
                      child: fillBtn(
                        nameField: "Lanjutkan Pembayaran",
                        color:
                            value.items.isEmpty ? Colors.grey.shade400 : null,
                        context: context,
                        isResponsive: true,
                        onPressed: () => Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (context) => const PaymentScreen(),
                              ),
                            )
                            .then(onFunctionReturnTrue),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
