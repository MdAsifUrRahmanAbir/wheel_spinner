import 'package:flutter/material.dart';
import 'package:spinner/spinner_home_page.dart';

void main() {
  runApp(const SpinnerApp());
}

class SpinnerApp extends StatelessWidget {
  const SpinnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wheel Spinner',
      home: SpinnerHomePage(),
    );
  }
}

