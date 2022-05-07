import 'package:flutter/foundation.dart';

import '../models/cart_model.dart';

class Cart with ChangeNotifier {
  Map<String, CartModel> _items = {};


  Map<String, CartModel> get items {
    return {..._items};
  }

  int get itemCount {
    var totalCount = 0;
    _items.forEach((key, value) => totalCount += value.quantity);
    return totalCount;
  }

  double get totalAmount {
    var totalAmount = 0.0;
    _items.forEach(
        (key, cartItem) => totalAmount += (cartItem.price * cartItem.quantity));
    return totalAmount;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CartModel(
                id: existingCartItem.id,
                price: existingCartItem.price,
                name: existingCartItem.name,
                quantity: existingCartItem.quantity + 1,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartModel(
              id: DateTime.now().toString(),
              price: price,
              name: title,
              quantity: 1));
    }

    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((key, cartItem) => cartItem.id == id);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId]!.quantity > 1) {
        _items.update(
            productId,
            (existingCartItem) => CartModel(
                  id: existingCartItem.id,
                  price: existingCartItem.price,
                  name: existingCartItem.name,
                  quantity: existingCartItem.quantity - 1,
                ));
      } else {
        _items.remove(productId);
      }
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
