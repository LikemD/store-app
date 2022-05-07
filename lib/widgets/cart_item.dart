import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/cart_provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {required this.id,
      required this.price,
      required this.title,
      required this.quantity});
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        margin: EdgeInsets.symmetric(vertical: 2),
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 32,
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctc) => AlertDialog(
                  title: Text('Confirm'),
                  content: Text('Are you sure you want to delete this item?'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text('No')),
                    TextButton(onPressed: () {
                      Navigator.of(context).pop(true);
                    }, child: Text('Yes')),
                  ],
                ));
      },
      onDismissed: (direction) => cart.removeItem(id),
      child: Card(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              title: Text(title),
              subtitle: Text('Quantity: $quantity'),
              trailing: Text('Price: \$${price * quantity}'),
            ),
          )),
    );
  }
}
