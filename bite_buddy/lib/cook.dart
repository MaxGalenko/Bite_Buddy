import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'cook_nav_bar.dart';
import 'order.dart';

class OrderItem {
  final int table;
  final int id;

  OrderItem({required this.table, required this.id});
}

class Order {
  static final Order _instance = Order._internal();
  static const int maxAllowedOrders = 10;
  List<OrderItem> _orderItems = [];

  factory Order() {
    return _instance;
  }

  Order._internal();

  List<OrderItem> get orderItems => _orderItems;
}

class Cook extends StatefulWidget {
  Cook({Key? key, required this.email}) : super(key: key);
  final String email;
  var order = Order();

  @override
  State<Cook> createState() => _CookState();
}

class _CookState extends State<Cook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(email: widget.email,),
      appBar: AppBar(
        backgroundColor: Colors.redAccent.shade100,
        title: Text("Cook"),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 40),
            Container(
              margin: const EdgeInsets.only(left: 30),
              child: Row(
                children: [
                  Text('Table', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                  Text('    |    Order', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                  Text('    |    Status', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                OrderItem item = widget.order.orderItems[index];
                return ListTile(
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Table #', ),
                      Text('    |    Order #', ),
                      Text('    |    Ready', ),
                      ElevatedButton(
                        child: Text('Call Waiter'),
                        onPressed: () {
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}