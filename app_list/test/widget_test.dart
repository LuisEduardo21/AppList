import 'package:app_list/provider/CidadeProvider.dart';
import 'package:app_list/service/mock.dart';
import 'package:app_list/view/home.dart';
import 'package:app_list/view_model/home_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Testa a tela HomeScreen', (WidgetTester tester) async {
    final cidadeProvider = CidadeProvider();
    cidadeProvider.selecionarCidade("Recife");

    final homeModel = HomeModel(service: MockBaseService());

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<CidadeProvider>.value(value: cidadeProvider),
          ChangeNotifierProvider<HomeModel>.value(value: homeModel),
        ],
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text("Recife"), findsOneWidget);
    expect(find.text("Todos"), findsOneWidget);
    expect(find.text("Com Desconto"), findsOneWidget);
  });
}