import 'package:app_list/utils/motels.dart';
import 'package:app_list/utils/suites.dart';
import 'package:app_list/view/base_service.dart';
import 'package:app_list/view_model/home_model.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String filtroAtivo = "Todos";
  final PageController _pageController = PageController();

  void aplicarFiltro(String filtro) {
    setState(() {
      filtroAtivo = filtro;
    });
  }

  // Função para filtrar as suítes com base no filtro selecionado
  List<Suite> filtrarSuites(List<Suite> suites, String filtro) {
    switch (filtro) {
      case "Com Desconto":
        return suites.where((suite) {
          return suite.periodos.any((periodo) => periodo.desconto != null);
        }).toList();
      case "Disponíveis":
        return suites.where((suite) => suite.qtd > 0).toList();
      case "Hidro":
        return suites.where((suite) {
          return suite.itens
              .any((item) => item.nome.toLowerCase().contains("hidro"));
        }).toList();
      default:
        return suites;
    }
  }

  // Função para filtrar os motéis com base no filtro selecionado
  List<Motel> filtrarMoteis(List<Motel> motels, String filtro) {
    return motels.map((motel) {
      return Motel(
        fantasia: motel.fantasia,
        logo: motel.logo,
        bairro: motel.bairro,
        distancia: motel.distancia,
        qtdFavoritos: motel.qtdFavoritos,
        suites:
            filtrarSuites(motel.suites, filtro), // Filtra as suítes do motel
        qtdAvaliacoes: motel.qtdAvaliacoes,
        media: motel.media,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
      model: HomeModel(),
      onModelReady: (model) => model.onInit(context),
      builder: (context, model, child) {
        final motelsFiltrados = filtrarMoteis(model.listaMoteis, filtroAtivo);
        final suitesFiltradas =
            filtrarSuites(model.primeirasSuites, filtroAtivo);

        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Recife"),
                Icon(Icons.arrow_drop_down, size: 28),
              ],
            ),
            backgroundColor: Colors.redAccent,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carrossel de Suítes Filtradas
              SizedBox(
                height: 180,
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: suitesFiltradas.length,
                        itemBuilder: (context, index) {
                          final suite = suitesFiltradas[index];
                          return _buildCarrosselItem(suite);
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: suitesFiltradas.length,
                      effect: WormEffect(
                        activeDotColor: Colors.redAccent,
                        dotHeight: 8,
                        dotWidth: 8,
                      ),
                    ),
                  ],
                ),
              ),

              // Filtros
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _filtroBotao("Todos", Icons.filter_list),
                    _filtroBotao("Com Desconto", Icons.local_offer),
                    _filtroBotao("Disponíveis", Icons.check_circle),
                    _filtroBotao("Hidro", Icons.hot_tub),
                  ],
                ),
              ),

              // Lista de Motéis Filtrados
              Flexible(
                child: ListView.builder(
                  itemCount: motelsFiltrados.length,
                  itemBuilder: (context, index) {
                    final motel = motelsFiltrados[index];
                    return _buildMotelItem(motel);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget para construir um item do carrossel
  Widget _buildCarrosselItem(Suite suite) {
    final primeiroPeriodo =
        suite.periodos.isNotEmpty ? suite.periodos.first : null;
    final valorComDesconto = primeiroPeriodo?.desconto != null
        ? primeiroPeriodo!.valor *
            (1 - primeiroPeriodo.desconto!.desconto / 100)
        : null;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.horizontal(left: Radius.circular(15)),
            child: Image.network(
              suite.fotos.isNotEmpty
                  ? suite.fotos.first
                  : 'https://via.placeholder.com/120',
              height: 100,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(suite.nome,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  if (primeiroPeriodo?.desconto != null)
                    Text(
                      "🔥 ${primeiroPeriodo!.desconto!.desconto}% de desconto",
                      style: TextStyle(color: Colors.red),
                    ),
                  if (valorComDesconto != null)
                    Text(
                      "De R\$ ${primeiroPeriodo!.valor.toStringAsFixed(2)} por R\$ ${valorComDesconto.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 14),
                    ),
                  if (primeiroPeriodo != null &&
                      primeiroPeriodo.desconto == null)
                    Text(
                      "A partir de R\$ ${primeiroPeriodo.valor.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 14),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget para construir um item da lista de motéis
  Widget _buildMotelItem(Motel motel) {
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                motel.logo,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(motel.fantasia,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(motel.bairro, style: TextStyle(color: Colors.grey)),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    SizedBox(width: 4),
                    Text("${motel.media} (${motel.qtdAvaliacoes} avaliações)",
                        style: TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 450,
            child: PageView.builder(
              itemCount: motel.suites.length,
              itemBuilder: (context, index) {
                final suite = motel.suites[index];
                return _buildSuiteItem(suite, motel);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget para construir um item de suíte
  Widget _buildSuiteItem(Suite suite, Motel motel) {
    final primeiroPeriodo =
        suite.periodos.isNotEmpty ? suite.periodos.first : null;
    final valorComDesconto = primeiroPeriodo?.desconto != null
        ? primeiroPeriodo!.valor *
            (1 - primeiroPeriodo.desconto!.desconto / 100)
        : null;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagem da suíte
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              suite.fotos.isNotEmpty ? suite.fotos.first : motel.logo,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: Text(
                suite.nome,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Exibir os itens da suíte
                Wrap(
                  spacing: 8,
                  children: suite.itens
                      .take(3)
                      .map((item) => Chip(
                            label: Text(item.nome),
                            backgroundColor: Colors.grey[200],
                          ))
                      .toList(),
                ),
                if (suite.itens.length > 3)
                  TextButton(
                    onPressed: () {
                      // Navegar para uma tela que exibe todos os itens
                    },
                    child:
                        Text("ver todos", style: TextStyle(color: Colors.grey)),
                  ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("2 horas",
                        style: TextStyle(fontSize: 16, color: Colors.black54)),
                    Text(
                      valorComDesconto != null
                          ? "De R\$ ${primeiroPeriodo!.valor.toStringAsFixed(2)} por R\$ ${valorComDesconto.toStringAsFixed(2)}"
                          : "A partir de R\$ ${primeiroPeriodo?.valor.toStringAsFixed(2) ?? "Preço indisponível"}",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget para construir um botão de filtro
  Widget _filtroBotao(String texto, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 18),
        label: Text(texto),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              filtroAtivo == texto ? Colors.redAccent : Colors.grey[300],
          foregroundColor: filtroAtivo == texto ? Colors.white : Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: () => aplicarFiltro(texto),
      ),
    );
  }
}
