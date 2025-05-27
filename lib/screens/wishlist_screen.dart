import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/wishlist_provider.dart';
import '../widgets/product_item.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistData = Provider.of<WishlistProvider>(context);
    final wishlistProducts = wishlistData.wishlistItems;

    if (wishlistProducts.isEmpty) {
      return Center(
        child: Text(
          'Your Wishlist is empty!\nTap the heart icon on a product to add it here.',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      itemCount: wishlistProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.6, // CHANGED: Even smaller ratio for more vertical space
        crossAxisSpacing: 4,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (ctx, i) => ProductItem(
        product: wishlistProducts[i],
      ),
    );
  }
}