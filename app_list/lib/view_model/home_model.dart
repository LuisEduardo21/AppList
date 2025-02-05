import 'package:app_list/service/api.dart';
import 'package:app_list/view_model/base_view_model.dart';
import 'package:flutter/material.dart';

class HomeModel extends BaseViewModel {
  final BaseService _service = BaseService();
  List<dynamic> listaMoteis = [];
  List<dynamic> carrosselData = [];
  List<dynamic> get primeirosMoteis => listaMoteis
      .take(5)
      .toList(); // Pega os 5 primeiros itens da lista de motéis

  void onInit(BuildContext context) async {
    try {
      var response = await _service.fetchData();

      if (response is Map &&
          response.containsKey('carrossel') &&
          response.containsKey('moteis')) {
        carrosselData = response['carrossel']; // Atribui os dados do carrossel
        listaMoteis = response['moteis']; // Atribui a lista completa de motéis
        notifyListeners(); // Notifica os ouvintes sobre a mudança de estado
      } else {
        throw Exception("Resposta do servidor não contém os dados esperados");
      }
    } catch (e) {
      print("Erro ao buscar dados: $e");
      // Mostra uma mensagem de erro para o usuário
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao carregar dados: $e")),
      );
    }
  }
}
