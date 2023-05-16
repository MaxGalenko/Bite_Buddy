import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Cook'),
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
            leading: Icon(Icons.menu_book),
            title: Text('Menu'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Cart'),
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
    );
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