import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:this_cashier/widget/form_image.dart';

import '../constant.dart';
import '../models/product.dart';
import '../services/products.dart';
import '../utils/utils.dart';
import 'button.dart';
import 'dropdown.dart';
import 'form_input.dart';

class ProductForm extends StatefulWidget {
  const ProductForm({super.key, this.product});
  final Product? product;
  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  dynamic photo;
  String? category;

  final categories = [
    {"category": "Paket"},
    {"category": "Makanan"},
    {"category": "Minuman"},
    {"category": "Snack"},
  ];

  @override
  void initState() {
    if (widget.product != null) {
      Product product = widget.product!;
      nameController.text = product.name!;
      priceController.text = "${product.price}";
      stockController.text = "${product.stok}";
      category = product.category;
    }
    super.initState();
  }

  void createProduct() async {
    await ProductService.postProduct(
        context: context,
        name: nameController.text,
        photo: photo,
        price: priceController.text,
        stok: int.parse(stockController.text),
        category: category!);
  }

  void editProduct() async {
    await ProductService.editProduct(
      id: widget.product!.id!,
      context: context,
      name: nameController.text,
      photo: photo,
      price: priceController.text,
      stok: int.parse(stockController.text),
      category: category!,
      photoName: widget.product!.photo!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(
        widget.product == null ? "Tambah produk" : "Edit produk",
        style: bodyLargeBold,
      ),
      content: SizedBox(
        width: 312,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              FormInputWidget(
                nameField: "Nama",
                hint: "Isi dengan nama produk",
                fieldController: nameController,
              ),
              const SizedBox(height: 8),
              FormInputWidget(
                nameField: "Harga",
                keyboardType: TextInputType.number,
                fieldController: priceController,
                hint: "Rp.....",
                validator: (value) {
                  var val = Utils.isNumber(
                    value!,
                    "Jumlah pembayaran",
                  );
                  return val;
                },
              ),
              const SizedBox(height: 8),
              FormInputWidget(
                nameField: "Stok",
                hint: "Isi dengan jumlah stok",
                keyboardType: TextInputType.number,
                fieldController: stockController,
              ),
              const SizedBox(height: 8),
              MyDropdown(
                nameField: "Kategori",
                hintText: "Pilih kategori",
                initValue: category,
                items: categories
                    .map(
                      (e) => DropdownMenuItem(
                        value: e['category'],
                        child: Text("${e['category']}"),
                      ),
                    )
                    .toList(),
                onChanged: (value) => category = value,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: fixedMobileSize,
                  child: Text(
                    "Foto produk",
                    style: labelMedBold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ImagePickerFormField(
                item: widget.product,
                onSaved: (newValue) => setState(() {
                  if (newValue != null) {
                    if (newValue is Uint8List) {
                      photo = newValue;
                    } else {
                      photo = File(newValue.path);
                    }
                  }
                }),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  otlBtn(
                    nameField: "Batal",
                    context: context,
                    negActions: true,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  fillBtn(
                    nameField: "Simpan",
                    context: context,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        widget.product == null
                            ? createProduct()
                            : editProduct();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
