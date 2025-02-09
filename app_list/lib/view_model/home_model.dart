import 'package:app_list/service/api.dart';
import 'package:app_list/utils/motels.dart';
import 'package:app_list/utils/suites.dart';
import 'package:app_list/view_model/base_view_model.dart';
import 'package:flutter/material.dart';

class HomeModel extends BaseViewModel {
  final BaseService _service = BaseService();
  List<Motel> listaMoteis = [];

  List<Suite> get primeirasSuites {
    List<Suite> todasSuites = [];
    for (var motel in listaMoteis) {
      todasSuites.addAll(motel.suites);
    }
    return todasSuites.take(5).toList();
  }

  void onInit(BuildContext context) async {
    try {
      var response = await _service.fetchData();

      if (response is List<Motel>) {
        listaMoteis = response;
        notifyListeners();
      } else {
        throw Exception("Formato de resposta inválido.");
      }
    } catch (e) {
      print("Erro ao buscar dados: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao carregar dados: $e")),
      );
    }
  }
}
