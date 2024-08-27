import 'package:flutter/material.dart';

import 'package:pfm_app/home.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {

  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Finance Management',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 37, 39, 40),),
      ),
      home: const HomeScreen(),
    );
  }
}