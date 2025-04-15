import 'package:flutter/material.dart';

void main() {
  runApp(LiveTestApp());
}

class LiveTestApp extends StatelessWidget {
  const LiveTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          title: Text("Profile"),
        ),
        body: Center(
          child: Column(
            children: [
              Icon(Icons.person_pin, color: Colors.green),
              Text("John Doe", style: TextStyle(color: Colors.green)),
              Text(
                "Flutter Batch 4",
                style: TextStyle(color: Colors.lightBlueAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
