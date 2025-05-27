import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../models/product.dart';
import '../providers/product_provider.dart';
import '../widgets/product_item.dart';
import '../widgets/big_product_card.dart';
import '../widgets/small_product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        final productsData = Provider.of<ProductProvider>(context, listen: false);
        final bigSliderProducts = productsData.products.take(3).toList();

        if (bigSliderProducts.isEmpty) return;

        if (_currentPage < bigSliderProducts.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProvider>(context);
    final allProducts = productsData.products;
    final filteredProducts = productsData.getFilteredProducts(_searchQuery);

    final bigSliderProducts = allProducts.take(3).toList();
    final smallSliderProducts = allProducts.skip(3).take(4).toList();

    return ListView(
      children: <Widget>[
        // Search Bar (remains as is)
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search Products',
              hintText: 'e.g., T-Shirt, Shoes',
              prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryColor),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              labelStyle: TextStyle(color: Colors.grey[700]),
              hintStyle: TextStyle(color: Colors.grey[500]),
            ),
            onChanged: _onSearchChanged,
          ),
        ),
        const SizedBox(height: 10),

        // --- Big Slider (Page View) ---
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: bigSliderProducts.length,
            itemBuilder: (ctx, i) {
              return BigProductCard(product: bigSliderProducts[i]);
            },
          ),
        ),
        const SizedBox(height: 15),

        // --- Quick Picks Title ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Quick Picks',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 10),

        // --- Small Slider (Horizontal List View) ---
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: smallSliderProducts.length,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            itemBuilder: (ctx, i) {
              return SmallProductCard(product: smallSliderProducts[i]);
            },
          ),
        ),
        const SizedBox(height: 15),

        // --- Products Grid Title ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Explore More',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 10),

        // --- 3x3 Grid Scrollable ---
        filteredProducts.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    _searchQuery.isEmpty ? 'No products available.' : 'No products found matching "${_searchQuery}".',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : GridView.builder(
                shrinkWrap: true, // Crucial for GridView inside ListView
                physics: const NeverScrollableScrollPhysics(), // Prevents GridView from having its own scroll
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0), // Compact grid padding
                itemCount: filteredProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // CHANGED: Now 3 columns
                  childAspectRatio: 0.45, // ADJUSTED: Significantly smaller for 3 columns (e.g., 0.45 to 0.5)
                  crossAxisSpacing: 8, // Compact spacing between columns
                  mainAxisSpacing: 8, // Compact spacing between rows
                ),
                itemBuilder: (ctx, i) => ProductItem(
                  product: filteredProducts[i],
                ),
              ),
      ],
    );
  }
}