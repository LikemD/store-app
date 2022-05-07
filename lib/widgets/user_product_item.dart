import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/viewmodels/products_provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String name;
  final String imageUrl;

  UserProductItem(
      {required this.id, required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(name),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 96,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed('/edit-product-screen', arguments: id);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Theme.of(context).errorColor),
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                } catch (e) {
                  scaffoldMessenger.showSnackBar(SnackBar(
                      content: Text('Something went wrong. Please try again')));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
