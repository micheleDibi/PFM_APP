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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: SfCircularChart(
                  series: _getBalancePieSeries(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  iconAlignment: IconAlignment.end,
                  label: Text(
                    "Ultime transizioni",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 18),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Divider(),
              ),
              Column(
                children: [
                  ListTile(
                    title: Text(
                      "Transizione 1",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Transizione 2",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Transizione 3",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  iconAlignment: IconAlignment.end,
                  label: Text(
                    "Risparmi",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 18),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Divider(),
              ),
              Column(
                children: [
                  ListTile(
                    title: Text(
                      "Risparmio 1",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Risparmio 2",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Risparmio 3",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    
      floatingActionButton: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.all(18),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
              ),
              iconAlignment: IconAlignment.end,
              label: Text(
                "Trasferisci",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              icon: Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),

      
    );
  }

  List<DoughnutSeries<Balance, String>> _getBalancePieSeries() {
    return [
      DoughnutSeries<Balance, String>(
        pointColorMapper: (datum, index) => datum.color,
        dataSource: [
          Balance(
            title: 'Uscite',
            amount: 420,
            color: const Color.fromARGB(255, 238, 78, 78),
          ),
          Balance(
            title: 'Entrate',
            amount: 1200,
            color: const Color.fromARGB(255, 161, 221, 112),
          ),
        ],
        xValueMapper: (datum, index) => datum.title,
        yValueMapper: (datum, index) => datum.amount,
        dataLabelMapper: (datum, index) =>
            "${datum.title} \n ${datum.amount.toStringAsFixed(2)} €",
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelPosition: ChartDataLabelPosition.outside,
          textStyle: TextStyle(
            color: Color.fromARGB(255, 245, 243, 245),
          ),
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
