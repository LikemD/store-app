import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '/models/cart_model.dart';
import '/models/order_model.dart';

class OrderProvider with ChangeNotifier {
  List<OrderModel> _orders = [];
  final String authenticationToken;
  final String userId;

  OrderProvider(this.authenticationToken, this.userId, this._orders);

  List<OrderModel> get orders {
    return [..._orders];
  }

  Future<void> loadOrders() async {
    final url = Uri.parse(
        'https://myshopapp-b18b1-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authenticationToken');
    try {
      final response = await http.get(url);
      final serverData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderModel> orderData = [];
      serverData.forEach((orderId, orderInfo) {
        orderData.add(OrderModel(
          id: orderId,
          price: double.parse(orderInfo['price']),
          date: DateTime.parse(orderInfo['date']),
          products: (orderInfo['products'] as List<dynamic>)
              .map(
                (pdt) => CartModel(
                  id: pdt['id'],
                  name: pdt['name'],
                  price: double.parse(pdt['price']),
                  quantity: int.parse(pdt['quantity']),
                ),
              )
              .toList(),
        ));
      });
      _orders = orderData.reversed.toList();
      notifyListeners();
    } catch (errors) {
      throw errors;
    }
  }

  Future<void> addOrder(double price, List<CartModel> cartProducts) async {
    final url = Uri.parse(
        'https://myshopapp-b18b1-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authenticationToken');
    final date = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'name': cp.name,
                      'price': cp.price.toString(),
                      'quantity': cp.quantity.toString(),
                    })
                .toList(),
            'price': price.toString(),
            'date': date.toIso8601String(),
          }));
      final newOrder = OrderModel(
          products: cartProducts,
          price: price,
          date: date,
          id: json.decode(response.body)['name']);
      _orders.insert(0, newOrder);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
