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

class BottoneCategoria extends StatelessWidget {
  const BottoneCategoria(
      {super.key, required this.categoria, required this.aggiungiCategoria});

  final Categoria categoria;
  final void Function(Categoria categoria) aggiungiCategoria;

  @override
  Widget build(BuildContext context) {
    Color color =
        Color(int.parse(categoria.macroColore.substring(1), radix: 16));

    return Container(
      margin: const EdgeInsets.all(2),
      child: OutlinedButton.icon(
        onPressed: () {
          aggiungiCategoria(categoria);
          Navigator.pop(context);
        },
        icon: Icon(Icons.add, color: color),
        label: Text(
          categoria.descrizione,
          style: TextStyle(color: color, fontSize: 16),
        ),
      ),
    );
  }
}

class _AggiungiCategoriaState extends State<AggiungiCategoria> {
  final _searchBarController = TextEditingController();

  late List<Categoria> elencoCategorie;
  List<BottoneCategoria> elencoButtoniCategorie = [];
  List<BottoneCategoria> elencoBottoniCategorieFiltrate = [];

  @override
  void initState() {
    super.initState();

    elencoCategorie = widget.elencoCategorie;

    _initializeCustomButtons();
  }

  void _initializeCustomButtons() {
    elencoButtoniCategorie.clear();

    for (Categoria categoria in elencoCategorie) {
      elencoButtoniCategorie.add(BottoneCategoria(
          categoria: categoria, aggiungiCategoria: widget.aggiungiCategoria));
    }

    elencoButtoniCategorie.shuffle();
    elencoBottoniCategorieFiltrate = elencoButtoniCategorie;
  }

  void _filterList(String textFilter) {
    setState(() {
      elencoBottoniCategorieFiltrate = elencoButtoniCategorie
          .where((bottone) => bottone.categoria.descrizione
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
                if (_searchBarController.text.isNotEmpty) {
                  _filterList(_searchBarController.text);
                }
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
      body: elencoBottoniCategorieFiltrate.isEmpty
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
                children: elencoBottoniCategorieFiltrate.length > 10
                    ? elencoBottoniCategorieFiltrate.getRange(0, 10).toList()
                    : elencoBottoniCategorieFiltrate,
              ),
            ),
    );
  }
}
