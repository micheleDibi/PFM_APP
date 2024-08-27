import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        title: Text(
          "Personal Finance Management",
          style: GoogleFonts.lato(color: const Color.fromARGB(255, 245, 243, 245),),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.account_circle,
                size: 32,
                color: Color.fromARGB(255, 245, 243, 245),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
