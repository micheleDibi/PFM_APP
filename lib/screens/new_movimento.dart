import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pfm_app/providers/categoria_provider.dart';
import 'package:pfm_app/models/categoria.dart';

// import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewMovimento extends StatefulWidget {
  const NewMovimento({super.key, required this.elencoCategorie});

  final List<Categoria> elencoCategorie;

  @override
  State<NewMovimento> createState() {
    return _NewMovimentoState();
  }
}

class _NewMovimentoState extends State<NewMovimento> {
  bool isEntrata = true;

  final Color lightGreen = const Color.fromARGB(255, 87, 186, 29);
  final Color lightRed = const Color.fromARGB(255, 237, 8, 0);

  final Color strongGreen = const Color.fromARGB(255, 47, 116, 28);
  final Color strongRed = const Color.fromARGB(255, 115, 13, 15);

  DateTime? _selectedDate;
  Categoria? _selectedCategoria;

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

  @override
  void initState() {
    super.initState();

    _selectedCategoria = widget.elencoCategorie[0];
  }

  @override
  Widget build(BuildContext context) {
    final keyController = GlobalKey();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        iconTheme: IconThemeData(
          color:
              Theme.of(context).colorScheme.onPrimary, //change your color here
        ),
        title: Text(
          "Aggiungi un nuovo movimento",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Form(
            key: keyController,
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
                TextFormField(
                  cursorColor: Theme.of(context).colorScheme.onPrimary,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    label: Text("Titolo"),
                    // floatingLabelStyle: TextStyle(color: Colors.red),
                  ),
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(
                  height: 18,
                ),
                TextFormField(
                  decoration: const InputDecoration(label: Text("Importo")),
                ),
                const SizedBox(
                  height: 18,
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton(
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onPrimary),
                        dropdownColor: Theme.of(context).colorScheme.onSurface,
                        icon: Icon(Icons.arrow_drop_down,
                            color: Theme.of(context).colorScheme.onPrimary),
                        // padding: const EdgeInsets.all(8),
                        value: _selectedCategoria,
                        items: widget.elencoCategorie
                            .map(
                              (categoria) => DropdownMenuItem(
                                value: categoria,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    categoria.descrizione,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }

                          setState(() {
                            _selectedCategoria = value;
                          });
                        },
                      ),
                    ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
