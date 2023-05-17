import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login.dart';
import 'admin_nav_bar.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();

  // Regular expression for validating price input
  final RegExp priceRegex = RegExp(r'^\d+(\.\d{0,2})?$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(
        email: widget.email,
      ),
      appBar: AppBar(
        backgroundColor: Colors.redAccent.shade100,
        title: Text("Menu"),
      ),
      body: MenuList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Container(
                  height: 350,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Add a New Menu Item"),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "Item Name: ",
                          textAlign: TextAlign.start,
                        ),
                      ),
                      TextFormField(
                        controller: itemNameController,
                        // Validate non-empty item name
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter an item name';
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text("Price: "),
                      ),
                      TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        // Validate price format
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(priceRegex),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Text(
                          "Image Url: ",
                          textAlign: TextAlign.start,
                        ),
                      ),
                      TextFormField(
                        controller: imageUrlController,
                        // Validate non-empty image URL
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter an image URL';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        itemNameController.clear();
                        priceController.clear();
                        imageUrlController.clear();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Undo",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent.shade100,
                      ),
                    ),
                  ),

                  //Add Button

                  ElevatedButton(
                    onPressed: () {
                      // Validate the form inputs
                      if (_validateForm()) {
                        //TODO: Firestore create a new record code

                        Map<String, dynamic> newMenuItem = {
                          "itemName": itemNameController.text,
                          "price": double.parse(priceController.text),
                          // Convert string to double
                          "imageUrl": imageUrlController.text,
                        };

                        FirebaseFirestore.instance
                            .collection("menu")
                            .add(newMenuItem)
                            .whenComplete(() {
                          itemNameController.clear();
                          priceController.clear();
                          imageUrlController.clear();
                          Navigator.of(context).pop();
                        });
                      }
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.shade100,
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent.shade100,
      ),
    );
  }

  bool _validateForm() {
    if (itemNameController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Invalid Item Name"),
            content: Text("Please enter an item name."),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.shade100,
                ),
              ),
            ],
          );
        },
      );
      return false;
    }

    if (!priceRegex.hasMatch(priceController.text)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Invalid Price"),
            content:
                Text("Please enter a valid price with up to 2 decimal places."),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.shade100,
                ),
              ),
            ],
          );
        },
      );
      return false;
    }

    if (imageUrlController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Invalid Image URL"),
            content: Text("Please enter an image URL."),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.shade100,
                ),
              ),
            ],
          );
        },
      );
      return false;
    }
    return true;
  }
}

class MenuList extends StatelessWidget {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Regular expression for validating price input
  final RegExp priceRegex = RegExp(r'^\d+(\.\d{0,2})?$');

  @override
  Widget build(BuildContext context) {
    // TODO: Retrieve all records in collection from Firestore
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('menu').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
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
                        // Set the initial values for text fields
                        itemNameController.text = document['itemName'];
                        priceController.text = document['price'].toString();
                        imageUrlController.text = document['imageUrl'];

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Update Menu Item"),
                              content: Container(
                                height: 350,
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("Item Name: ",
                                          textAlign: TextAlign.start),
                                      TextFormField(
                                        controller: itemNameController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter an item name.';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          hintText: document['itemName'],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child: Text("Price: "),
                                      ),
                                      TextFormField(
                                        controller: priceController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter a price.';
                                          }
                                          if (!priceRegex.hasMatch(value)) {
                                            return 'Please enter a price with up to 2 decimal places.';
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText:
                                              document['price'].toString(),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child: Text("Image Url: "),
                                      ),
                                      TextFormField(
                                        controller: imageUrlController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter an image URL.';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          hintText: document['imageUrl'],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.redAccent.shade100,
                                    ),
                                  ),
                                ),
                                // Update Button
                                ElevatedButton(
                                  child: Text(
                                    "Update",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent.shade100,
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      // Validate the price input
                                      final priceInput = priceController.text;
                                      if (!priceRegex.hasMatch(priceInput)) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Invalid Price"),
                                              content: Text(
                                                "Please enter a valid price with up to 2 decimal places.",
                                              ),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("OK"),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors
                                                        .redAccent.shade100,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        return;
                                      }

                                      // Validate the item name input
                                      final itemName =
                                          itemNameController.text.trim();
                                      if (itemName.isEmpty) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Invalid Item Name"),
                                              content: Text(
                                                  "Please enter an item name."),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("OK"),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors
                                                        .redAccent.shade100,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        return;
                                      }

                                      // Validate the image URL input
                                      final imageUrl =
                                          imageUrlController.text.trim();
                                      if (imageUrl.isEmpty) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Invalid Image URL"),
                                              content: Text(
                                                  "Please enter an image URL."),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("OK"),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors
                                                        .redAccent.shade100,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        return;
                                      }

                                      // TODO: Firestore update a record code
                                      Map<String, dynamic> updateMenu = {
                                        "itemName": itemName,
                                        "price": double.parse(priceInput),
                                        // Convert string to double
                                        "imageUrl": imageUrl,
                                      };

                                      // Update Firestore record information
                                      FirebaseFirestore.instance
                                          .collection("menu")
                                          .doc(document.id)
                                          .update(updateMenu)
                                          .whenComplete(() {
                                        Navigator.of(context).pop();
                                      });
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      title: Text(
                          "Item Name: ${document['itemName']}, Price: ${document['price']}"),
                      subtitle: Text("Image Url: ${document['imageUrl']}"),
                      trailing: InkWell(
                        onTap: () {
                          // TODO: Firestore delete a record code
                          FirebaseFirestore.instance
                              .collection("menu")
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