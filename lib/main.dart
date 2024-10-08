import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pfm_app/screens/login.dart';

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Finance Management',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 37, 39, 40),
        ),
        textTheme: GoogleFonts.openSansTextTheme().copyWith(
          // bodyLarge: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          bodyMedium: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          // bodySmall: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      home: Login(),
    );
  }
}
