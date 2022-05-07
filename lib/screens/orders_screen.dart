import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/http_exceptions.dart';

import '/widgets/app_drawer.dart';
import '/widgets/order_item.dart';

import '/viewmodels/order_provider.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders-screen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future _ordersFuture;

  Future _setOrderFuture() {
    return _ordersFuture = Provider.of<OrderProvider>(context, listen: false).loadOrders();
  }

  @override
  void initState() {
    _setOrderFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var orderData = Provider.of<OrderProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future: _ordersFuture,
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (dataSnapshot.connectionState == ConnectionState.done) {
                return Consumer<OrderProvider>(
                    builder: (_, orderData, child) => ListView.builder(
                          itemCount: orderData.orders.length,
                          itemBuilder: (ctx, i) =>
                              OrderItem(order: orderData.orders[i]),
                        ));
              }
              throw HttpException(message: 'Error');
            }));
  }
}
