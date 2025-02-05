import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class BaseService {
  final String apiUrl = 'https://jsonkeeper.com/b/1IXK';

  // Função personalizada para criar um cliente HTTP que ignora a verificação SSL
  Future<http.Response> _fetchDataWithoutSSLValidation() async {
    final HttpClient httpClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    final IOClient ioClient = IOClient(httpClient);
    return await ioClient.get(Uri.parse(apiUrl));
  }

  Future<dynamic> fetchData() async {
    try {
      // Faz a requisição com a validação de certificado ignorada
      final response = await _fetchDataWithoutSSLValidation();
      print(response.body);

      if (response.statusCode == 200) {
        // Tente fazer a decodificação do JSON
        final decodedResponse = jsonDecode(response.body);

        if (decodedResponse is List) {
          return decodedResponse;
        } else if (decodedResponse is Map) {
          print("${decodedResponse}");
          return decodedResponse;
        } else {
          throw Exception('Formato de dados inesperado');
        }
      } else {
        throw Exception(
            'Erro ao carregar os dados. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao conectar: $e');
    }
  }
}
