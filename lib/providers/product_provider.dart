import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: 'p1',
      name: 'Blue T-Shirt',
      description: 'A classic blue t-shirt made from 100% cotton.',
      price: 19.99,
      imageUrl: 'https://picsum.photos/id/200/200', // Placeholder
    ),
    Product(
      id: 'p2',
      name: 'Stylish Jeans',
      description: 'Comfortable and stylish denim jeans.',
      price: 49.99,
      imageUrl: 'https://picsum.photos/id/190/200', // Placeholder
    ),
    Product(
      id: 'p3',
      name: 'Leather Wallet',
      description: 'High-quality genuine leather wallet.',
      price: 29.99,
      imageUrl: 'https://picsum.photos/id/180/200', // Placeholder
    ),
    Product(
      id: 'p4',
      name: 'Sports Shoes',
      description: 'Lightweight and durable sports shoes.',
      price: 79.99,
      imageUrl: 'https://picsum.photos/id/170/200', // Placeholder
    ),
    Product(
      id: 'p5',
      name: 'Running Cap',
      description: 'Lightweight and breathable cap for running.',
      price: 15.00,
      imageUrl: 'https://picsum.photos/id/210/200', // Placeholder
    ),
    Product(
      id: 'p6',
      name: 'Sunglasses',
      description: 'Fashionable sunglasses with UV protection.',
      price: 35.50,
      imageUrl: 'https://picsum.photos/id/160/200', // Placeholder
    ),
    // Add many more products here to force scrolling
    Product(
      id: 'p7',
      name: 'Casual Shirt',
      description: 'Comfortable casual shirt for everyday wear.',
      price: 25.99,
      imageUrl: 'https://picsum.photos/id/150/200',
    ),
    Product(
      id: 'p8',
      name: 'Backpack',
      description: 'Durable backpack for travel or daily use.',
      price: 55.00,
      imageUrl: 'https://picsum.photos/id/140/200',
    ),
    Product(
      id: 'p9',
      name: 'Smartwatch',
      description: 'Feature-rich smartwatch with health tracking.',
      price: 199.99,
      imageUrl: 'https://picsum.photos/id/130/200',
    ),
    Product(
      id: 'p10',
      name: 'Headphones',
      description: 'Noise-cancelling headphones for immersive audio.',
      price: 120.00,
      imageUrl: 'https://picsum.photos/id/120/200',
    ),
    Product(
      id: 'p11',
      name: 'Yoga Mat',
      description: 'Eco-friendly yoga mat for your practice.',
      price: 30.00,
      imageUrl: 'https://picsum.photos/id/110/200',
    ),
    Product(
      id: 'p12',
      name: 'Coffee Mug',
      description: 'Ceramic coffee mug for your daily brew.',
      price: 12.50,
      imageUrl: 'https://picsum.photos/id/100/200',
    ),
    // ... continue adding more similar dummy products to fill up the screen and beyond
  ];

  List<Product> get products {
    return [..._products];
  }

  Product findById(String id) {
    return _products.firstWhere((prod) => prod.id == id);
  }

  List<Product> getFilteredProducts(String query) {
    if (query.isEmpty) {
      return [..._products];
    }
    return _products
        .where((product) => product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}