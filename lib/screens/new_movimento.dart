import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pfm_app/models/categoria.dart';
import 'package:pfm_app/screens/new_movimento_categoria.dart';

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
  List<Categoria> _elencoCategorieSelezionate = [];

  void _setIsEntrata() {
    setState(() {
      isEntrata = !isEntrata;
    });
  }

  void _showAggiungiCategoria(List<Categoria> elencoCategorie) async {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return AggiungiCategoria(elencoCategorie: elencoCategorie, aggiungiCategoria: _aggiungiCategoria,);
        });
  }

  void _aggiungiCategoria(Categoria categoria) {
    setState(() {
      _elencoCategorieSelezionate.add(categoria);  
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

  void _salvaMovimento() {
    // TODO - implementare il salvataggio del movimento 
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
              Theme.of(context).colorScheme.onPrimary, 
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
                validator: (value) {
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
                  _showAggiungiCategoria(widget.elencoCategorie.where((element) {
                    return element.macroTipo == (isEntrata ? "entrata" : "uscita");
                  },).toList());
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
                  itemCount: _elencoCategorieSelezionate.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_elencoCategorieSelezionate[index].descrizione, style: TextStyle(color: Color(int.parse(_elencoCategorieSelezionate[index].macroColore.substring(1), radix: 16),),),),
                      subtitle: Text(_elencoCategorieSelezionate[index].macroDescrizione),
                    );
                },),
              )
            ],
          ),
        ),
      ),
    );
  }
}
