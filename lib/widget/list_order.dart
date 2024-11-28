import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant.dart';
import '../models/cart_item.dart';
import '../providers/cart.dart';
import '../utils/utils.dart';

class ListOrderWidget extends StatefulWidget {
  const ListOrderWidget({
    super.key,
  });

  @override
  State<ListOrderWidget> createState() => _ListOrderWidgetState();
}

class _ListOrderWidgetState extends State<ListOrderWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Pesanan :",
          style: bodyLargeBold.copyWith(
            fontSize: 27,
            color: secondaryColor,
          ),
        ),
        Divider(color: Colors.grey.shade400),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 5,
              child: Text(
                "Produk",
                style: titleSmall.copyWith(
                  fontSize: 18,
                ),
              ),
            ),
            Flexible(
              flex: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      "Qty",
                      style: titleSmall.copyWith(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      "Harga",
                      style: titleSmall.copyWith(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Divider(color: Colors.grey.shade400),
        Expanded(
          child: Consumer<Cart>(
            builder: (context, cart, child) {
              return ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemCount: cart.productInCart,
                itemBuilder: (context, index) {
                  CartItem? item = cart.items.values.toList()[index];
                  return ProductCartItem(item: item);
                },
              );
            },
          ),
        ),
        Divider(color: Colors.grey.shade400),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total :",
              style: titleSmall.copyWith(fontSize: 18),
            ),
            Consumer<Cart>(
              builder: (context, value, child) => Text(
                "Rp. ${Utils.priceFormatter(value.totalPrice)}",
                style: titleSmall.copyWith(fontSize: 18),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ProductCartItem extends StatefulWidget {
  const ProductCartItem({
    super.key,
    required this.item,
  });

  final CartItem item;

  @override
  State<ProductCartItem> createState() => _ProductCartItemState();
}

class _ProductCartItemState extends State<ProductCartItem> {
  late final Cart cart;

  @override
  void initState() {
    cart = Provider.of<Cart>(context, listen: false);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 5,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        widget.item.photo,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Flexible(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "${widget.item.title} \n ${widget.item.price}",
                    style: labelMedReg,
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 5,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: IconButton(
                            icon: const Icon(
                              Icons.remove,
                              color: errorColor,
                            ),
                            onPressed: () => cart.minusQty(
                              widget.item.id,
                              widget.item.title,
                              widget.item.price,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "${widget.item.qty}",
                            style: labelMedReg,
                          ),
                        ),
                        Flexible(
                          child: IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: secondaryColor,
                            ),
                            onPressed: () => cart.addCart(
                              widget.item.id,
                              widget.item.title,
                              widget.item.price,
                              widget.item.maxStock,
                              widget.item.photo,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: widget.item.qty >= widget.item.maxStock
                          ? true
                          : false,
                      child: Text(
                        "Maks. beli:  ${widget.item.maxStock}",
                        style: labelMedReg.copyWith(color: errorColor),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 5,
                child: Text(
                  "Rp. ${Utils.priceFormatter(widget.item.price * widget.item.qty)}",
                  style: labelMedReg,
                  maxLines: 3,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
