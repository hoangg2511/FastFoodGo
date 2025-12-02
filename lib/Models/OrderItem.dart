class OrderItem {
  final String id;
  final String restaurantName;
  final String imageUrl;
  final List<String> items;
  final double price;
  final double rating;
  final String date;
  final String status;

  OrderItem({
    required this.id,
    required this.restaurantName,
    required this.imageUrl,
    required this.items,
    required this.price,
    required this.rating,
    required this.date,
    required this.status,
  });

  // Convert từ JSON sang Model
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      restaurantName: json['restaurantName'],
      imageUrl: json['imageUrl'],
      items: List<String>.from(json['items']),
      price: json['price'].toDouble(),
      rating: json['rating'].toDouble(),
      date: json['date'],
      status: json['status'],
    );
  }

  // Convert từ Model sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurantName': restaurantName,
      'imageUrl': imageUrl,
      'items': items,
      'price': price,
      'rating': rating,
      'date': date,
      'status': status,
    };
  }
}
