import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfm_app/models/categoria.dart';
import 'package:http/http.dart' as http;

class CategoriaProvider extends StateNotifier<List<Categoria>> {
  CategoriaProvider() : super([]);

  Future<void> loadCategorie() async {
    final List<Categoria> elencoCategorie = [];

    final url = Uri.parse("http://192.168.1.199:8000/categorie/");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final resData = json.decode(response.body);

      for (var cat in resData) {
        elencoCategorie.add(
          Categoria(
            id: cat['categoria_id'],
            codice: cat['categoria_codice'],
            descrizione: cat['categoria_descrizione'],
            macroCodice: cat['categoria_macro_codice'],
            macroDescrizione: cat['categoria_macro_descrizione'],
            macroColore: cat['categoria_macro_color'],
            macroTipo: cat['categoria_macro_tipo'],
          ),
        );
      }
    }

    state = elencoCategorie;
  }
}

final categorieProvider =
    StateNotifierProvider<CategoriaProvider, List<Categoria>>(
  (ref) => CategoriaProvider(),
);
