class Purchase {
  final String userId;
  final String userName;
  final String category;
  final String breed;
  final String type; // male, female, or pair
  final int quantity;
  final double totalPrice;
  final DateTime purchaseDate;

  Purchase({
    required this.userId,
    required this.userName,
    required this.category,
    required this.breed,
    required this.type,
    required this.quantity,
    required this.totalPrice,
    required this.purchaseDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'category': category,
      'breed': breed,
      'type': type,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'purchaseDate': purchaseDate.toIso8601String(),
    };
  }

  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      userId: json['userId'],
      userName: json['userName'],
      category: json['category'],
      breed: json['breed'],
      type: json['type'],
      quantity: json['quantity'],
      totalPrice: json['totalPrice'],
      purchaseDate: DateTime.parse(json['purchaseDate']),
    );
  }
}