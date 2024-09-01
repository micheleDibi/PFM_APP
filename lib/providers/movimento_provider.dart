import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:pfm_app/models/categoria.dart';
import 'package:pfm_app/models/movimento.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class MovimentoNotifier extends StateNotifier<List<Movimento>> {
  MovimentoNotifier() : super([]);      

  Future<void> loadTransaction(int utenteId) async {
  try {
    final url =
        Uri.parse("http://192.168.1.199:8000/movimenti/utente/$utenteId");
    final response = await http.get(url).timeout(const Duration(seconds: 5));

    final List<Movimento> elencoTransizioni = [];

    if (response.statusCode == 200) {
      final resData = json.decode(response.body);

      for (var movimento in resData) {
        List<Categoria> elencoCategorie = [];

        var resDataCategorie = movimento["elenco_categorie"];

        for (var cat in resDataCategorie) {
          elencoCategorie.add(Categoria(
              id: cat["categoria_id"],
              codice: cat['categoria_codice'],
              descrizione: cat['categoria_descrizione'],
              macroCodice: cat['categoria_macro_codice'],
              macroDescrizione: cat['categoria_macro_descrizione'],
              macroColore: cat['categoria_macro_colore'],
              macroTipo: cat['categoria_macro_tipo']));
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

      state = elencoTransizioni;
    } else {
      throw Exception('Failed to load transactions');
    }
  } on TimeoutException catch (_) {
    throw Exception('Timeout: Server non risponde. Riprova più tardi.');
  } on SocketException catch (_) {
    throw Exception('Nessuna connessione a Internet. Verifica la tua rete.');
  } catch (error) {
    throw Exception('Errore imprevisto: $error');
  }
}

  void aggiungiMovimento(Movimento movimento) async {
    final url = Uri.parse("http://192.168.1.199:8000/movimento/");

    final body = json.encode( {
          "movimento_titolo": movimento.title,
          "movimento_data": movimento.date.toString(),
          "movimento_importo": movimento.amount,
          "movimento_note": movimento.note,
          "movimento_tipo": movimento.tipo,
          "elenco_categorie": movimento.categorie.map(
            (e) {
              return e.id;
            },
          ).toList(),
          "utente_id" : 1,
          "movimento_created_by": 1,
          "movimento_updated_by": 1,
        });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if(response.statusCode >= 400) {
      return;
    }

    state = [movimento, ...state];
  }
}

final movimentoProvider =
    StateNotifierProvider<MovimentoNotifier, List<Movimento>>(
        (ref) => MovimentoNotifier());
