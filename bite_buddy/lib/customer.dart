import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class Customer extends StatefulWidget {
  const Customer({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  State<Customer> createState() => _CustomerState();
}

class MenuItem {
  final String name;
  final String image;
  final double price;

  MenuItem({required this.name, required this.image, required this.price});
}

class _CustomerState extends State<Customer> {
  // List menuItems = [];

  final List<MenuItem> menuItems = [
    MenuItem(name: 'Hamburger', image: 'assets/hamburger.jpg', price: 10.99),
    MenuItem(name: 'Pizza', image: 'assets/pizza.jpg', price: 12.99),
    MenuItem(name: 'Sushi', image: 'assets/sushi.jpg', price: 15.99),
  ];

  // final newMenuItems = <String>[];

  // getData();
  @override
  Widget build(BuildContext context) {
    // print("MY BULLSHIT : " + menuItems.toString());
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Remove padding
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Customer'),
              accountEmail: Text('${widget.email}'),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.network(
                    'https://as1.ftcdn.net/v2/jpg/00/64/67/80/1000_F_64678017_zUpiZFjj04cnLri7oADnyMH0XBYyQghG.jpg',
                    fit: BoxFit.cover,
                    width: 90,
                    height: 90,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        'https://media1.ledevoir.com/images_galerie/nwl_1475198_1130846/image.jpg')),
              ),
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Favorites'),
              onTap: () => null,
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Friends'),
              onTap: () => null,
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share'),
              onTap: () => null,
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Request'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => null,
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: Text('Policies'),
              onTap: () => null,
            ),
            Divider(),
            ListTile(
              title: Text('Logout'),
              leading: Icon(Icons.logout),
              onTap: () => logout(context),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.redAccent.shade100,
        title: Text("Customer"),
      ),
      body: FutureBuilder<void>(
        future: getData(),
        builder: (context, snapshot) {
          return GridView.count(
            crossAxisCount: 2,
            children: List.generate(menuItems.length, (index) {
              return Card(
                child: Column(
                  children: [
                    // Image.asset(
                    //   menuItems[index].image,
                    //   fit: BoxFit.cover,
                    // ),
                    Image.network(
                      menuItems[index].image,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 10),
                    Text(
                      menuItems[index].name,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text('\$${menuItems[index].price.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            }),
          );
        }
      )
    );
  }

  // CollectionReference _collectionRef = FirebaseFirestore.instance.collection('users');

  Future<void> getData() async {
    CollectionReference _collectionRef2 =
        FirebaseFirestore.instance.collection('menu');

    // QuerySnapshot querySnapshot = await _collectionRef.get();
    // final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

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

      menuItems.add(new MenuItem(name: name, image: imageUrl, price: double.parse(price)));
    }

    // menuItems.forEach((k,v) => print("got key $k with $v"));
  }

  Future<void> logout(BuildContext context) async {
    CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}
