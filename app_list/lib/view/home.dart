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

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
      model: HomeModel(),
      onModelReady: (model) => model.onInit(context),
      builder: (context, model, child) {
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
              // Carrossel de suítes em destaque
              SizedBox(
                height: 180,
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: model.primeirasSuites.length,
                        itemBuilder: (context, index) {
                          final suite = model.primeirasSuites[index];
                          return _buildCarrosselItem(suite);
                        },
                      ),
                    ),
                    SizedBox(height: 8),
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: model.primeirasSuites.length,
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

              // Lista de motéis com suítes expansíveis
              Expanded(
                child: ListView.builder(
                  itemCount: model.listaMoteis.length,
                  itemBuilder: (context, index) {
                    final motel = model.listaMoteis[index];
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

  Widget _buildCarrosselItem(Suite suite) {
    final primeiroPeriodo =
        suite.periodos.isNotEmpty ? suite.periodos.first : null;

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
                        "🔥 ${primeiroPeriodo!.desconto!.desconto}% de desconto"),
                  if (primeiroPeriodo != null)
                    Text(
                        "A partir de R\$ ${primeiroPeriodo.valor.toStringAsFixed(2)}"),
                  SizedBox(height: 6),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text("Reservar"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMotelItem(Motel motel) {
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
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
        subtitle: Text(motel.bairro, style: TextStyle(color: Colors.grey)),
        trailing: IconButton(
          onPressed: () {},
          icon: Icon(Icons.favorite_border, color: Colors.grey),
        ),
        children:
            motel.suites.map((suite) => _buildSuiteItem(suite, motel)).toList(),
      ),
    );
  }

  Widget _buildSuiteItem(Suite suite, Motel motel) {
    final primeiroPeriodo =
        suite.periodos.isNotEmpty ? suite.periodos.first : null;

    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          suite.fotos.isNotEmpty ? suite.fotos.first : motel.logo,
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(suite.nome, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (primeiroPeriodo != null)
            Text("A partir de R\$ ${primeiroPeriodo.valor.toStringAsFixed(2)}"),
          Text("${suite.itens.length} itens disponíveis"),
        ],
      ),
      trailing: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text("Reservar"),
      ),
    );
  }

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
