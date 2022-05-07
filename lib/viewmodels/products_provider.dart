import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exceptions.dart';

import '../models/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String authenticationToken;
  final String userId;

  Products(this.authenticationToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favorites {
    return items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> loadProducts() async {
    var url = Uri.parse(
        'https://myshopapp-b18b1-default-rtdb.firebaseio.com/products.json?auth=$authenticationToken&orderBy="creatorId"&equalTo="$userId"');
    try {
      final response = await http.get(url);
      final serverData = json.decode(response.body) as Map<String, dynamic>;
      if (serverData.isEmpty) return;
      url = Uri.parse(
          'https://myshopapp-b18b1-default-rtdb.firebaseio.com/userFavorites/$userId/.json?auth=$authenticationToken');
      final userFavorites = await http.get(url);
      final favoritesData = json.decode(userFavorites.body);
      final List<Product> loadedProducts = [];
      serverData.forEach((productId, productInfo) {
        loadedProducts.add(Product(
          id: productId,
          description: productInfo['description'],
          price: double.parse(productInfo['price']),
          title: productInfo['title'],
          imageUrl: productInfo['imageUrl'],
          isFavorite: favoritesData == null
              ? false
              : favoritesData[productId] ?? false,
        ));
      });
      _items = loadedProducts;
      print(_items);
      notifyListeners();
    } catch (errors) {
      throw errors;
    }
  }

  Future<void> addProduct(Product product) async {
    print(userId);
    final url = Uri.parse(
        'https://myshopapp-b18b1-default-rtdb.firebaseio.com/products.json?auth=$authenticationToken');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price.toString(),
            'imageUrl': product.imageUrl,
            'creatorId': userId,
          }));
      final newProduct = Product(
          description: product.description,
          title: product.title,
          price: product.price,
          imageUrl: product.imageUrl,
          id: json.decode(response.body)['name']);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final url = Uri.parse(
        'https://myshopapp-b18b1-default-rtdb.firebaseio.com/products/$id.json?auth=$authenticationToken');
    final productIndex = _items.indexWhere((product) => product.id == id);
    if (productIndex >= 0) {
      _items[productIndex] = newProduct;
      notifyListeners();
      final response = await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price.toString(),
            'imageUrl': newProduct.imageUrl,
            'isFavorite': newProduct.isFavorite,
          }));
      if (response.statusCode >= 400) {
        _items[productIndex] = Product(
          id: newProduct.id,
          title: newProduct.title,
          description: newProduct.description,
          price: newProduct.price,
          imageUrl: newProduct.imageUrl,
          isFavorite: !newProduct.isFavorite,
        );
        notifyListeners();
        throw HttpException(message: response.reasonPhrase as String);
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://myshopapp-b18b1-default-rtdb.firebaseio.com/products/$id.json?auth=$authenticationToken');
    final existingItemIndex = _items.indexWhere((element) => element.id == id);
    final existingProduct = _items[existingItemIndex];
    _items.removeWhere((product) => product.id == id);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingItemIndex, existingProduct);
      notifyListeners();
      throw HttpException(message: response.reasonPhrase as String);
    }
  }

  Future<void> toggleProductFavoriteStatus(
      String userId, String productId, bool status) async {
    final url = Uri.parse(
        'https://myshopapp-b18b1-default-rtdb.firebaseio.com/userFavorites/$userId/$productId.json?auth=$authenticationToken');
    try {
      http.put(url, body: json.encode(status));
    } catch (e) {
      throw e;
    }
  }
}
