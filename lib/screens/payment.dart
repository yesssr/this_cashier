import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:this_cashier/widget/button.dart';
import 'package:this_cashier/widget/form_input.dart';

import '../constant.dart';
import '../models/pelanggan.dart';
import '../providers/cart.dart';
import '../services/pelanggan.dart';
import '../services/penjualan.dart';
import '../utils/utils.dart';
import '../widget/custom_active_text.dart';
import '../widget/list_order.dart';
import '../widget/pelanggan_form.dart';
import '../widget/search_text_field.dart';
import '../widget/title.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  static const _pageSize = 15;
  Pelanggan? _pelanggan;
  ValueNotifier<bool> isNewPelanggan = ValueNotifier(false);
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final paymentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late final Cart cart;

  void postPenjualan() async {
    await PenjualanService.postPenjualan(
      context: context,
      totalPrice: cart.totalPrice,
      totalPayment: double.parse(
        paymentController.text,
      ),
      pelangganId: _pelanggan?.id,
      cart: cart,
    );
  }

  @override
  void initState() {
    cart = Provider.of<Cart>(
      context,
      listen: false,
    );
    super.initState();
  }

  Future<List<Pelanggan>> _fetchPage(String query) async {
    try {
      final response = await PelangganService.getPelanggans(
        limit: _pageSize,
        offset: 0,
        search: query,
      );

      return response;
    } catch (error) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Flexible(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: const ListOrderWidget(),
            ),
          ),
          Flexible(
            flex: 6,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TitleAndDate(title: "Pembayaran"),
                  const SizedBox(height: 16),
                  Divider(color: Colors.grey.shade400),
                  Text(
                    "Pelanggan",
                    style: bodyLargeBold.copyWith(
                      color: secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Autocomplete<Pelanggan>(
                    displayStringForOption: (option) => option.name!,
                    optionsBuilder: (TextEditingValue textEditingValue) async {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<Pelanggan>.empty();
                      }
                      List<Pelanggan> pelanggans =
                          await _fetchPage(textEditingValue.text);

                      return pelanggans.map((pelanggan) {
                        return pelanggan;
                      });
                    },
                    onSelected: (Pelanggan selection) => setState(() {
                      _pelanggan = selection;
                    }),
                    fieldViewBuilder: (
                      BuildContext context,
                      TextEditingController textEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted,
                    ) =>
                        SearchTextField(
                      hintText: "Cari pelanggan...",
                      controller: textEditingController,
                      onSubmitted: (_) => onFieldSubmitted(),
                      focusNode: focusNode,
                    ),
                    optionsViewBuilder: (context, onSelected, options) => Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4.0,
                        child: SizedBox(
                          width: 300,
                          height: 200,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: options.length,
                            itemBuilder: (BuildContext context, int index) {
                              final Pelanggan option = options.toList()[index];
                              return GestureDetector(
                                onTap: () => onSelected(option),
                                child: ListTile(
                                  title: Text(
                                    option.name!,
                                    style: labelMedReg,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: isNewPelanggan,
                      builder: (context, value, child) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: isNewPelanggan.value,
                                onChanged: (value) {
                                  isNewPelanggan.value = value!;
                                },
                              ),
                              Text(
                                "Pelanggan baru",
                                style: labelLargeMed.copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Visibility(
                            visible: isNewPelanggan.value,
                            replacement: Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomActiveText(
                                        activeText:
                                            "   ${_pelanggan?.name ?? ""}",
                                        passiveText: "Nama     :",
                                        color: Colors.black,
                                      ),
                                      const SizedBox(height: 8),
                                      CustomActiveText(
                                        activeText:
                                            "   ${_pelanggan?.phone ?? ""}",
                                        passiveText: "No. Hp  :",
                                        color: Colors.black,
                                      ),
                                      const SizedBox(height: 8),
                                      CustomActiveText(
                                        activeText:
                                            "   ${_pelanggan?.address ?? ""}",
                                        passiveText: "Alamat  :",
                                        color: Colors.black,
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                  Divider(color: Colors.grey.shade400),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Form(
                                          key: formKey,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Total Bayar",
                                                style: bodyLargeBold.copyWith(
                                                  color: secondaryColor,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              FormInputWidget(
                                                nameField: "Jumlah Pembayaran",
                                                isResponsive: true,
                                                hint:
                                                    "Masukkan jumlah pembayaran...",
                                                keyboardType:
                                                    TextInputType.number,
                                                fieldController:
                                                    paymentController,
                                                disposed: false,
                                                validator: (value) {
                                                  var val = Utils.isNumber(
                                                    value!,
                                                    "Jumlah pembayaran",
                                                  );
                                                  if (val != null) return val;
                                                  if (double.parse(value) <
                                                      cart.totalPrice) {
                                                    return "Jumlah pembayaran kurang!.";
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(height: 16),
                                              Wrap(
                                                alignment: WrapAlignment.start,
                                                spacing: 16,
                                                children: [
                                                  fillBtn(
                                                    nameField: "UANG PAS",
                                                    context: context,
                                                    onPressed: () {
                                                      paymentController.text =
                                                          "${cart.totalPrice}";
                                                    },
                                                  ),
                                                  fillBtn(
                                                    nameField: "50.000",
                                                    context: context,
                                                    onPressed: () {
                                                      paymentController.text =
                                                          "50000";
                                                    },
                                                  ),
                                                  fillBtn(
                                                    nameField: "100.000",
                                                    context: context,
                                                    onPressed: () {
                                                      paymentController.text =
                                                          "100000";
                                                    },
                                                  ),
                                                  fillBtn(
                                                    nameField: "150.000",
                                                    context: context,
                                                    onPressed: () {
                                                      paymentController.text =
                                                          "150000";
                                                    },
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 8.0,
                                                ),
                                                child: otlBtn(
                                                  negActions: true,
                                                  nameField: "Batalkan",
                                                  context: context,
                                                  isResponsive: true,
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: fillBtn(
                                                  nameField: "Bayar",
                                                  context: context,
                                                  isResponsive: true,
                                                  onPressed: () async {
                                                    if (formKey.currentState!
                                                        .validate()) {
                                                      postPenjualan();
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            child: Expanded(
                              child: PelangganForm(
                                nameController: nameController,
                                phoneController: phoneController,
                                addressController: addressController,
                                onValue: (pelanggan) {
                                  if (pelanggan != null) {
                                    isNewPelanggan.value = false;
                                    setState(() {
                                      _pelanggan = pelanggan;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
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
