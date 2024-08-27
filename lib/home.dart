import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:syncfusion_flutter_charts/sparkcharts.dart';

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
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        title: Text(
          "Personal Finance Management",
          style: GoogleFonts.lato(
            color: const Color.fromARGB(255, 245, 243, 245),
          ),
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
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: SfCircularChart(
              // title: const ChartTitle(text: "Balance"),
              // backgroundColor: Theme.of(context).colorScheme.secondary,
              series: _getBalancePieSeries(),
            ),
          ),
        ],
      ),
    );
  }

  List<DoughnutSeries<Balance, String>> _getBalancePieSeries() {
    return [
      DoughnutSeries<Balance, String>(
        pointColorMapper: (datum, index) => datum.color,
        dataSource: [
          Balance(title: 'Uscite', amount: 420, color: Colors.red),
          Balance(title: 'Entrate', amount: 1200, color: Colors.green),
        ],
        xValueMapper: (datum, index) => datum.title,
        yValueMapper: (datum, index) => datum.amount,
        dataLabelMapper: (datum, index) => "${datum.title} \n ${datum.amount}€",
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelPosition: ChartDataLabelPosition.outside,
          textStyle: TextStyle(color: Colors.white),
        ),
      )
    ];
  }
}

class Balance {
  Balance({required this.title, required this.amount, required this.color});

  String title;
  double amount;
  Color color;
}
