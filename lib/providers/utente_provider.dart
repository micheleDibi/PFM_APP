import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:pfm_app/models/utente.dart';

class UtenteNotifier extends StateNotifier<Utente> {
  UtenteNotifier() : super(const Utente(denominazione: "", email: "", id: 0));

  Future<void> loadUtente(String email, String password) async {
    try {
      final url = Uri.parse("http://192.168.1.199:8000/utente/");
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: json
                .encode({"utente_email": email, "utente_password": password}),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode < 400) {
        final responseData = json.decode(response.body);

        int utenteId = responseData['utente_id'];

        state = Utente(
            denominazione: responseData['utente_denominazione'] ?? "",
            email: email,
            id: utenteId);
      } else {
        throw ("Failed to load users.");
      }
    } on TimeoutException catch (_) {
      throw Exception('Timeout: Server non risponde. Riprova più tardi.');
    } on SocketException catch (_) {
      throw Exception('Nessuna connessione a Internet. Verifica la tua rete.');
    }
  }
}

final utenteProvider = StateNotifierProvider<UtenteNotifier, Utente>(
  (ref) => UtenteNotifier(),
);
