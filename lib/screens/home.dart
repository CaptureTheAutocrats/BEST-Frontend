import 'package:best_frontend/fragments/products.dart';
import 'package:best_frontend/screens/product_upload.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  final List<BottomNavigationBarItem> _bottomNavigationBarItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.person_2_rounded),
      label: "Products",
    ),
    BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Orders"),
    BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
    BottomNavigationBarItem(
      icon: Icon(Icons.file_upload_outlined),
      label: "Upload",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_2_rounded),
      label: "Profile",
    ),
  ];

  final List<Widget> _bottomNavigationBarWidgets = const [
    ProductsGrid(),
    Center(child: Text("Orders")),
    Center(child: Text("Cart")),
    ProductUploadPage(),
    Center(child: Text("Profile")),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    bottomNavigationBar: BottomNavigationBar(
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      currentIndex: _selectedIndex,
      items: _bottomNavigationBarItems,
    ),
    body: _bottomNavigationBarWidgets[_selectedIndex],
  );
}
