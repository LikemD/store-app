import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/models/order_model.dart';

class OrderItem extends StatefulWidget {
  final OrderModel order;

  OrderItem({required this.order});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(8),
        child: Column(children: [
          ListTile(
            title: Text('\$${widget.order.price}'),
            subtitle:
                Text(DateFormat('yyyy mm dd hh:mm').format(widget.order.date)),
            trailing: IconButton(
                icon: _expanded
                    ? Icon(Icons.expand_less)
                    : Icon(Icons.expand_more),
                onPressed: () => _toggleExpanded()),
          ),
          if (_expanded)
            Container(
              height: min(widget.order.products.length * 20.0 + 24, 180),
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: ListView.builder(
                  itemCount: widget.order.products.length,
                  itemBuilder: (context, i) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Item: ${widget.order.products[i].name}', style: TextStyle(fontSize: 18,)),
                          Spacer(),
                          Text('Quantity: ${widget.order.products[i].quantity}'),
                          SizedBox(width: 16),
                          Text('Price: \$${widget.order.products[i].price}')
                        ],
                      )),
            ),
        ]));
  }
}
