import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:this_cashier/widget/button.dart';

import '../constant.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../services/products.dart';
import '../utils/utils.dart';
import 'avatar_profile.dart';
import 'product_form.dart';

class ProductItemInventory extends StatefulWidget {
  const ProductItemInventory({
    super.key,
    required this.product,
    this.onValue,
  });

  final Product product;
  final FutureOr Function(dynamic)? onValue;

  @override
  State<ProductItemInventory> createState() => _ProductItemInventoryState();
}

class _ProductItemInventoryState extends State<ProductItemInventory> {
  late final ValueNotifier<int> stok;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isEditing = false;
  late final User user;
  late final bool isAdmin;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).getUser;
    isAdmin = user.slug == "admin" ? true : false;
    stok = ValueNotifier(widget.product.stok!);
    stok.addListener(() {
      if (!_isEditing) {
        _controller.text = stok.value.toString();
      }
    });
    _controller.text = stok.value.toString();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          _isEditing = false;
          int? newValue = int.tryParse(_controller.text);
          if (newValue != null) {
            stok.value = newValue;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    stok.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            spreadRadius: 7,
            blurRadius: 11,
            offset: const Offset(
              -7,
              7,
            ),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 3,
            fit: FlexFit.tight,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SeeDetailImage(
                      url: "${widget.product.photo}",
                      id: "${widget.product.id}",
                    ),
                  ),
                ),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        "${widget.product.photo}",
                      ),
                    ),
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 7,
            fit: FlexFit.tight,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.product.name}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: titleSmall,
                              ),
                              Text(
                                "${widget.product.category}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: labelLargeMed.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                "Rp. ${Utils.priceFormatter(double.tryParse(widget.product.price?? "0"))}",
                                style: labelLargeMed.copyWith(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isAdmin)
                          Flexible(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                  color: addColor,
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => ProductForm(
                                      product: widget.product,
                                    ),
                                  ).then(widget.onValue ?? (value) {}),
                                ),
                                IconButton(
                                  color: errorColor,
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => Utils.showConfirmDialog(
                                    context: context,
                                    isNegativeAction: true,
                                    title: "Hapus Produk ?",
                                    content: "Yakin menghapus produk ini ?",
                                    onNotOke: () => ProductService.deleteProduk(
                                      context,
                                      widget.product.id!,
                                    ),
                                    onOke: () => Navigator.of(context).pop(),
                                    onValue: widget.onValue ?? (value) {},
                                  ),
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 4,
                          child: Text(
                            "Stok: ",
                            style: labelMedReg,
                          ),
                        ),
                        Flexible(
                          flex: 6,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 4,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.remove,
                                          color: Colors.red,
                                        ),
                                        iconSize: 16,
                                        padding: const EdgeInsets.all(4),
                                        onPressed: () {
                                          stok.value = (stok.value > 0)
                                              ? stok.value - 1
                                              : 0;
                                        },
                                      ),
                                    ),
                                    Flexible(
                                      flex: 4,
                                      child: ValueListenableBuilder<int>(
                                        valueListenable: stok,
                                        builder: (context, value, child) {
                                          if (_isEditing) {
                                            return TextField(
                                              style: labelMedReg,
                                              controller: _controller,
                                              focusNode: _focusNode,
                                              keyboardType:
                                                  TextInputType.number,
                                              onSubmitted: (value) {
                                                setState(() {
                                                  _isEditing = false;
                                                  int? newValue =
                                                      int.tryParse(value);
                                                  if (newValue != null) {
                                                    stok.value = newValue;
                                                  }
                                                });
                                              },
                                            );
                                          } else {
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _isEditing = true;
                                                  _focusNode.requestFocus();
                                                });
                                              },
                                              child: Text(
                                                '$value',
                                                style: labelMedReg,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    Flexible(
                                      flex: 3,
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.add,
                                          color: Colors.green,
                                        ),
                                        iconSize: 16,
                                        padding: const EdgeInsets.all(4),
                                        onPressed: () {
                                          stok.value += 1;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 6,
                                child: fillBtn(
                                  context: context,
                                  nameField: "Update Stok",
                                  onPressed: () => Utils.showConfirmDialog(
                                    context: context,
                                    title: "Update Stok ?",
                                    content:
                                        "Yakin mengupdate stok produk ini ?",
                                    onOke: () => ProductService.updateStok(
                                      context,
                                      widget.product.id!,
                                      stok.value,
                                    ),
                                    onNotOke: () => Navigator.of(context).pop(),
                                    onValue: widget.onValue ?? (value) {},
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
