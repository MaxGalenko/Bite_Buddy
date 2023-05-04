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

class _CustomerState extends State<Customer> {
  List menuItems = [];

  final newMenuItems = <String>[];

  // getData();
  @override
  Widget build(BuildContext context) {
    print("MY BULLSHIT : " + newMenuItems.toString());
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
          return ListView.builder(
            itemCount: newMenuItems.length,
            itemBuilder: (context, index) {
              return Card(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(newMenuItems[index].split(";")[0]),
                        Text(newMenuItems[index].split(";")[1]),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );

    // return Scaffold(
    //   drawer: Drawer(
    //     child: ListView(
    //       // Remove padding
    //       padding: EdgeInsets.zero,
    //       children: [
    //         UserAccountsDrawerHeader(
    //           accountName: Text('Customer'),
    //           accountEmail: Text('${widget.email}'),
    //           currentAccountPicture: CircleAvatar(
    //             child: ClipOval(
    //               child: Image.network(
    //                 'https://as1.ftcdn.net/v2/jpg/00/64/67/80/1000_F_64678017_zUpiZFjj04cnLri7oADnyMH0XBYyQghG.jpg',
    //                 fit: BoxFit.cover,
    //                 width: 90,
    //                 height: 90,
    //               ),
    //             ),
    //           ),
    //           decoration: BoxDecoration(
    //             color: Colors.blue,
    //             image: DecorationImage(
    //                 fit: BoxFit.fill,
    //                 image: NetworkImage(
    //                     'https://media1.ledevoir.com/images_galerie/nwl_1475198_1130846/image.jpg')),
    //           ),
    //         ),
    //         ListTile(
    //           leading: Icon(Icons.favorite),
    //           title: Text('Favorites'),
    //           onTap: () => null,
    //         ),
    //         ListTile(
    //           leading: Icon(Icons.person),
    //           title: Text('Friends'),
    //           onTap: () => null,
    //         ),
    //         ListTile(
    //           leading: Icon(Icons.share),
    //           title: Text('Share'),
    //           onTap: () => null,
    //         ),
    //         ListTile(
    //           leading: Icon(Icons.notifications),
    //           title: Text('Request'),
    //         ),
    //         Divider(),
    //         ListTile(
    //           leading: Icon(Icons.settings),
    //           title: Text('Settings'),
    //           onTap: () => null,
    //         ),
    //         ListTile(
    //           leading: Icon(Icons.description),
    //           title: Text('Policies'),
    //           onTap: () => null,
    //         ),
    //         Divider(),
    //         ListTile(
    //           title: Text('Logout'),
    //           leading: Icon(Icons.logout),
    //           onTap: () => logout(context),
    //         ),
    //       ],
    //     ),
    //   ),
    //   appBar: AppBar(
    //     backgroundColor: Colors.redAccent.shade100,
    //     title: Text("Customer"),
    //   ),
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         Text("Customer"),
    //         ElevatedButton(onPressed: getData, child: Text('suki'))
    //       ],
    //     ),
    //   ),
    // );
  }

  // List<DataRow> _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  //   return  snapshot.map((data) => _buildListItem(context, data)).toList();
  // }\

  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('users');

  Future<void> getData() async {
    CollectionReference _collectionRef2 =
        FirebaseFirestore.instance.collection('menu');

    QuerySnapshot querySnapshot = await _collectionRef.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    print(allData);
    QuerySnapshot aa = await _collectionRef2.get();
    final restOfItems = aa.docs.map((doc) => doc.data()).toList();

    menuItems = restOfItems;
    print("AAAB");
    print("zebu: " + menuItems.toString());

    // List<String> newList = List.empty();

    for (var a in menuItems) {
      // print(a.itemName + " " + a.price);
      print(a);
      print("type: " + a.runtimeType.toString());

      String aStr = a.toString();

      String itemNameString = "itemName: ";
      String itemPriceString = "price: ";
      String name = aStr.substring(
          aStr.indexOf(itemNameString) + itemNameString.length,
          aStr.indexOf(",", aStr.indexOf(itemNameString)));
      print("item name : " + name);

      String price = aStr.substring(
          aStr.indexOf(itemPriceString) + itemPriceString.length,
          aStr.indexOf(",", aStr.indexOf(itemPriceString)));
      print("item price : " + price);

      newMenuItems.add("${name};${price}");

      // for (var e in a) {
      //   print(e);
      // }
    }

    print(newMenuItems.toString());

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

////////////////////////////////////////////////////////////////////////////////////////////////////////////
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController titleController = new TextEditingController();
  TextEditingController authorController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Firestore CRUD"),
      ),
      body: BookList(),
      // ADD (Create)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Add"),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "Title: ",
                          textAlign: TextAlign.start,
                        ),
                      ),
                      TextField(
                        controller: titleController,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text("Author: "),
                      ),
                      TextField(
                        controller: authorController,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Undo",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    //Add Button

                    ElevatedButton(
                      onPressed: () {
                        //TODO: Firestore create a new record code

                        Map<String, dynamic> newBook =
                            new Map<String, dynamic>();
                        newBook["title"] = titleController.text;
                        newBook["author"] = authorController.text;

                        FirebaseFirestore.instance
                            .collection("books")
                            .add(newBook)
                            .whenComplete(() {
                          Navigator.of(context).pop();
                        });
                      },
                      child: Text(
                        "save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              });
        },
        tooltip: 'Add Title',
        child: Icon(Icons.add),
      ),
    );
  }
}

class BookList extends StatelessWidget {
  TextEditingController titleController = new TextEditingController();
  TextEditingController authorController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    //TODO: Retrive all records in collection from Firestore
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('books').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            return ListView(
              padding: EdgeInsets.only(bottom: 80),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Update Dilaog"),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Title: ",
                                      textAlign: TextAlign.start,
                                    ),
                                    TextField(
                                      controller: titleController,
                                      decoration: InputDecoration(
                                        hintText: document['title'],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: Text("Author: "),
                                    ),
                                    TextField(
                                      controller: authorController,
                                      decoration: InputDecoration(
                                        hintText: document['author'],
                                      ),
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Undo",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  // Update Button
                                  ElevatedButton(
                                      child: Text(
                                        "Update",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        //TODO: Firestore update a record code

                                        Map<String, dynamic> updateBook =
                                            new Map<String, dynamic>();
                                        updateBook["title"] =
                                            titleController.text;
                                        updateBook["author"] =
                                            authorController.text;

                                        // Updae Firestore record information regular way
                                        FirebaseFirestore.instance
                                            .collection("books")
                                            .doc(document.id)
                                            .update(updateBook)
                                            .whenComplete(() {
                                          Navigator.of(context).pop();
                                        });

                                        child:
                                        Text(
                                          "update",
                                          style: TextStyle(color: Colors.white),
                                        );
                                      }),
                                ],
                              );
                            });
                      },
                      title: new Text("Title " + document['title']),
                      subtitle: new Text("Author " + document['author']),
                      trailing:
                          // Delete Button
                          InkWell(
                        onTap: () {
                          //TODO: Firestore delete a record code
                          FirebaseFirestore.instance
                              .collection("books")
                              .doc(document.id)
                              .delete()
                              .catchError((e) {
                            print(e);
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Icon(Icons.delete),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
        }
      },
    );
  }
}
