import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../widgets/cart_item_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Column(
      children: <Widget>[
        Card(
          margin: const EdgeInsets.all(15),
          child: Padding(
            padding: const EdgeInsets.all(15), // Increased padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total',
                  style: Theme.of(context).textTheme.titleLarge, // Use theme text style
                ),
                const Spacer(),
                Chip(
                  label: Text(
                    '\$${cart.totalAmount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary, // Text color for primary chip
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                TextButton(
                  onPressed: () {
                    if (cart.totalAmount <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Your cart is empty! Add items first.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }
                    cart.clearCart();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Order Placed! (Simulated)'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor, // Use primary color for text button
                  ),
                  child: Text(
                    'ORDER NOW',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: cart.itemCount == 0
              ? Center(
                  child: Text(
                    'Your shopping cart is empty!',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: cart.itemCount,
                  itemBuilder: (ctx, i) {
                    final cartItem = cart.items.values.toList()[i];
                    return CartItemCard(
                      id: cartItem.id,
                      productId: cart.items.keys.toList()[i],
                      name: cartItem.name,
                      quantity: cartItem.quantity,
                      price: cartItem.price,
                    );
                  },
                ),
        )
      ],
    );
  }
}