import 'dart:async';

import 'package:flutter/material.dart';

import '../models/pelanggan.dart';
import '../services/pelanggan.dart';
import '../utils/utils.dart';
import 'button.dart';
import 'form_input.dart';

class PelangganForm extends StatefulWidget {
  const PelangganForm({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    this.onValue,
  });

  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final FutureOr Function(Pelanggan?)? onValue;

  @override
  State<PelangganForm> createState() => _PelangganFormState();
}

class _PelangganFormState extends State<PelangganForm> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    widget.nameController.clear();
    widget.phoneController.clear();
    widget.addressController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: 16,
            runSpacing: 8,
            children: [
              FormInputWidget(
                nameField: "Nama",
                fieldController: widget.nameController,
                hint: "Masukkan nama pelanggan",
                disposed: false,
              ),
              FormInputWidget(
                nameField: "No. Hp",
                fieldController: widget.phoneController,
                keyboardType: TextInputType.phone,
                hint: "Masukkan no hp pelanggan",
                disposed: false,
                validator: (value) {
                  var val = Utils.isNumber(value!, "No. Hp");
                  if (val != null) return val;
                  if (value.length < 11) {
                    return "No. Hp minimal 11 karakter!.";
                  }

                  return null;
                },
              ),
              FormInputWidget(
                nameField: "Alamat",
                fieldController: widget.addressController,
                hint: "Masukkan alamat pelanggan",
                maxLines: 5,
                disposed: false,
              ),
            ],
          ),
          fillBtn(
            nameField: "Simpan",
            context: context,
            isResponsive: true,
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await PelangganService.postPelanggan(
                  context: context,
                  name: widget.nameController.text,
                  address: widget.addressController.text,
                  phone: widget.phoneController.text,
                ).then(widget.onValue ?? (value) {});
              }
            },
          ),
        ],
      ),
    );
  }
}
