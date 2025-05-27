import 'package:flutter/material.dart';
import '../models/product.dart';

class WishlistProvider with ChangeNotifier {
  final List<Product> _wishlistItems = [];

  List<Product> get wishlistItems {
    return [..._wishlistItems]; // Return a copy
  }

  bool isProductFavorite(String productId) {
    return _wishlistItems.any((product) => product.id == productId);
  }

  void toggleFavoriteStatus(Product product) {
    final existingIndex = _wishlistItems.indexWhere((item) => item.id == product.id);

    if (existingIndex >= 0) {
      _wishlistItems.removeAt(existingIndex); // Remove if already in wishlist
    } else {
      _wishlistItems.add(product); // Add if not in wishlist
    }
    notifyListeners(); // Notify listeners that state has changed
  }
}