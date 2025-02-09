import 'package:app_list/service/api.dart';
import 'package:app_list/utils/descontos.dart';
import 'package:app_list/utils/item.dart';
import 'package:app_list/utils/motels.dart';
import 'package:app_list/utils/periodo.dart';
import 'package:app_list/utils/suites.dart';

class MockBaseService implements BaseService {
  Future<List<Motel>> getMoteis() async {
    return [
      Motel(
        fantasia: "Motel Recife",
        logo: "https://via.placeholder.com/150",
        bairro: "Boa Viagem",
        distancia: 5.0,
        qtdFavoritos: 120,
        qtdAvaliacoes: 200,
        media: 4.5,
        suites: [
          Suite(
            nome: "Suite Luxo",
            fotos: ["https://via.placeholder.com/300"],
            qtd: 2,
            periodos: [
              Periodo(
                valor: 150.0,
                desconto: Desconto(desconto: 10),
                tempoFormatado: "2h",
                tempo: "120",
                valorTotal: 150.0,
                temCortesia: false,
              ),
            ],
            itens: [
              Item(nome: "Hidromassagem"),
              Item(nome: "TV a cabo"),
            ],
            exibirQtdDisponiveis: true,
            categoriaItens: [CategoriaItem(nome: "Luxo", icone: "star")],
          ),
        ],
      ),
    ];
  }

  @override
  Future<List<Motel>> fetchData() async {
    // Implementação mock do método fetchData
    print("Dados mockados carregados com sucesso!");
    return getMoteis();
  }
}
