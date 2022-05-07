import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/widgets/app_drawer.dart';
import '/widgets/user_product_item.dart';

import '/viewmodels/products_provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products-screen';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);

    return RefreshIndicator(
      onRefresh: () => _refreshProducts(context),
      child: Scaffold(
          appBar: AppBar(
            title: Text('My Products'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.pushNamed(context, '/edit-product-screen',
                      arguments: '');
                },
              ),
            ],
          ),
          drawer: AppDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                itemCount: products.items.length,
                itemBuilder: (_, i) => Column(
                      children: [
                        UserProductItem(
                            id: products.items[i].id,
                            name: products.items[i].title,
                            imageUrl: products.items[i].imageUrl),
                        Divider(),
                      ],
                    )),
          )),
    );
  }
}
