import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/api.dart';

import 'screens/product_upload.dart';
import 'theme.dart';

void main() {
  runApp(BESTApp());
}

class BESTApp extends StatelessWidget {
  const BESTApp({super.key});

  @override
  Widget build(BuildContext context) {
    APIService()
        .fetchAllProducts()
        .then((products) {
          print(products);
          print(jsonEncode(products));
        })
        .catchError(print);
    return MaterialApp(
      theme: theme,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          title: Text("Profile"),
        ),
        body: ProductUploadPage(),
      ),
    );
  }
}
