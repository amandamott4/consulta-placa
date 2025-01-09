import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Função para obter o status do veículo a partir do servidor
Future<String?> obterStatusVeiculo(String placaVeiculo) async {
  try {
    // Faz uma requisição GET para a URL fornecida, substituindo a placa do veículo na URL
    final response = await http.get(Uri.parse('http://10.63.32.45:3000/vehicle/$placaVeiculo'));

    // Verifica o código de status da resposta
    if (response.statusCode == 200) {
      // Se a resposta for bem-sucedida, decodifica o corpo da resposta
      final data = json.decode(response.body);
      return data['status']; // Retorna o status do veículo
    } else if (response.statusCode == 404) {
      return 'Veículo não encontrado'; // Retorna mensagem se o veículo não for encontrado
    } else {
      return 'Erro ao consultar o banco de dados'; // Retorna mensagem de erro genérico
    }
  } catch (e) {
    // Captura e imprime qualquer erro que ocorra durante a solicitação
    print('Erro ao fazer a solicitação: $e');
    return 'Erro ao fazer a solicitação'; // Retorna mensagem de erro em caso de exceção
  }
}

// Função principal que inicia o aplicativo Flutter
void main() {
  runApp(MyApp());
}

// Classe principal do aplicativo
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Define o tema do aplicativo
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Define a tela inicial do aplicativo
      home: HomeScreen(),
    );
  }
}

// Classe do widget da tela inicial
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// Estado associado ao widget da tela inicial
class _HomeScreenState extends State<HomeScreen> {
  // Controlador para o campo de texto
  final TextEditingController _placaController = TextEditingController();
  // Variável para armazenar o status do veículo
  String? _statusVeiculo;

  // Função para consultar o status do veículo
  Future<void> _consultarStatus() async {
    var status = await obterStatusVeiculo(_placaController.text.trim());
    // Atualiza o estado da tela com o status do veículo
    setState(() {
      _statusVeiculo = status ?? "Erro ao consultar o banco de dados";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Image.asset(
    'images/onibus.png', // Certifique-se de ter uma imagem de ônibus em assets/bus.png
    height: 300,
    ),
            SizedBox(height: 20),
            // Título do campo de pesquisa
            Text(
              '🔍 Pesquise o status do ônibus',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // Campo de entrada de texto para a placa do veículo
            TextField(
              controller: _placaController,
              decoration: InputDecoration(
                labelText: 'Placa do Veículo',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.directions_bus),
              ),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search, // Define a ação do botão do teclado como "search"
              onSubmitted: (value) {
                _consultarStatus(); // Chama a função de consulta quando o botão "Confirmar" do teclado é pressionado
              },
            ),
            SizedBox(height: 20),
            // Botão para acionar a consulta
            ElevatedButton(
              onPressed: _consultarStatus,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 20),
              ),
              child: Text('Consultar 🔍'),
            ),
            SizedBox(height: 20),
            // Exibe o status do veículo, se disponível
            if (_statusVeiculo != null) ...[
              Text(
                'Status: $_statusVeiculo',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    ));
  }
}
