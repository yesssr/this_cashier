import 'package:flutter/material.dart';

import '../models/cart_item.dart';

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  int get productInCart => _items.length;

  void emptyCart() {
    _items.clear();
    notifyListeners();
  }

  double get totalPrice {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.qty * cartItem.price;
    });
    return total;
  }

  void addCart(
    int productId,
    String title,
    double price,
    int maxStock,
    String photo,
  ) {
    if (_items.containsKey("$productId")) {
      if (_items["$productId"]!.qty < maxStock) {
        _items.update(
          "$productId",
          (value) => CartItem(
            id: value.id,
            title: value.title,
            price: value.price,
            qty: value.qty + 1,
            maxStock: value.maxStock,
            photo: value.photo,
          ),
        );
      }
    } else if (maxStock > 0) {
      _items.putIfAbsent(
        "$productId",
        () => CartItem(
          id: productId,
          title: title,
          price: price,
          qty: 1,
          maxStock: maxStock,
          photo: photo,
        ),
      );
    }
    notifyListeners();
  }

  void minusQty(int productId, String title, double price) {
    if (_items.containsKey("$productId") && _items["$productId"]!.qty > 1) {
      _items.update(
        "$productId",
        (value) => CartItem(
          id: value.id,
          title: value.title,
          price: value.price,
          qty: value.qty - 1,
          maxStock: value.maxStock,
          photo: value.photo,
        ),
      );
    } else {
      _items.remove("$productId");
    }
    notifyListeners();
  }

  void editManualQty(
    int productId,
    int qty,
    int maxStock,
  ) {
    if (_items.containsKey("$productId")) {
      _items.update(
        "$productId",
        (value) => CartItem(
          id: value.id,
          title: value.title,
          price: value.price,
          qty: qty >= maxStock ? maxStock : qty,
          maxStock: value.maxStock,
          photo: value.photo,
        ),
      );
    }
    notifyListeners();
  }
}
