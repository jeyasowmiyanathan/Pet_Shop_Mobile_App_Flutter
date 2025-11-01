import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/purchase.dart';
import '../widgets/gradient_background.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  late Future<void> _loadFuture;
  List<Map<String, String>> _registeredUsers = []; // {email, name}
  List<Purchase> _purchases = [];

  @override
  void initState() {
    super.initState();
    _loadFuture = _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    final users = <Map<String, String>>[];
    for (final k in keys) {
      if (k.startsWith('user_')) {
        final email = k.substring(5);
        final name = prefs.getString('name_$email') ?? email;
        users.add({'email': email, 'name': name});
      }
    }

    final purchasesJson = prefs.getStringList('purchases') ?? [];
    final purchases = purchasesJson
        .map((s) => Purchase.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();

    setState(() {
      _registeredUsers = users;
      _purchases = purchases;
    });
  }

  List<Purchase> _purchasesForUser(String email, String name) {
    return _purchases.where((p) {
      if (p.userId.isNotEmpty && p.userId == email) return true;
      if (p.userName.isNotEmpty && p.userName == name) return true;
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registered Users'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        backgroundImageUrl: 'https://images.unsplash.com/photo-1546182990-dffeafbe841d?w=1200&q=80&auto=format&fit=crop',
        imageOnly: true,
        child: SafeArea(
          child: FutureBuilder<void>(
            future: _loadFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              }

              if (_registeredUsers.isEmpty) {
                return const Center(
                  child: Text('No registered users', style: TextStyle(color: Colors.white)),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _registeredUsers.length,
                itemBuilder: (context, index) {
                  final user = _registeredUsers[index];
                  final email = user['email']!;
                  final name = user['name']!;
                  final purchases = _purchasesForUser(email, name);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ExpansionTile(
                      title: Text(name),
                      subtitle: Text(email),
                      children: purchases.isEmpty
                          ? [const Padding(padding: EdgeInsets.all(12), child: Text('No purchases'))]
                          : purchases.map((p) {
                              return ListTile(
                                title: Text('${p.breed} (${p.category})'),
                                subtitle: Text('${p.type} • Qty: ${p.quantity} • ₹${p.totalPrice.toStringAsFixed(2)}'),
                                trailing: Text(_formatDate(p.purchaseDate)),
                              );
                            }).toList(),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
