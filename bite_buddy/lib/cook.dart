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

// class Order {
//   static final Order _instance = Order._internal();
//   static const int maxAllowedOrders = 10;
//   List<OrderItem> _orderItems = [];
//
//   factory Order() {
//     return _instance;
//   }
//
//   Order._internal();
//
//   List<OrderItem> get orderItems => _orderItems;
// }

class Cook extends StatefulWidget {
  Cook({Key? key, required this.email}) : super(key: key);
  final String email;
  // var order = Order();
  List<CustomerOrder> ordersList = CustomerOrder.allOrders;

  @override
  State<Cook> createState() => _CookState();
}

class _CookState extends State<Cook> {
  @override
  Widget build(BuildContext context) {
    void showOrderDetails(BuildContext context, List<CartItem> itemsList) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              itemsList[0].name,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: ListView.builder(
          itemCount: itemsList.length,
              itemBuilder: (BuildContext context, int index) {
                CartItem item = itemsList[index];
                return ListTile(
                  leading: Image.network(item.image),
                  title: Text(item.name),
                  subtitle: Text(
                      'Price: \$${item.price.toStringAsFixed(2)} x ${item.quantity}'),
                  trailing: Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
                );
              },
          ),
            ),
            // content: Column(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     Image.network(
            //       item.image,
            //       fit: BoxFit.cover,
            //     ),
            //     SizedBox(height: 5),
            //     Text(
            //       '\$${item.price.toStringAsFixed(2)}',
            //       style: TextStyle(fontSize: 22),
            //     ),
            //   ],
            // ),
            // actions: <Widget>[
            //   ElevatedButton(
            //     child: Text('Close'),
            //     onPressed: () {
            //       Navigator.of(context).pop();
            //     },
            //   ),
            // ],
          );
        },
      );
    }

    // Widget buildMenuItem(BuildContext context, int index) {
    //   return GestureDetector(
    //     onTap: () {
    //       showQuantityDialog(context, menuItems[index]);
    //     },
    //     child: Card(
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.stretch,
    //         children: [
    //           Expanded(
    //             child: Image.asset(
    //               menuItems[index].image,
    //               fit: BoxFit.cover,
    //             ),
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(
    //                   menuItems[index].name,
    //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    //                 ),
    //                 SizedBox(height: 5),
    //                 Text(
    //                   '\$${menuItems[index].price.toStringAsFixed(2)}',
    //                   style: TextStyle(fontSize: 16),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    // }

    print("len of shit: ${widget.ordersList.length}");
    // print(widget.ordersList[0].userEmail);
    // print("item count: ${widget.ordersList[0].cartItems.length}");

    return Scaffold(
      drawer: NavBar(email: widget.email,),
      appBar: AppBar(
        backgroundColor: Colors.redAccent.shade100,
        title: Text("Cook"),
      ),
      body: FutureBuilder<void>(
        builder: (context, snapshot) {
          return GridView.count(

          crossAxisCount: 1,
          childAspectRatio: MediaQuery.of(context).size.width /
            ((MediaQuery.of(context).size.height / 4) * 0.3),
            children: List.generate(widget.ordersList.length, (index) {

              CustomerOrder customerOrder = widget.ordersList[index];

          return GestureDetector(
            onTap: () => showOrderDetails(context, customerOrder.cartItems),
            child: Card(
              child: Row(
                children: [
                  Text("User: ${customerOrder.userEmail}"),
                  SizedBox(
                    width: 50,
                  ),
                  Text("Status: ${customerOrder.status}"),
                  // Expanded(
                  //   child: Image.asset(
                  //     customerOrder.cartItems[index].image,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  // SizedBox(height: 10),
                  // Text(
                  //   customerOrder.cartItems[index].name,
                  //   style: TextStyle(
                  //       fontSize: 20, fontWeight: FontWeight.bold),
                  // ),
                  // SizedBox(height: 5),
                  // Text(
                  //   '\$${customerOrder.cartItems[index].price.toStringAsFixed(2)} x ${customerOrder.cartItems[index].quantity}',
                  //   style: TextStyle(fontSize: 16),
                  // ),
                ],
              ),
            ),
          );}));
        },
      ),
    );


    // return Scaffold(
    //   drawer: NavBar(email: widget.email,),
    //   appBar: AppBar(
    //     backgroundColor: Colors.redAccent.shade100,
    //     title: Text("Cook"),
    //   ),
    //   body: SingleChildScrollView(
    //     physics: ScrollPhysics(),
    //     child: Column(
    //       children: [
    //         // SizedBox(height: 40),
    //         // Container(
    //         //   margin: const EdgeInsets.only(left: 30),
    //         //   child: Row(
    //         //     children: [
    //         //       Text('Table', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
    //         //       Text('    |    Order', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
    //         //       Text('    |    Status', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
    //         //     ],
    //         //   ),
    //         // ),
    //         SizedBox(
    //           height: 200,
    //           child: ListView.builder(
    //             physics: NeverScrollableScrollPhysics(),
    //             shrinkWrap: true,
    //             itemCount: widget.ordersList.length,
    //             itemBuilder: (BuildContext context, int index) {
    //               // OrderItem item = widget.order.orderItems[index];
    //               CustomerOrder customerOrder = widget.ordersList[index];
    //               return SizedBox(
    //                 height: 100,
    //                 child: ListTile(
    //                   trailing: Row(
    //                     // mainAxisAlignment: MainAxisSize.min,
    //                     children: [
    //                       Text("asdas"),
    //                     ],
    //                   ),
    //                 ),
    //               );
    //
    //               // return ListView.builder(
    //               //     itemCount: customerOrder.cartItems.length,
    //               //     itemBuilder: (BuildContext context, int fIndex) {
    //               //       CartItem item = customerOrder.cartItems[fIndex];
    //               //
    //               //       return Column(
    //               //         children: [
    //               //           Text(customerOrder.userEmail),
    //               //           Flexible(
    //               //             child: ListTile(
    //               //               trailing: Row(
    //               //               mainAxisSize: MainAxisSize.min,
    //               //                 children: [
    //               //                   Column(
    //               //                     children: [
    //               //                       Image.network(item.image),
    //               //                       Text(item.name),
    //               //                     ],
    //               //                   ),
    //               //                   Text("x ${item.quantity}"),
    //               //                 ],
    //               //               ),
    //               //             ),
    //               //           ),
    //               //           Text(customerOrder.status)
    //               //         ],
    //               //       );
    //               //     },
    //               // );
    //
    //               // return ListTile(
    //               //   trailing: Row(
    //               //     mainAxisSize: MainAxisSize.min,
    //               //     children: [
    //               //       Text('Table #', ),
    //               //       Text('    |    Order #', ),
    //               //       Text('    |    Ready', ),
    //               //       ElevatedButton(
    //               //         child: Text('Call Waiter'),
    //               //         onPressed: () {
    //               //           setState(() {});
    //               //         },
    //               //       ),
    //               //     ],
    //               //   ),
    //               // );
    //             },
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}