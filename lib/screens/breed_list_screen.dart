import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'categories_screen.dart';
import '../widgets/gradient_background.dart';

class BreedListScreen extends StatefulWidget {
  final Category category;

  const BreedListScreen({
    super.key,
    required this.category,
  });

  @override
  State<BreedListScreen> createState() => _BreedListScreenState();
}

class _BreedListScreenState extends State<BreedListScreen> {
  final Map<String, Map<String, int>> _selectedQuantities = {};

  void _updateQuantity(Pet breed, String type, int delta) {
    setState(() {
      _selectedQuantities.putIfAbsent(breed.breed, () => {'male': 0, 'female': 0, 'pair': 0});
      final currentQuantity = _selectedQuantities[breed.breed]![type]!;
      final maxAvailable = type == 'male'
          ? breed.availableMale
          : type == 'female'
              ? breed.availableFemale
              : breed.availablePairs;
      
      final newQuantity = currentQuantity + delta;
      if (newQuantity >= 0 && newQuantity <= maxAvailable) {
        _selectedQuantities[breed.breed]![type] = newQuantity;
      }
    });
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('${widget.category.title} Breeds'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        backgroundImageUrl: 'https://images.unsplash.com/photo-1517423440428-a5a00ad493e8?w=1200&q=80&auto=format&fit=crop',
        imageOnly: true,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: widget.category.breeds.length,
          itemBuilder: (context, index) {
            final breed = widget.category.breeds[index];
            final quantities = _selectedQuantities[breed.breed] ?? {'male': 0, 'female': 0, 'pair': 0};
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.blue.shade50,
                    ],
                  ),
                ),
                child: ExpansionTile(
                  title: Text(
                    breed.breed,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildPurchaseRow('Male', breed, 'male', breed.priceMale, breed.availableMale, quantities['male']!),
                          const SizedBox(height: 12),
                          _buildPurchaseRow('Female', breed, 'female', breed.priceFemale, breed.availableFemale, quantities['female']!),
                          const SizedBox(height: 12),
                          _buildPurchaseRow('Pair', breed, 'pair', breed.pricePair, breed.availablePairs, quantities['pair']!),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _addToCart(breed),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(40),
                            ),
                            child: const Text('Add to Cart'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }


  Future<void> _addToCart(Pet breed) async {
    final quantities = _selectedQuantities[breed.breed] ?? {'male': 0, 'female': 0, 'pair': 0};
    if (quantities.values.every((q) => q == 0)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select quantity before adding to cart')));
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final cart = prefs.getStringList('cart') ?? [];

    final item = {
      'category': widget.category.title,
      'breed': breed.breed,
      'priceMale': breed.priceMale,
      'priceFemale': breed.priceFemale,
      'pricePair': breed.pricePair,
      'quantities': quantities,
    };

    cart.add(jsonEncode(item));
    await prefs.setStringList('cart', cart);

    // reset selected quantities for this breed
    setState(() {
      _selectedQuantities[breed.breed] = {'male': 0, 'female': 0, 'pair': 0};
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart')));
  }
  Widget _buildPurchaseRow(String type, Pet breed, String key, double price, int available, int quantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type,
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                '₹${price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () => _updateQuantity(breed, key, -1),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  quantity.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _updateQuantity(breed, key, 1),
              ),
              const SizedBox(width: 8),
              Text(
                '($available left)',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}