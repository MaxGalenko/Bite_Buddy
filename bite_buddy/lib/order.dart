import 'package:flutter/material.dart';

class MenuItem {
  final String name;
  final String image;
  final double price;

  MenuItem({required this.name, required this.image, required this.price});
}

class CartItem extends MenuItem {
  int quantity;

  CartItem(
      {required String name,
        required String image,
        required double price,
        required int this.quantity})
      : super(name: name, image: image, price: price);
}


class CustomerOrder {
  static const int maxAllowedItems = 15;
  static List<CustomerOrder> _allOrders = [];

  String userEmail;
  List<CartItem> _cartItems = [];

  CustomerOrder({required this.userEmail});


  List<CartItem> get cartItems => _cartItems;

  void addCartItem(CartItem item) {
    _cartItems.add(item);
  }

  void removeCartItem(CartItem item) {
    _cartItems.remove(item);
  }

  static CustomerOrder getCustomerOrder(String inputUserEmail) {
    for(CustomerOrder order in CustomerOrder._allOrders) {
      if (order.userEmail == inputUserEmail) {
        return order;
      }
    }
    return new CustomerOrder(userEmail: inputUserEmail);
  }
}

class OrderPage extends StatefulWidget  {
  var order = CustomerOrder();

  // OrderPage({required this.order});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    // final order = CustomerOrder();
    final int maxAllowedItems = CustomerOrder.maxAllowedItems;

    double getTotalPrice() {
      double subTot = 0.0;

      for(CartItem item in widget.order.cartItems) {
        subTot += item.price * item.quantity;
      }

      return subTot;
    }

    double totalPrice = getTotalPrice();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent.shade100,
        title: Text('Order Summary'),
      ),
      body: ListView.builder(
        itemCount: widget.order.cartItems.length,
        itemBuilder: (BuildContext context, int index) {
          CartItem item = widget.order.cartItems[index];
          return ListTile(
            leading: Image.network(item.image),
            title: Text(item.name),
            subtitle: Text('Price: \$${item.price.toStringAsFixed(2)} x ${item.quantity}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      if (item.quantity < maxAllowedItems) {
                        item.quantity++;
                        getTotalPrice();
                      }
                    });
                  },
                ),
                Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (item.quantity > 0) {
                        item.quantity--;
                        getTotalPrice();
                      }
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
      // body: ListView.builder(
      //   itemCount: order.cartItems.length,
      //   itemBuilder: (BuildContext context, int index) {
      //     final item = order.cartItems[index];
      //     return ListTile(
      //       leading: Image.network(item.image),
      //       title: Text(item.name),
      //       subtitle: Text('Price: \$${item.price.toStringAsFixed(2)} x ${item.quantity}'),
      //       trailing: Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
      //     );
      //   },
      // ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.shade100,),
          onPressed: () {
            // Handle the pay button press
            print('Pay button pressed!');
          },
          child: Text(
            'Pay \$${totalPrice.toStringAsFixed(2)}',
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