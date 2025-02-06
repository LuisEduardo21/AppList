import 'package:app_list/utils/suites.dart';

class Motel {
  final String fantasia;
  final String logo;
  final String bairro;
  final double distancia;
  final int qtdFavoritos;
  final List<Suite> suites;
  final int qtdAvaliacoes;
  final double media;

  Motel({
    required this.fantasia,
    required this.logo,
    required this.bairro,
    required this.distancia,
    required this.qtdFavoritos,
    required this.suites,
    required this.qtdAvaliacoes,
    required this.media,
  });
  factory Motel.fromJson(Map<String, dynamic> json) {
    return Motel(
      fantasia: json['fantasia'],
      logo: json['logo'],
      bairro: json['bairro'],
      distancia: json['distancia'],
      qtdFavoritos: json['qtdFavoritos'],
      suites: List<Suite>.from(json['suites'].map((x) => Suite.fromJson(x))),
      qtdAvaliacoes: json['qtdAvaliacoes'],
      media: json['media'],
    );
  }
}
