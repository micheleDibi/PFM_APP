import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfm_app/providers/utente_provider.dart';
import 'package:pfm_app/screens/home.dart';
import 'package:pfm_app/models/utente.dart';

class Login extends ConsumerWidget {
  Login({super.key});

  final _keyForm = GlobalKey<FormState>();

  late String _email;
  late String _password;

  void _login(BuildContext context, WidgetRef ref) {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();

      Future<void> utenteFuture =
          ref.read(utenteProvider.notifier).loadUtente(_email, _password);

      utenteFuture.then(
        (value) {
          Utente utente = ref.watch(utenteProvider);

          if (utente.id != 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return const HomeScreen();
              },
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Utente non trovato'),
              ),
            );
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Form(
            key: _keyForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/logo.png",
                  height: 250,
                ),
                // Text("Accedi", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 24,), ),
                const SizedBox(
                  height: 22,
                ),
                TextFormField(
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onSaved: (newValue) {
                    _email = newValue!;
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Inserire un email";
                    }

                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email,
                        color: Theme.of(context).colorScheme.onPrimary),
                    label: Text(
                      "Email",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                TextFormField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onSaved: (newValue) {
                    _password = newValue!;
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Inserire la password";
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.password,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    label: Text(
                      "Password",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

                OutlinedButton.icon(
                  onPressed: () {
                    _login(context, ref);
                  },
                  icon: Icon(Icons.login,
                      color: Theme.of(context).colorScheme.onPrimary),
                  label: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      "Accedi",
                      style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
