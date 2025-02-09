import 'package:app_list/service/api.dart';
import 'package:app_list/utils/motels.dart';
import 'package:app_list/utils/suites.dart';
import 'package:app_list/view_model/base_view_model.dart';
import 'package:flutter/material.dart';

class HomeModel extends BaseViewModel {
  BaseService _service;
  List<Motel> listaMoteis = [];
  String? erro; // Adiciona um campo para erro

  HomeModel({BaseService? service}) : _service = service ?? BaseService();

  set service(BaseService service) => _service = service;

  List<Suite> get primeirasSuites {
    List<Suite> todasSuites = [];
    for (var motel in listaMoteis) {
      todasSuites.addAll(motel.suites);
    }
    return todasSuites.take(5).toList();
  }

  Future<void> onInit(BuildContext context) async {
    try {
      var response = await _service.fetchData();
      if (response is List<Motel>) {
        listaMoteis = response;
        erro = null;
      } else {
        erro = "Formato de resposta inválido.";
      }
    } catch (e) {
      erro = "Erro ao buscar dados: $e";
    }
    notifyListeners(); // Agora a UI pode reagir ao erro
  }
}
