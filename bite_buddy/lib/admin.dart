import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'admin_nav_bar.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(email: widget.email,),
      appBar: AppBar(
        backgroundColor: Colors.redAccent.shade100,
        title: Text("Menu"),
      ),
      body: Center(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}