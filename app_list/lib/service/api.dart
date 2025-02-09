import 'dart:convert';
import 'dart:io';

import 'package:app_list/utils/motels.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class BaseService {
  static const String _apiUrl = 'https://jsonkeeper.com/b/1IXK';
  static const String _dataKey = 'data';
  static const String _moteisKey = 'moteis';

  Future<http.Response> _fetchDataWithoutSSLValidation() async {
    final HttpClient httpClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    final IOClient ioClient = IOClient(httpClient);
    return await ioClient
        .get(Uri.parse(_apiUrl))
        .timeout(const Duration(seconds: 10));
  }

  Future<List<Motel>> fetchData() async {
    try {
      final response = await _fetchDataWithoutSSLValidation();

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);

        if (decodedResponse is! Map<String, dynamic> ||
            !decodedResponse.containsKey(_dataKey) ||
            decodedResponse[_dataKey] is! Map<String, dynamic> ||
            !decodedResponse[_dataKey].containsKey(_moteisKey) ||
            decodedResponse[_dataKey][_moteisKey] is! List) {
          throw Exception("Erro: Estrutura de resposta inesperada.");
        }

        final List<dynamic> moteisJson = decodedResponse[_dataKey][_moteisKey];
        return moteisJson.map((json) => Motel.fromJson(json)).toList();
      } else {
        throw Exception(
            'Erro ao carregar os dados. Status: ${response.statusCode}, Resposta: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro ao conectar: $e');
    }
  }
}
