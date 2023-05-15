import 'package:flutter/material.dart';

class MenuItem {
  final String name;
  final String image;
  final double price;

  MenuItem({required this.name, required this.image, required this.price});
}

class CartItem extends MenuItem {
  final int quantity;

  CartItem(
      {required String name,
        required String image,
        required double price,
        required int this.quantity})
      : super(name: name, image: image, price: price);
}


class CustomerOrder {
  static final CustomerOrder _instance = CustomerOrder._internal();
  List<CartItem> _cartItems = [];

  factory CustomerOrder() {
    return _instance;
  }

  CustomerOrder._internal();

  List<CartItem> get cartItems => _cartItems;

  void addCartItem(CartItem item) {
    _cartItems.add(item);
  }

  void removeCartItem(CartItem item) {
    _cartItems.remove(item);
  }
}

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final order = CustomerOrder();

    double getTotalPrice() {
      double totalPrice = 0.0;

      for(CartItem item in order.cartItems) {
        totalPrice += item.price;
      }

      return totalPrice;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary'),
      ),
      body: ListView.builder(
        itemCount: order.cartItems.length,
        itemBuilder: (BuildContext context, int index) {
          final item = order.cartItems[index];
          return ListTile(
            leading: Image.network(item.image),
            title: Text(item.name),
            subtitle: Text('Price: \$${item.price.toStringAsFixed(2)} x ${item.quantity}'),
            trailing: Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            // Handle the pay button press
            print('Pay button pressed!');
          },
          child: Text(
            'Pay \$${getTotalPrice().toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}