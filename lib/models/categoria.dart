class Categoria {
  Categoria({
    required this.id,
    required this.codice, 
    required this.descrizione,
    required this.macroCodice,
    required this.macroDescrizione,
    required this.macroColore,
    required this.macroTipo
    });

  int id;
  String codice;
  String descrizione;
  String macroCodice;
  String macroDescrizione;
  String macroColore;
  String macroTipo;
}