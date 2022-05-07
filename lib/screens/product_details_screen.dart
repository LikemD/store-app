import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/products_provider.dart';

class ProductDetails extends StatelessWidget {
  // final String title;
  ProductDetails(/*{required this.title}*/);

  static const routeName = '/product-details';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final product = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 10),
              child: Image.network(product.imageUrl),
            ),
            Text('\$${product.price}', style: TextStyle(fontSize: 32)),
            SizedBox(height: 10,),
            Container( width: double.infinity, padding: EdgeInsets.symmetric(horizontal: 16) ,child: Text(product.description, style: TextStyle(fontSize: 20), textAlign: TextAlign.center, softWrap: true,))
          ],
        ),
      ),
    );
  }
}
