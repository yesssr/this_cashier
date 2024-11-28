import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:this_cashier/models/cart_item.dart';

import '../providers/cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Produk"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Qty"),
                Text("Harga"),
              ],
            ),
          ],
        ),
        Expanded(
          child: Consumer<Cart>(
            builder: (context, value, child) {
              List<CartItem> items = value.items.values.toList();
              return ListView.builder(
                itemBuilder: (context, index) {
                  CartItem item = items[index];
                  return Row(
                    children: [
                      Text(item.title),
                      Text("${item.qty}"),
                      Text("${item.price}"),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
