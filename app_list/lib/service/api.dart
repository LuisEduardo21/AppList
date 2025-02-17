import 'dart:convert';
import 'dart:io';

import 'package:app_list/utils/motels.dart';
import 'package:html_unescape/html_unescape.dart';
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
    final response = await ioClient
        .get(Uri.parse(_apiUrl))
        .timeout(const Duration(seconds: 10));

    return http.Response.bytes(
      response.bodyBytes,
      response.statusCode,
      headers: response.headers,
      request: response.request,
    );
  }

  Future<List<Motel>> fetchData() async {
    try {
      final response = await _fetchDataWithoutSSLValidation();

      if (response.statusCode == 200) {
        final decodedResponse =
            jsonDecode(utf8.decode(latin1.encode(response.body)));

        print('Dados recebidos: $decodedResponse');

        if (decodedResponse is! Map<String, dynamic> ||
            !decodedResponse.containsKey(_dataKey) ||
            decodedResponse[_dataKey] is! Map<String, dynamic> ||
            !decodedResponse[_dataKey].containsKey(_moteisKey) ||
            decodedResponse[_dataKey][_moteisKey] is! List) {
          throw Exception("Erro: Estrutura de resposta inesperada.");
        }

        final List<dynamic> moteisJson = decodedResponse[_dataKey][_moteisKey];
        final unescape = HtmlUnescape();

        return moteisJson.map((json) {
          // Decodifica os campos de texto
          json['fantasia'] = unescape.convert(json['fantasia'] ?? '');
          json['bairro'] = unescape.convert(json['bairro'] ?? '');
          if (json['suites'] != null) {
            for (var suite in json['suites']) {
              suite['nome'] = unescape.convert(suite['nome'] ?? '');
              if (suite['itens'] != null) {
                for (var item in suite['itens']) {
                  item['nome'] = unescape.convert(item['nome'] ?? '');
                }
              }
            }
          }
          return Motel.fromJson(json);
        }).toList();
      } else {
        throw Exception(
            'Erro ao carregar os dados. Status: ${response.statusCode}, Resposta: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro ao conectar: $e');
    }
  }
}
