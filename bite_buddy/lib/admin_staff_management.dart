import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'admin_nav_bar.dart';

class Staff extends StatefulWidget {
  const Staff({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  State<Staff> createState() => _StaffState();
}

class _StaffState extends State<Staff> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(
        email: widget.email,
      ),
      appBar: AppBar(
        backgroundColor: Colors.redAccent.shade100,
        title: Text("Staff"),
      ),
      body: StaffList(email: widget.email,),
    );
  }
}

class StaffList extends StatelessWidget {
  StaffList({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        if (!snapshot.hasData) return CircularProgressIndicator();
        final userDocs = snapshot.data!.docs
            .where((document) => document['role'] != 'Customer')
            .toList();
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 80),
          itemCount: userDocs.length,
          itemBuilder: (BuildContext context, int index) {
            final document = userDocs[index];
            TextEditingController emailController =
            TextEditingController(text: document['email']);
            String selectedRole = document['role'];
            String undoRole =
                selectedRole; // Store the original role before any changes

            // Check if the document's email matches the current user's email
            final isCurrentUserEmail = document['email'] == email;

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
              child: Card(
                child: ListTile(
                  onTap: () {
                    // Skip editing if it's the current user's email
                    if (isCurrentUserEmail) return;

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return AlertDialog(
                              title: Text("Update Dialog"),
                              content: Container(
                                height: 200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Email: ",
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      document['email'],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: Text("Role: "),
                                    ),
                                    DropdownButton<String>(
                                      value: selectedRole,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedRole = newValue!;
                                        });
                                      },
                                      items: <String>['Admin', 'Cook']
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Revert the selected role to the original role
                                      setState(() {
                                        selectedRole = undoRole;
                                      });
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
                                ElevatedButton(
                                  child: Text(
                                    "Update",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent.shade100,
                                  ),
                                  onPressed: () {
                                    // TODO: Firestore update a record code
                                    Map<String, dynamic> updateUser = {
                                      "email": emailController.text,
                                      "role": selectedRole,
                                    };

                                    FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(document.id)
                                        .update(updateUser)
                                        .whenComplete(() {
                                      Navigator.of(context).pop();
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                  title: Text(
                    "Email " + document['email'],
                    style: TextStyle(color: Colors.black),
                  ),
                  subtitle: Text("Role " + document['role']),
                  trailing: !isCurrentUserEmail
                      ? InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Confirmation"),
                            content: Text("Are you sure you want to delete the following user?\n\n ${document['email']}"),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Cancel"),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.shade100,),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(document.id)
                                      .delete()
                                      .catchError((e) {
                                    print(e);
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: Text("Delete"),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.shade100,),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Icon(Icons.delete),
                    ),
                  )
                      : null, // Hide the delete option for the current user's email
                ),
              ),
            );
          },
        );
      },
    );
  }
}