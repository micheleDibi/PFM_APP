import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfm_app/models/utente.dart';
import 'package:pfm_app/providers/utente_provider.dart';
import 'package:pfm_app/screens/login.dart';

class ProfiloScreen extends ConsumerWidget {
  const ProfiloScreen({super.key});

  void _logout(BuildContext context) {
    

    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
builder: (context) => Login()), (Route route) => false);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Utente utente = ref.watch(utenteProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        title: Text(
          "Il mio profilo",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _logout(context);
            },
            icon: Icon(Icons.logout_rounded,
                color: Theme.of(context).colorScheme.onPrimary),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Column(
            children: [
              Card(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Denominazione",
                          style: TextStyle(fontSize: 16),
                        ),
                        const Divider(
                          height: 12,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Center(
                          child: Text(
                            utente.denominazione,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        )
                      ],
                    ),
                  )),
              const SizedBox(
                height: 12,
              ),
              Card(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Email",
                        style: TextStyle(fontSize: 16),
                      ),
                      const Divider(
                        height: 12,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Center(
                        child: Text(
                          utente.email,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
