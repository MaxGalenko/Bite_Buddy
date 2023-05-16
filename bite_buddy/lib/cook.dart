import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'cook_nav_bar.dart';

class Cook extends StatefulWidget {
  const Cook({Key? key, required this.email}) : super(key: key);
  final String email;

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
          children: [],
        ),
      ),
    );
  }
}