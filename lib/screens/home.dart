import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfm_app/screens/profilo.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:pfm_app/widgets/home_table.dart';
import 'package:pfm_app/screens/new_movimento.dart';
import 'package:pfm_app/models/movimento.dart';
import 'package:pfm_app/providers/movimento_provider.dart';
import 'package:pfm_app/providers/categoria_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<void> _movimentiFuture, _categorieFuture;

  @override
  void initState() {
    super.initState();
    _caricaFuture();
  }

  void _caricaFuture() {
    _categorieFuture = ref.read(categorieProvider.notifier).loadCategorie();
    _movimentiFuture = ref.read(movimentoProvider.notifier).loadTransaction(1);
  }

  List<Widget> _getListTileTransizioni() {
    int limit = 3, count = 0;

    final List<Widget> listTileTransizioni = [];
    final elencoMovimenti = ref.watch(movimentoProvider);

    for (var movimento in elencoMovimenti) {
      String formattedDate = DateFormat("dd/MM/yyyy").format(movimento.date);

      listTileTransizioni.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: ListTile(
            tileColor: Theme.of(context).colorScheme.onSurfaceVariant,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12),),),
            title: Text(
              "$formattedDate - ${movimento.title} - ${movimento.amount} €",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary, fontSize: 18),
            ),
            subtitle: Text(movimento.note != null ? movimento.note! : "",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white70)),
          ),
        ),
      );

      count++;

      if (count >= limit) {
        return listTileTransizioni;
      }
    }

    return listTileTransizioni;
  }

  @override
  Widget build(BuildContext context) {
    final elencoMovimenti = ref.watch(movimentoProvider);
    final elencoCategorie = ref.watch(categorieProvider);

    Widget mainContent = Center(
      child: Text(
        "Per favore inserire una transazione",
        style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary, fontSize: 18),
      ),
    );

    Widget safeArea = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.all(12),
              child: SfCircularChart(
                series: _getBalancePieSeries(elencoMovimenti),
              ),
            ),
            HomeTable(
              title: "Ultime transizioni",
              listTiles: _getListTileTransizioni(),
            )
          ],
        ),
      ),
    );

    mainContent = FutureBuilder(
      future: _movimentiFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError == true) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${snapshot.error}",
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _caricaFuture,
                  icon: Icon(Icons.replay_outlined,
                      color: Theme.of(context).colorScheme.onPrimary),
                  label: Text(
                    "Riprova",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 18),
                  ),
                )
              ],
            ),
          );
        }

        return safeArea;
      },
    );

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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ProfiloScreen();
                    },
                  ),
                );
              },
              icon: const Icon(
                Icons.account_circle,
                size: 32,
                color: Color.fromARGB(255, 245, 243, 245),
              ),
            ),
          ),
        ],
      ),
      body: mainContent,
      floatingActionButton: FutureBuilder(
        future: _categorieFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }

          return ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return NewMovimento(
                      elencoCategorie: elencoCategorie,
                      aggiungiMovimento: ref
                          .read(movimentoProvider.notifier)
                          .aggiungiMovimento);
                }),
              );
            },
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
          );
        },
      ),
    );
  }

  List<DoughnutSeries<Balance, String>> _getBalancePieSeries(
      List<Movimento> elencoMovimenti) {
    return [
      DoughnutSeries<Balance, String>(
        pointColorMapper: (datum, index) => datum.color,
        dataSource: [
          Balance(
            title: 'Uscite',
            amount: elencoMovimenti
                    .where(
                      (element) {
                        return element.tipo == "uscita";
                      },
                    )
                    .toList()
                    .isEmpty
                ? 0
                : elencoMovimenti
                    .where(
                      (element) {
                        return element.tipo == "uscita";
                      },
                    )
                    .toList()
                    .map(
                      (e) {
                        return e.amount;
                      },
                    )
                    .toList()
                    .reduce(
                      (value, element) => value + element,
                    ),
            color: const Color.fromARGB(255, 237, 8, 0),
          ),
          Balance(
            title: 'Entrate',
            amount: elencoMovimenti
                    .where(
                      (element) {
                        return element.tipo == "entrata";
                      },
                    )
                    .toList()
                    .isEmpty
                ? 0
                : elencoMovimenti
                    .where(
                      (element) {
                        return element.tipo == "entrata";
                      },
                    )
                    .toList()
                    .map(
                      (e) {
                        return e.amount;
                      },
                    )
                    .toList()
                    .reduce(
                      (value, element) => value + element,
                    ),
            color: const Color.fromARGB(255, 87, 186, 29),
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
