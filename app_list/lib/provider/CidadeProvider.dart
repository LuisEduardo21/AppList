import 'package:flutter/material.dart';

class CidadeProvider extends ChangeNotifier {
  String _cidadeSelecionada = "Recife"; // Cidade inicial

  String get cidadeSelecionada => _cidadeSelecionada;

  void selecionarCidade(String cidade) {
    _cidadeSelecionada = cidade;
    notifyListeners(); // Notifica os ouvintes sobre a mudança
  }
}
