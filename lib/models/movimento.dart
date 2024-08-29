import 'package:pfm_app/models/categoria.dart';

class Movimento {

  Movimento({required this.title, required this.amount, required this.date, required this.categorie, this.note = "", required this.tipo});

  String title;
  double amount;
  String note;
  DateTime date;
  String tipo;
  List<Categoria> categorie;

}