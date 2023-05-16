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
      drawer: NavBar(email: widget.email,),
      appBar: AppBar(
        backgroundColor: Colors.redAccent.shade100,
        title: Text("Staff"),
      ),
    );
  }
}
