import '/models/cart_model.dart';

class OrderModel {
  final String id;
  final double price;
  final List<CartModel> products;
  final DateTime date;

  OrderModel({required this.id, required this.products, required this.price, required this.date});
}
