import 'package:flutter/material.dart';
import '../models/product.dart';

class BigProductCard extends StatelessWidget {
  final Product product;

  const BigProductCard({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            Positioned.fill(
              child: FadeInImage(
                placeholder: const AssetImage('assets/images/placeholder.png'),
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child: Icon(Icons.image_not_supported, color: Colors.grey[400], size: 80),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Crucial: Makes the column take only necessary space
                children: [
                  // Product Name
                  Flexible( // Use Flexible to prevent overflow
                    child: Text(
                      product.name,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white, fontSize: 24),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Product Description
                  Flexible( // Use Flexible
                    child: Text(
                      product.description,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white70),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Product Price
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.secondary, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Shop Now Button
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement "Shop Now" action
                      print('Shop Now for ${product.name}');
                    },
                    icon: const Icon(Icons.shopping_bag_outlined),
                    label: const Text('Shop Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(fontSize: 14),
                      minimumSize: Size.zero, // Make button size minimal to prevent overflow
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Shrink tap area
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}