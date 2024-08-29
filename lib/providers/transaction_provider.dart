import 'dart:convert';

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

      for (var transizione in resData) {
        elencoTransizioni.add(
          Movimento(
              title: transizione['movimento_data'],
              amount: transizione['movimento_importo'],
              category: "Category",
              date: transizione['movimento_date']),
        );
      }
    }
    
    state = elencoTransizioni;
  }
}

final transactionProvider =
    StateNotifierProvider<MovimentoNotifier, List<Movimento>>(
        (ref) => MovimentoNotifier());
