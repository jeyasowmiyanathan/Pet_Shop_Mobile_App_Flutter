import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/gradient_background.dart';
import 'dart:convert';
import '../models/purchase.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  List<Purchase> _purchases = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPurchases();
  }

  Future<void> _loadPurchases() async {
    final prefs = await SharedPreferences.getInstance();
    final purchasesJson = prefs.getStringList('purchases') ?? [];
    
    setState(() {
      _purchases = purchasesJson
          .map((json) => Purchase.fromJson(jsonDecode(json)))
          .toList()
        ..sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF6dd5ed), Color(0xFF2193b0)],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase History'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        backgroundImageUrl: 'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?w=1200&q=80&auto=format&fit=crop',
        imageOnly: true,
        child: SafeArea(
          child: _purchases.isEmpty
              ? const Center(
                  child: Text('No purchases yet'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _purchases.length,
                  itemBuilder: (context, index) {
                    final purchase = _purchases[index];
                    return Card(
                      child: ListTile(
                        title: Text('${purchase.breed} (${purchase.category})'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Customer: ${purchase.userName}'),
                            Text('Type: ${purchase.type}'),
                            Text('Quantity: ${purchase.quantity}'),
                            Text('Total: ₹${purchase.totalPrice.toStringAsFixed(2)}'),
                            Text('Date: ${_formatDate(purchase.purchaseDate)}'),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}