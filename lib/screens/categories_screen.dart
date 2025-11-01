import 'package:flutter/material.dart';
import 'breed_list_screen.dart';
import 'purchase_history_screen.dart';
import 'cart_screen.dart';
import '../widgets/gradient_background.dart';

class Pet {
  final String breed;
  final double priceMale;
  final double priceFemale;
  final double pricePair;
  final int availableMale;
  final int availableFemale;
  final int availablePairs;

  const Pet({
    required this.breed,
    required this.priceMale,
    required this.priceFemale,
    required this.pricePair,
    required this.availableMale,
    required this.availableFemale,
    required this.availablePairs,
  });
}

class Category {
  final String title;
  final IconData icon;
  final List<Pet> breeds;

  const Category({
    required this.title,
    required this.icon,
    required this.breeds,
  });
}

class CategoriesScreen extends StatelessWidget {
  final bool isAdmin;

  const CategoriesScreen({super.key, this.isAdmin = false});

  static const List<Category> categories = [
    Category(
      title: 'Cat',
      icon: Icons.pets,
      breeds: [
        Pet(
          breed: 'Persian Cat',
          priceMale: 15000,
          priceFemale: 18000,
          pricePair: 30000,
          availableMale: 5,
          availableFemale: 3,
          availablePairs: 2,
        ),
        Pet(
          breed: 'British Cat',
          priceMale: 20000,
          priceFemale: 22000,
          pricePair: 38000,
          availableMale: 4,
          availableFemale: 4,
          availablePairs: 3,
        ),
        Pet(
          breed: 'Pure White',
          priceMale: 12000,
          priceFemale: 14000,
          pricePair: 24000,
          availableMale: 6,
          availableFemale: 5,
          availablePairs: 4,
        ),
        Pet(
          breed: 'Husky Cat',
          priceMale: 25000,
          priceFemale: 28000,
          pricePair: 48000,
          availableMale: 3,
          availableFemale: 2,
          availablePairs: 2,
        ),
      ],
    ),
    Category(
      title: 'Dog',
      icon: Icons.pets,
      breeds: [
        Pet(
          breed: 'Doberman',
          priceMale: 25000,
          priceFemale: 28000,
          pricePair: 50000,
          availableMale: 3,
          availableFemale: 2,
          availablePairs: 1,
        ),
        Pet(
          breed: 'German Shepherd',
          priceMale: 30000,
          priceFemale: 35000,
          pricePair: 60000,
          availableMale: 4,
          availableFemale: 3,
          availablePairs: 2,
        ),
        Pet(
          breed: 'Rajapalayam',
          priceMale: 15000,
          priceFemale: 18000,
          pricePair: 30000,
          availableMale: 5,
          availableFemale: 4,
          availablePairs: 3,
        ),
        Pet(
          breed: 'Kanni',
          priceMale: 12000,
          priceFemale: 14000,
          pricePair: 24000,
          availableMale: 4,
          availableFemale: 3,
          availablePairs: 2,
        ),
        Pet(
          breed: 'Boxer',
          priceMale: 28000,
          priceFemale: 32000,
          pricePair: 55000,
          availableMale: 3,
          availableFemale: 2,
          availablePairs: 1,
        ),
      ],
    ),
    Category(
      title: 'Fish',
      icon: Icons.pool,
      breeds: [
        Pet(
          breed: 'Golden Fish',
          priceMale: 500,
          priceFemale: 500,
          pricePair: 900,
          availableMale: 20,
          availableFemale: 20,
          availablePairs: 15,
        ),
        Pet(
          breed: 'Tank Cleaner',
          priceMale: 300,
          priceFemale: 300,
          pricePair: 500,
          availableMale: 25,
          availableFemale: 25,
          availablePairs: 20,
        ),
        Pet(
          breed: 'White Molley',
          priceMale: 400,
          priceFemale: 400,
          pricePair: 700,
          availableMale: 15,
          availableFemale: 15,
          availablePairs: 10,
        ),
        Pet(
          breed: 'Guppy',
          priceMale: 200,
          priceFemale: 200,
          pricePair: 350,
          availableMale: 30,
          availableFemale: 30,
          availablePairs: 25,
        ),
        Pet(
          breed: 'Fighter',
          priceMale: 600,
          priceFemale: 600,
          pricePair: 1000,
          availableMale: 10,
          availableFemale: 10,
          availablePairs: 8,
        ),
      ],
    ),
    Category(
      title: 'Love Birds',
      icon: Icons.flight,
      breeds: [
        Pet(
          breed: 'Multicolor Bird',
          priceMale: 2000,
          priceFemale: 2500,
          pricePair: 4000,
          availableMale: 8,
          availableFemale: 6,
          availablePairs: 5,
        ),
        Pet(
          breed: 'White',
          priceMale: 1800,
          priceFemale: 2200,
          pricePair: 3500,
          availableMale: 10,
          availableFemale: 8,
          availablePairs: 6,
        ),
        Pet(
          breed: 'Green and Yellow',
          priceMale: 1500,
          priceFemale: 1800,
          pricePair: 3000,
          availableMale: 12,
          availableFemale: 10,
          availablePairs: 8,
        ),
      ],
    ),
    Category(
      title: 'Sugar Glider',
      icon: Icons.nature_people,
      breeds: [
        Pet(
          breed: 'White',
          priceMale: 8000,
          priceFemale: 10000,
          pricePair: 16000,
          availableMale: 4,
          availableFemale: 3,
          availablePairs: 2,
        ),
        Pet(
          breed: 'Brown',
          priceMale: 7000,
          priceFemale: 9000,
          pricePair: 14000,
          availableMale: 5,
          availableFemale: 4,
          availablePairs: 3,
        ),
      ],
    ),
    Category(
      title: 'Dove',
      icon: Icons.flight_takeoff,
      breeds: [
        Pet(
          breed: 'Wild Dove',
          priceMale: 1000,
          priceFemale: 1200,
          pricePair: 2000,
          availableMale: 15,
          availableFemale: 12,
          availablePairs: 10,
        ),
        Pet(
          breed: 'Adult',
          priceMale: 1500,
          priceFemale: 1800,
          pricePair: 3000,
          availableMale: 10,
          availableFemale: 8,
          availablePairs: 6,
        ),
        Pet(
          breed: 'Semi-Adult',
          priceMale: 1200,
          priceFemale: 1500,
          pricePair: 2500,
          availableMale: 12,
          availableFemale: 10,
          availablePairs: 8,
        ),
      ],
    ),
    Category(
      title: 'Rats',
      icon: Icons.pest_control,
      breeds: [
        Pet(
          breed: 'Brown with White',
          priceMale: 300,
          priceFemale: 400,
          pricePair: 600,
          availableMale: 20,
          availableFemale: 15,
          availablePairs: 12,
        ),
        Pet(
          breed: 'Black with White',
          priceMale: 300,
          priceFemale: 400,
          pricePair: 600,
          availableMale: 18,
          availableFemale: 14,
          availablePairs: 10,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: isAdmin
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
              child: const Icon(Icons.shopping_cart),
            ),
      appBar: AppBar(
        title: const Text('Pet Categories'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PurchaseHistoryScreen(),
                  ),
                );
              },
              tooltip: 'Purchase History',
            ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        // friendly mixed pets photo background
        backgroundImageUrl: 'https://images.unsplash.com/photo-1507149833265-60c372daea22?w=1200&q=80&auto=format&fit=crop',
        imageOnly: true,
        child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final item = categories[index];
            return Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BreedListScreen(category: item),
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.icon, size: 48, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 12),
                    Text(
                      item.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    )));
  }
}
