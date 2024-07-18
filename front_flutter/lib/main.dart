import 'package:flutter/material.dart';
import 'home_page/home_page.dart';
import 'styles/styles.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        fontFamily: 'Numans',
      ),
      home: HomePage(),
    );
  }
}
