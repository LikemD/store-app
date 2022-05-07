import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/viewmodels/order_provider.dart';

import '../viewmodels/cart_provider.dart';

import '../widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart-screen';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isEmpty = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);
    if (cart.items.values.toList().length > 0)
      setState(() {
        _isEmpty = false;
      });
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text('\$${cart.totalAmount}',
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .headline1!
                                .color)),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  TextButton(
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text('ORDER NOW'),
                    onPressed: _isEmpty
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Please add items to your cart to order')));
                          }
                        : () async {
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              await Provider.of<OrderProvider>(context,
                                      listen: false)
                                  .addOrder(cart.totalAmount,
                                      cart.items.values.toList());
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Order Sent!')));
                              cart.clearCart();
                              setState(() {
                                _isEmpty = true;
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Oops... something went wrong.')));
                            } finally {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                itemBuilder: (context, i) => CartItem(
                    id: cart.items.values.toList()[i].id,
                    price: cart.items.values.toList()[i].price,
                    title: cart.items.values.toList()[i].name,
                    quantity: cart.items.values.toList()[i].quantity),
                itemCount: cart.items.length),
          ),
        ],
      ),
    );
  }
}
