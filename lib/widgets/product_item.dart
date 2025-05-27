import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final wishlist = Provider.of<WishlistProvider>(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Slightly less rounded for more angular feel
      ),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(4), // Keep small margin for grid spacing
      child: InkWell(
        onTap: () {
          // TODO: Navigate to Product Detail Screen
          print('Tapped on ${product.name}');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Image section with favorite icon - takes less relative height
            Expanded(
              flex: 3, // Image now takes 3 parts of available flex space (compared to total 4 for content)
              child: Stack(
                children: [
                  Positioned.fill(
                    child: FadeInImage(
                      placeholder: const AssetImage('assets/placeholder.png'),
                      image: NetworkImage(product.imageUrl),
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          alignment: Alignment.center,
                          child: Icon(Icons.image_not_supported, color: Colors.grey[400], size: 25), // Even smaller icon
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 4, // Reduced padding
                    right: 4, // Reduced padding
                    child: Consumer<WishlistProvider>(
                      builder: (ctx, wishlist, child) => IconButton(
                        icon: Icon(
                          wishlist.isProductFavorite(product.id) ? Icons.favorite : Icons.favorite_border,
                          color: wishlist.isProductFavorite(product.id) ? Colors.redAccent : Colors.white,
                          size: 16, // Very small icon size
                        ),
                        onPressed: () {
                          wishlist.toggleFavoriteStatus(product);
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.4),
                          padding: EdgeInsets.all(3), // Minimized padding
                          minimumSize: const Size(24, 24), // Minimized button size
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15), // Circular button
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Product details section - very compact
            Padding(
              padding: const EdgeInsets.fromLTRB(6.0, 3.0, 6.0, 0), // Reduced vertical padding further
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 10, // Even smaller font for name
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    maxLines: 1, // Crucially, limit to 1 line to save vertical space
                    overflow: TextOverflow.ellipsis,
                  ),
                  // const SizedBox(height: 1), // Minimal spacing, consider removing if too tight
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 12, // Smaller font for price
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            // Add to cart button at the bottom - takes remaining flex space
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: Icon(Icons.add_shopping_cart, size: 18, color: Theme.of(context).colorScheme.secondary), // Smaller icon
                onPressed: () {
                  cart.addCartItem(product);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Added ${product.name} to cart!',
                        textAlign: TextAlign.center,
                      ),
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        },
                      ),
                    ),
                  );
                },
                padding: const EdgeInsets.all(4), // Adjusted padding
                splashRadius: 18, // Smaller splash radius
              ),
            ),
          ],
        ),
      ),
    );
  }
}