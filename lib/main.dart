import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:frontend/screens/login_registration.dart';

import 'screens/product_upload.dart';
import 'theme.dart';

void main() {
  runApp(LiveTestApp());
}

class LiveTestApp extends StatelessWidget {
  const LiveTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    APIService().fetchAllProducts().then(print).catchError(print);
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
