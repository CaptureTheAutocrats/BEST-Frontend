import 'package:flutter/material.dart';
import 'package:frontend/screens/login_registration.dart';

import 'theme.dart';

void main() {
  runApp(BESTApp());
}

class BESTApp extends StatelessWidget {
  const BESTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: theme, home: LoginRegistrationPage());
  }
}
