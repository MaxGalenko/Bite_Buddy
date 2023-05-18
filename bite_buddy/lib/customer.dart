import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login.dart';
import 'order.dart';
import 'customer_nav_bar.dart';

class Customer extends StatefulWidget {
  const Customer({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  // List menuItems = [];
  final TextEditingController itemQuantityController = new TextEditingController(text: "1");
 late CustomerOrder customerOrder;

  void resetItemQuantityController() {
    itemQuantityController.text = "1";
  }

  final List<MenuItem> menuItems = [];
  bool ranGetData = false;


  void showItemDetails(BuildContext context, MenuItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            item.name,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                item.image,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 5),
              Text(
                '\$${item.price.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 22),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    customerOrder = CustomerOrder(userEmail: widget.email, cartItems: []);

  }

  @override
  Widget build(BuildContext context) {

    void addToCart(MenuItem menuItem, int quantity) {
      final cartItem = CartItem(
          name: menuItem.name,
          price: menuItem.price,
          image: menuItem.image,
          quantity: quantity);
      setState(() {
        print("added ${cartItem}");
        customerOrder.addCartItem(cartItem);
        print("cart: ${customerOrder.cartItems.length} ${customerOrder.cartItems[customerOrder.cartItems.length - 1].name}");
      });
      Navigator.pop(context); // close the dialog
      print("cart: ${customerOrder.cartItems.length} ${customerOrder.cartItems[customerOrder.cartItems.length - 1].name}");
      print("aa");
    }

    CustomerOrder getCustomerOrder(){
      print("sent him: ${customerOrder.cartItems.length}"); // ${customerOrder.cartItems[customerOrder.cartItems.length - 1].name}
      return customerOrder;
    }

    void showQuantityDialog(BuildContext context, MenuItem item) {
      int quantity = 1;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enter Quantity'),
            content: TextFormField(
              controller: itemQuantityController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                quantity = int.tryParse(value) ?? 1;
                if (quantity > CustomerOrder.maxAllowedItems) {
                  quantity = CustomerOrder.maxAllowedItems;
                  itemQuantityController.text = CustomerOrder.maxAllowedItems.toString();
                }
              },
              decoration: InputDecoration(hintText: 'Quantity'),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: Text('Add to Cart'),
                onPressed: () {
                  addToCart(item, quantity);
                  resetItemQuantityController();
                },
              ),
            ],
          );
        },
      );
    }


    Widget buildMenuItem(BuildContext context, int index) {
      return GestureDetector(
        onTap: () {
          showQuantityDialog(context, menuItems[index]);
        },
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Image.asset(
                  menuItems[index].image,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      menuItems[index].name,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '\$${menuItems[index].price.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // print("MY BULLSHIT : " + menuItems.toString());
    return Scaffold(
        drawer: NavBar(email: widget.email),
        appBar: AppBar(
          backgroundColor: Colors.redAccent.shade100,
          title: Text("Customer"),
        ),
        body: FutureBuilder<void>(
                future: getData(),
                builder: (context, snapshot) {
                  return GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        ((MediaQuery.of(context).size.height / 4) * 2.6),
                    children: List.generate(menuItems.length, (index) {
                      return GestureDetector(
                        onTap: () => showItemDetails(context, menuItems[index]),
                        child: Card(
                          child: Column(
                            children: [
                              Card(
                                child: Image.network(
                                  menuItems[index].image,
                                  fit: BoxFit.cover,
                                  height: 150,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                menuItems[index].name,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '\$${menuItems[index].price.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  showQuantityDialog(context, menuItems[index]);
                                },
                                child: Text('Add to Cart'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    ),
                  );
                }
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderPage(order: getCustomerOrder(),)),
        ),
        tooltip: 'View Cart',
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }

  // CollectionReference _collectionRef = FirebaseFirestore.instance.collection('users');

  Future<void> getData() async {
    if (ranGetData) {
      return;
    }
    ranGetData = true;
    CollectionReference _collectionRef2 =
        FirebaseFirestore.instance.collection('menu');

    QuerySnapshot aa = await _collectionRef2.get();
    final restOfItems = aa.docs.map((doc) => doc.data()).toList();

    for (var item in restOfItems) {
      String aStr = item.toString();

      print("ITEM: ${aStr}");

      String itemNameString = "itemName: ";
      String itemPriceString = "price: ";
      String imageUrlString = "imageUrl: ";

      String name = aStr.substring(
          aStr.indexOf(itemNameString) + itemNameString.length,
          aStr.indexOf(",", aStr.indexOf(itemNameString)));
      // print("item name : " + name);

      String price = aStr.substring(
          aStr.indexOf(itemPriceString) + itemPriceString.length,
          aStr.indexOf(",", aStr.indexOf(itemPriceString)));

      String imageUrl = aStr.substring(
          aStr.indexOf(imageUrlString) + imageUrlString.length,
          aStr.indexOf(",", aStr.indexOf(imageUrlString)));
      // print("item price : " + price);

      menuItems.add(new MenuItem(
          name: name, image: imageUrl, price: double.parse(price)));
    }

    // menuItems.forEach((k,v) => print("got key $k with $v"));
  }
}
