import 'package:app_list/view/base_service.dart';
import 'package:app_list/view_model/home_model.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String filtroAtivo = "";

  void aplicarFiltro(String filtro) {
    setState(() {
      filtroAtivo = filtro;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
      model: HomeModel(),
      onModelReady: (model) {
        model.onInit(context);
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("Recife"),
          backgroundColor: Colors.redAccent,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carrossel
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: model.carrosselData.length,
                itemBuilder: (context, index) {
                  final item = model.carrosselData[index];
                  return Container(
                    width: 250,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 5)
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10)),
                          child: Image.network(item["imagem"]!,
                              height: 80, width: 250, fit: BoxFit.cover),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item["nome"]!,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text("${item["desconto"]} de desconto"),
                              Text("A partir de ${item["preco"]}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Filtros
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  filtroBotao("Todos"),
                  filtroBotao("Com Desconto"),
                  filtroBotao("Disponíveis"),
                ],
              ),
            ),

            // Lista de motéis
            Expanded(
              child: ListView.builder(
                itemCount: model.listaMoteis.length,
                itemBuilder: (context, index) {
                  final item = model.listaMoteis[index];
                  return Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 5)
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(10)),
                          child: Image.network(item["imagem"],
                              height: 100, width: 100, fit: BoxFit.cover),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item["nome"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                Text(item["local"],
                                    style: TextStyle(color: Colors.grey)),
                                Row(
                                  children: [
                                    Icon(Icons.star,
                                        color: Colors.amber, size: 20),
                                    SizedBox(width: 4),
                                    Text("${item["avaliacao"]}",
                                        style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Função para criar um botão de filtro
  Widget filtroBotao(String texto) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              filtroAtivo == texto ? Colors.redAccent : Colors.grey[300],
          foregroundColor: filtroAtivo == texto ? Colors.white : Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: () => aplicarFiltro(texto),
        child: Text(texto),
      ),
    );
  }
}
