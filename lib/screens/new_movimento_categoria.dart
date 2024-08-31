import 'package:flutter/material.dart';
import 'package:pfm_app/models/categoria.dart';

class AggiungiCategoria extends StatefulWidget {
  const AggiungiCategoria(
      {super.key,
      required this.elencoCategorie,
      required this.aggiungiCategoria});

  final List<Categoria> elencoCategorie;
  final void Function(Categoria categoria) aggiungiCategoria;

  @override
  State<AggiungiCategoria> createState() {
    return _AggiungiCategoriaState();
  }
}

class _AggiungiCategoriaState extends State<AggiungiCategoria> {
  final _searchBarController = TextEditingController();

  late List<Categoria> elencoCategorie;
  List<Container> elencoButtoniCategorie = [];
  late List<Categoria> filteredElencoCategorie;

  @override
  void initState() {
    super.initState();

    elencoCategorie = widget.elencoCategorie;

    _filterList("");
  }

  void _createCustomButtons() {
    elencoButtoniCategorie.clear();

    for (Categoria categoria in filteredElencoCategorie) {
      Color color =
          Color(int.parse(categoria.macroColore.substring(1), radix: 16));

      elencoButtoniCategorie.add(
        Container(
          margin: const EdgeInsets.all(2),
          child: OutlinedButton.icon(
            onPressed: () {
              widget.aggiungiCategoria(categoria);
              Navigator.pop(context);
            },
            icon: Icon(Icons.add, color: color),
            label: Text(
              categoria.descrizione,
              style: TextStyle(color: color, fontSize: 16),
            ),
          ),
        ),
      );
    }
  }

  void _filterList(String textFilter) {
    setState(() {
      filteredElencoCategorie = elencoCategorie
          .where((categoria) => categoria.descrizione
              .toLowerCase()
              .contains(textFilter.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _createCustomButtons();

    elencoButtoniCategorie.shuffle();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        title: TextField(
          onChanged: (value) {
            _filterList(value);
          },
          onSubmitted: (value) {
            _filterList(value);
          },
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          controller: _searchBarController,
          decoration: InputDecoration(
            prefix: IconButton(
              onPressed: () {
                _filterList(_searchBarController.text);
              },
              icon: Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            suffix: IconButton(
              onPressed: () {
                _searchBarController.clear();
                _filterList("");
              },
              icon: Icon(
                Icons.cancel,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            hintText: "Cerca...",
            hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary, fontSize: 18),
          ),
        ),
      ),
      body: elencoButtoniCategorie.isEmpty
          ? Center(
              child: Text(
                "Non sono presenti categorie da selezionare",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
            )
          : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
                children: elencoButtoniCategorie.length > 10
                    ? elencoButtoniCategorie.getRange(0, 10).toList()
                    : elencoButtoniCategorie,
              ),
          ),
    );
  }
}
