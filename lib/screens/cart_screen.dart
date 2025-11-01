import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/purchase.dart';
import 'home_screen.dart';
import '../widgets/gradient_background.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> _cart = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final items = prefs.getStringList('cart') ?? [];
    setState(() {
      _cart = items.map((s) => jsonDecode(s) as Map<String, dynamic>).toList();
      _loading = false;
    });
  }

  Future<void> _removeAt(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final items = prefs.getStringList('cart') ?? [];
    items.removeAt(index);
    await prefs.setStringList('cart', items);
    await _loadCart();
  }

  double _itemTotal(Map<String, dynamic> item) {
    return (item['quantities'] as Map).entries.fold<double>(0.0, (sum, e) {
      final key = e.key as String;
      final qty = (e.value as num).toDouble();
      final priceKey = key == 'male' ? 'priceMale' : key == 'female' ? 'priceFemale' : 'pricePair';
      final price = (item[priceKey] as num).toDouble();
      return sum + qty * price;
    });
  }

  Future<void> _confirmPurchase() async {
    if (_cart.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final userData = jsonDecode(prefs.getString('currentUser') ?? '{}');
    if (userData['id'] == null || userData['id'] == '') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please login before confirming purchase')));
      return;
    }

    // Show summary dialog
    final total = _cart.fold<double>(0.0, (s, item) => s + _itemTotal(item));
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Purchase'),
        content: Text('Total payable: ₹${total.toStringAsFixed(2)}\nProceed to confirm?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Confirm')),
        ],
      ),
    );

    if (confirm != true) return;

    // Convert cart items to Purchase entries
    final purchases = prefs.getStringList('purchases') ?? [];
    for (final item in _cart) {
      final quantities = Map<String, int>.from(item['quantities'] as Map);
      final itemTotal = _itemTotal(item);
      final purchase = Purchase(
        userId: userData['id'] ?? '',
        userName: userData['name'] ?? 'Unknown',
        category: item['category'] ?? '',
        breed: item['breed'] ?? '',
        type: quantities.entries.where((e) => e.value > 0).map((e) => '${e.value} ${e.key}').join(', '),
        quantity: quantities.values.fold(0, (a, b) => a + b),
        totalPrice: itemTotal,
        purchaseDate: DateTime.now(),
      );
      purchases.add(jsonEncode(purchase.toJson()));
    }

    await prefs.setStringList('purchases', purchases);
    await prefs.remove('cart');

    if (mounted) {
      // Navigate to home and clear stack
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const HomeScreen()), (r) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: const Text('Cart'), backgroundColor: Colors.transparent, elevation: 0, foregroundColor: Colors.white),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        backgroundImageUrl: 'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?w=1200&q=80&auto=format&fit=crop',
        imageOnly: true,
        child: SafeArea(
          child: _cart.isEmpty
              ? const Center(child: Text('Your cart is empty', style: TextStyle(color: Colors.white)))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _cart.length,
                  itemBuilder: (context, index) {
                    final item = _cart[index];
                    final qtyMap = Map<String, dynamic>.from(item['quantities'] as Map);
                    return Card(
                      child: ListTile(
                        title: Text('${item['breed']} (${item['category']})'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(qtyMap.entries.where((e) => e.value > 0).map((e) => '${e.value} ${e.key}').join(', ')),
                            Text('Total: ₹${_itemTotal(item).toStringAsFixed(2)}'),
                          ],
                        ),
                        trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => _removeAt(index)),
                      ),
                    );
                  },
                ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          onPressed: _cart.isEmpty ? null : _confirmPurchase,
          child: Text('Confirm Purchase (${_cart.fold<int>(0, (s, i) => s + (i['quantities'] as Map).values.fold<int>(0, (a, b) => a + (b as int)))})'),
        ),
      ),
    );
  }
}
