import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/auth_screen.dart';

import '/viewmodels/cart_provider.dart';
import '/viewmodels/products_provider.dart';
import '/viewmodels/order_provider.dart';
import '/viewmodels/auth_provider.dart';

import '/screens/products_overview_screen.dart';
import '/screens/product_details_screen.dart';
import '/screens/cart_screen.dart';
import '/screens/orders_screen.dart';
import '/screens/user_products_screen.dart';
import '/screens/edit_product_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => AuthProvider()),
          ChangeNotifierProxyProvider<AuthProvider, Products>(
            create: (ctx) => Products('', '', []),
            update: (ctx, authProvider, previousProductsState) => Products(
                authProvider.token,
                authProvider.userId,
                previousProductsState!.items.isNotEmpty
                    ? previousProductsState.items
                    : []),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
            create: (ctx) => OrderProvider('', '', []),
            update: (ctx, authProvider, previousOrderState) => OrderProvider(
                authProvider.token,
                authProvider.userId,
                previousOrderState!.orders.isNotEmpty
                    ? previousOrderState.orders
                    : []),
          ),
        ],
        child: Consumer<AuthProvider>(
          builder: (context, auth, _) => MaterialApp(
            title: 'My Shop',
            theme: ThemeData(
                fontFamily: 'Lato',
                colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
                    .copyWith(secondary: Colors.deepOrange)),
            home: auth.isAuthenticated
                ? ProductsOverview()
                : FutureBuilder(
                    future: auth.attemptAutoLogin(),
                    builder: (ctx, authProviderSnapshot) =>
                        (authProviderSnapshot.connectionState ==
                                ConnectionState.waiting)
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : AuthScreen()),
            routes: {
              ProductDetails.routeName: (context) => ProductDetails(),
              CartScreen.routeName: (context) => CartScreen(),
              OrdersScreen.routeName: (context) => OrdersScreen(),
              UserProductsScreen.routeName: (context) => UserProductsScreen(),
              EditProductScreen.routeName: (context) => EditProductScreen()
            },
            debugShowCheckedModeBanner: false,
          ),
        ));
  }
}
