import 'package:flutter/material.dart';

// import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewMovimento extends StatefulWidget {
  const NewMovimento({super.key});

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

  void _setIsEntrata() {
    setState(() {
      isEntrata = !isEntrata;
    });
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
              Theme.of(context).colorScheme.onPrimary, //change your color here
        ),
        title: Text(
          "Aggiungi un nuovo movimento",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
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
                    onPressed: isEntrata ? () {} : _setIsEntrata,
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
                    onPressed: !isEntrata ? () {} : _setIsEntrata,
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
              TextFormField(
                cursorColor: Theme.of(context).colorScheme.onPrimary,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  label: Text("Titolo"),
                  // floatingLabelStyle: TextStyle(color: Colors.red),
                ),
                validator: (value) {
                  return null;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
