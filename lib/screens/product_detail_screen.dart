import 'package:flutter/material.dart';
import '../models/product.dart'; // Make sure this path is correct
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Extract the product ID passed through the route arguments
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    // For now, we'll assume a dummy product.
    // In a real app, you would fetch the product from a provider based on the ID.
    // For demonstration, let's create a dummy product or find it from a list if you have one.

    // --- IMPORTANT: Replace this with actual product fetching ---
    // Example: If you have a ProductsProvider, you'd do:
    // final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    // final loadedProduct = productsProvider.findById(productId);
    // For now, using a simple dummy product for illustration:
    final Product loadedProduct = Product(
      id: productId,
      name: 'Example Product Name',
      description: 'This is a detailed description of the example product. '
                   'It highlights all the great features and benefits. '
                   'You can add more text here to see how it wraps.',
      price: 29.99,
      imageUrl: 'https://via.placeholder.com/400x300/0000FF/FFFFFF?text=Product+Image', // Blue placeholder
    );
    // --- END IMPORTANT ---

    final cart = Provider.of<CartProvider>(context, listen: false);
    final wishlist = Provider.of<WishlistProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.name),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child: Icon(Icons.image_not_supported, color: Colors.grey[400], size: 60),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loadedProduct.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${loadedProduct.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    loadedProduct.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Add to Cart Button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            cart.addCartItem(loadedProduct);
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Added ${loadedProduct.name} to cart!',
                                  textAlign: TextAlign.center,
                                ),
                                duration: const Duration(seconds: 2),
                                action: SnackBarAction(
                                  label: 'UNDO',
                                  onPressed: () {
                                    cart.removeSingleItem(loadedProduct.id);
                                  },
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.shopping_cart),
                          label: const Text('Add to Cart'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Favorite Button
                      Consumer<WishlistProvider>(
                        builder: (ctx, wishlist, child) => IconButton(
                          icon: Icon(
                            wishlist.isProductFavorite(loadedProduct.id) ? Icons.favorite : Icons.favorite_border,
                            color: wishlist.isProductFavorite(loadedProduct.id) ? Colors.red : Colors.grey,
                            size: 30,
                          ),
                          onPressed: () {
                            wishlist.toggleFavoriteStatus(loadedProduct);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}