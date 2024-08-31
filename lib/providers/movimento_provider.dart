import 'dart:convert';

import 'package:pfm_app/models/categoria.dart';
import 'package:pfm_app/models/movimento.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class MovimentoNotifier extends StateNotifier<List<Movimento>> {
  MovimentoNotifier() : super([]);

  Future<void> loadTransaction(int utenteId) async {
    final url =
        Uri.parse("http://192.168.1.199:8000/movimenti/utente/$utenteId");
    final response = await http.get(url);

    final List<Movimento> elencoTransizioni = [];

    if (response.statusCode == 200) {
      final resData = json.decode(response.body);

      for (var movimento in resData) {
        List<Categoria> elencoCategorie = [];

        var resDataCategorie = movimento["elenco_categorie"];

        for (var cat in resDataCategorie) {
          elencoCategorie.add(
            Categoria(
              codice: cat['categoria_codice'],
              descrizione: cat['categoria_descrizione'],
              macroCodice: cat['categoria_macro_codice'],
              macroDescrizione: cat['categoria_macro_descrizione'],
              macroColore: cat['categoria_macro_colore'],
              macroTipo: cat['categoria_macro_tipo']
            )
          );
        }

        elencoTransizioni.add(
          Movimento(
              title: movimento['movimento_titolo'],
              amount: movimento['movimento_importo'],
              note: movimento['movimento_note'] ?? "",
              tipo: movimento['movimento_tipo'],  
              categorie: elencoCategorie,
              date: DateTime.tryParse(movimento['movimento_data'])!),
        );
      }
    }
    
    state = elencoTransizioni;
  }
}

final movimentoProvider =
    StateNotifierProvider<MovimentoNotifier, List<Movimento>>(
        (ref) => MovimentoNotifier());
