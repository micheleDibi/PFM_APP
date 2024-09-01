import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pfm_app/models/categoria.dart';
import 'package:pfm_app/models/movimento.dart';
import 'package:pfm_app/screens/new_movimento_categoria.dart';

class NewMovimento extends StatefulWidget {
  const NewMovimento(
      {super.key,
      required this.elencoCategorie,
      required this.aggiungiMovimento});

  final List<Categoria> elencoCategorie;
  final void Function(Movimento) aggiungiMovimento;

  @override
  State<NewMovimento> createState() {
    return _NewMovimentoState();
  }
}

class _NewMovimentoState extends State<NewMovimento> {
  bool isEntrata = true;
  final _formKey = GlobalKey<FormState>();

  final Color lightGreen = const Color.fromARGB(255, 87, 186, 29);
  final Color lightRed = const Color.fromARGB(255, 237, 8, 0);

  final Color strongGreen = const Color.fromARGB(255, 47, 116, 28);
  final Color strongRed = const Color.fromARGB(255, 115, 13, 15);

  late String _titolo;
  String? note;
  late double _importo;
  DateTime? _selectedDate;
  List<Categoria> elencoCategorieSelezionate = [];

  void _setIsEntrata() {
    setState(() {
      isEntrata = !isEntrata;
    });
  }

  void _selectDate() async {
    final firstDate = DateTime.now().subtract(const Duration(days: 365));
    final lastDate = DateTime.now().add(const Duration(days: 365));

    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: firstDate,
        lastDate: lastDate);

    setState(() {
      _selectedDate = selectedDate;
    });
  }

  void _showAggiungiCategoria(List<Categoria> elencoCategorie) async {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return AggiungiCategoria(
            elencoCategorie: elencoCategorie,
            aggiungiCategoria: _aggiungiCategoria,
          );
        });
  }

  void _aggiungiCategoria(Categoria categoria) {
    if (elencoCategorieSelezionate.contains(categoria)) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Text("Categoria già selezionata"),
      ));
    } else {
      setState(() {
        elencoCategorieSelezionate.add(categoria);
      });
    }
  }

  void _rimuoviCategoria(Categoria categoria) {
    setState(() {
      elencoCategorieSelezionate.remove(categoria);
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("Input non valido"),
            content: const Text(
                "Per favore inserire una data, un titolo, l'importo e una o più categorie per il movimento da salvare."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Input non valido"),
            content: const Text(
                "Per favore inserire una data, un titolo, l'importo e una o più categorie per il movimento da salvare."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );
    }
  }

  void _salvaMovimento() {
    if (!_formKey.currentState!.validate() ||
        _selectedDate == null ||
        elencoCategorieSelezionate.isEmpty) {
      _showDialog();
      return;
    }

    _formKey.currentState!.save();
    Navigator.pop(context);
    widget.aggiungiMovimento(
      Movimento(
          title: _titolo,
          note: note,
          amount: _importo,
          date: _selectedDate!,
          categorie: elencoCategorieSelezionate,
          tipo: isEntrata ? "entrata" : "uscita"),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        title: Text(
          "Nuovo movimento",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        actions: [
          IconButton(onPressed: _salvaMovimento, icon: const Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: _setIsEntrata,
                    icon: Icon(Icons.add,
                        size: 24,
                        color: isEntrata
                            ? Theme.of(context).colorScheme.onPrimary
                            : Colors.white54),
                    label: Text(
                      "Entrata",
                      style: TextStyle(
                          fontSize: 18,
                          color: isEntrata
                              ? Theme.of(context).colorScheme.onPrimary
                              : Colors.white54),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEntrata ? lightGreen : strongGreen,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _setIsEntrata,
                    icon: Icon(Icons.remove,
                        size: 24,
                        color: !isEntrata
                            ? Theme.of(context).colorScheme.onPrimary
                            : Colors.white54),
                    label: Text(
                      "Uscita",
                      style: TextStyle(
                          fontSize: 18,
                          color: !isEntrata
                              ? Theme.of(context).colorScheme.onPrimary
                              : Colors.white54),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !isEntrata ? lightRed : strongRed,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 22,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _selectDate,
                      label: Text(
                        _selectedDate == null
                            ? "Seleziona una data"
                            : DateFormat("dd/MM/yyyy").format(_selectedDate!),
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      icon: Icon(Icons.calendar_month,
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 22,
              ),
              TextFormField(
                cursorColor: Theme.of(context).colorScheme.onPrimary,
                decoration: const InputDecoration(
                  floatingLabelStyle: TextStyle(
                    color: Colors.white60,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.white60,
                  ),
                  label: Text(
                    "Titolo",
                  ),
                ),
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                onSaved: (newValue) {
                  _titolo = newValue!;
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Inserisci un titolo';
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 18,
              ),
              TextFormField(
                cursorColor: Theme.of(context).colorScheme.onPrimary,
                decoration: const InputDecoration(
                  floatingLabelStyle: TextStyle(
                    color: Colors.white60,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.white60,
                  ),
                  label: Text(
                    "Note",
                  ),
                ),
                onSaved: (newValue) {
                  note = newValue;
                },
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              TextFormField(
                cursorColor: Theme.of(context).colorScheme.onPrimary,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  suffix: Icon(
                    Icons.euro,
                    color: Colors.white60,
                  ),
                  floatingLabelStyle: TextStyle(
                    color: Colors.white60,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.white60,
                  ),
                  label: Text(
                    "Importo",
                  ),
                ),
                onSaved: (newValue) {
                  _importo = double.tryParse(newValue!)!;
                },
                validator: (value) {
                  if (value == null ||
                      double.tryParse(value) == null ||
                      double.tryParse(value)! <= 0) {
                    return 'Inserire un importo corretto.';
                  }

                  return null;
                },
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(Icons.add_circle_outlined,
                    color: Theme.of(context).colorScheme.onPrimary),
                onPressed: () {
                  _showAggiungiCategoria(widget.elencoCategorie.where(
                    (element) {
                      return element.macroTipo ==
                          (isEntrata ? "entrata" : "uscita");
                    },
                  ).toList());
                },
                label: Text(
                  "Aggiungi categoria",
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: elencoCategorieSelezionate.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: IconButton(
                          onPressed: () {
                            _rimuoviCategoria(
                                elencoCategorieSelezionate[index]);
                          },
                          icon: const Icon(Icons.remove)),
                      title: Text(
                        elencoCategorieSelezionate[index].descrizione,
                        style: TextStyle(
                          color: Color(
                            int.parse(
                                elencoCategorieSelezionate[index]
                                    .macroColore
                                    .substring(1),
                                radix: 16),
                          ),
                        ),
                      ),
                      subtitle: Text(
                          elencoCategorieSelezionate[index].macroDescrizione),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
