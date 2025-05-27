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
      elevation: 1, // Slightly reduced elevation for a flatter, modern look
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Consistent smaller radius
      ),
      clipBehavior: Clip.antiAlias, // Ensures content respects card's rounded corners
      margin: const EdgeInsets.all(0), // Removed default margin to give full control to GridView
      child: InkWell(
        onTap: () {
          // TODO: Navigate to Product Detail Screen
          print('Tapped on ${product.name}');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Image section with favorite icon
            Expanded(
              child: Stack(
                children: [
                  FadeInImage(
                    placeholder: const AssetImage('assets/placeholder.png'),
                    image: NetworkImage(product.imageUrl),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        alignment: Alignment.center,
                        child: Icon(Icons.image_not_supported, color: Colors.grey[400], size: 40), // Smaller icon for 3x3 grid
                      );
                    },
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Consumer<WishlistProvider>(
                      builder: (ctx, wishlist, child) => IconButton(
                        icon: Icon(
                          wishlist.isProductFavorite(product.id) ? Icons.favorite : Icons.favorite_border,
                          color: wishlist.isProductFavorite(product.id) ? Colors.red : Colors.white, // White icon for better contrast
                          size: 20, // Smaller icon size for 3x3 grid
                        ),
                        onPressed: () {
                          wishlist.toggleFavoriteStatus(product);
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.3), // Slightly transparent background
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(32, 32), // Smaller button touch target
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Product details section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0), // Reduced padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 12, // Smaller font size for 3x3 grid
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    maxLines: 2, // Allow up to two lines for the name
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2), // Very compact spacing
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14, // Slightly smaller font size for price
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(), // Pushes the add-to-cart button to the bottom
            // Add to cart button at the bottom
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: Icon(Icons.add_shopping_cart, size: 20, color: Theme.of(context).colorScheme.secondary), // Smaller icon
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
                padding: const EdgeInsets.all(4), // Compact padding for icon button
                splashRadius: 20, // Smaller splash radius
              ),
            ),
          ],
        ),
      ),
    );
  }
}