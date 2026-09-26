import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Product {
  final String name;
  final double price;

  Product({
    required this.name,
    required this.price,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Product> products = [
      Product(name: 'Laptop', price: 55000),
      Product(name: 'Mobile', price: 25000),
      Product(name: 'Headphones', price: 2000),
      Product(name: 'Keyboard', price: 1500),
      Product(name: 'Mouse', price: 800),
    ];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Product List'),
        ),
        body: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];

            return ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: Text(product.name),
              subtitle: Text('Price: ₹${product.price}'),
            );
          },
        ),
      ),
    );
  }
}
