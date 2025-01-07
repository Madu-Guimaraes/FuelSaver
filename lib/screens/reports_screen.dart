import 'package:flutter/material.dart'; // Importa o pacote Flutter para criação de interfaces
import 'package:fl_chart/fl_chart.dart'; // Importa o pacote fl_chart para gráficos
import 'package:fuel_saver/widgets/calendar_widget.dart'; // Importa o widget de calendário
import 'package:fuel_saver/screens/register_fueling.dart'; // Importa a tela de registro de abastecimento

// Classe principal da tela de relatórios
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key}); // Construtor com chave

  @override
  State<ReportsScreen> createState() => _ReportsScreenState(); // Criação do estado da tela
}

// Estado da tela de relatórios
class _ReportsScreenState extends State<ReportsScreen> {
  DateTime? startDate; // Armazena a data inicial selecionada
  DateTime? endDate; // Armazena a data final selecionada
  String selectedGraph = "Selecione um Gráfico"; // Valor inicial do gráfico

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Estrutura principal da tela
      appBar: AppBar( // Barra de navegação no topo
        title: const Text( // Título da tela
          "Relatórios",
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
        ),
        backgroundColor: const Color(0XFFDCEDFF), // Cor do fundo da AppBar
      ),
      body: Padding( // Cria um padding ao redor do conteúdo
        padding: const EdgeInsets.all(16.0), // Define o padding de 16 pixels
        child: Column( // Layout de coluna para os widgets
          children: [
            // Seletor de datas
            Row( // Alinha os widgets na horizontal
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espaçamento entre os widgets
              children: [
                TextButton.icon( // Botão com ícone e texto
                  icon: const Icon(Icons.calendar_today), // Ícone de calendário
                  label: const Text("Selecionar Datas"), // Texto do botão
                  onPressed: () async { // Ação ao pressionar o botão
                    final dates = await showCalendarWidget(context); // Abre o calendário
                    if (dates != null && dates.isNotEmpty) { // Verifica se as datas foram selecionadas
                      setState(() { // Atualiza o estado da tela
                        startDate = dates[0]; // Atribui a data inicial
                        endDate = dates.length > 1 ? dates[1] : null; // Atribui a data final
                      });
                    }
                  },
                ),
                // Exibição do intervalo de datas selecionado
                Text(
                  endDate == null
                      ? startDate != null
                          ? "${_formatDate(startDate!)}" // Formata e exibe a data inicial
                          : "Nenhuma data selecionada" // Caso não tenha data selecionada
                      : "${_formatDate(startDate!)} - ${_formatDate(endDate!)}", // Exibe intervalo de datas
                ),
              ],
            ),

            const SizedBox(height: 16), // Espaço entre os widgets

            // Dropdown para seleção de gráficos
            DropdownButton<String>( // Dropdown para selecionar o tipo de gráfico
              value: selectedGraph, // Valor selecionado
              items: [
                "Selecione um Gráfico",  // Adiciona a opção "Selecione um Gráfico"
                "Economia Correspondente (km/l)",
                "Comparação por Combustível",
                "Gastos Mensais Totais",
                "Gastos Semanais Totais",
              ].map((String value) { // Cria a lista de itens
                return DropdownMenuItem<String>( // Cada item do dropdown
                  value: value,
                  child: Text(value), // Exibe o texto do item
                );
              }).toList(),
              onChanged: (value) { // Ação ao selecionar um item
                setState(() { // Atualiza o estado da tela
                  selectedGraph = value!; // Atualiza o gráfico selecionado
                });
              },
            ),

            const SizedBox(height: 16), // Espaço entre os widgets

            // Exibição do gráfico baseado na seleção
            Expanded( // Faz com que o gráfico ocupe o espaço restante
              child: _buildGraph(), // Chama o método que constrói o gráfico
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói o gráfico com base no tipo selecionado
  Widget _buildGraph() {
    // Dados simulados para os gráficos
    final data = fetchDataForGraph(selectedGraph);

    // Exibe o gráfico ou uma mensagem, dependendo da escolha
    if (selectedGraph == "Selecione um Gráfico") { // Se não for selecionado um gráfico
      return const Center(child: Text("Por favor, selecione um gráfico.")); // Mensagem de seleção
    }

    switch (selectedGraph) {
      case "Economia Correspondente (km/l)":
        return LineChart( // Gráfico de linha
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: data, // Dados para o gráfico de linha
                isCurved: true, // Define se a linha será curva
                dotData: FlDotData(show: true), // Exibe os pontos no gráfico
              ),
            ],
          ),
        );

      case "Comparação por Combustível":
        return BarChart( // Gráfico de barras
          BarChartData(
            barGroups: data
                .map(
                  (spot) => BarChartGroupData(
                    x: spot.x.toInt(),
                    barRods: [BarChartRodData(toY: spot.y, color: Colors.blue)], // Cor da barra
                  ),
                )
                .toList(),
          ),
        );

      case "Gastos Mensais Totais":
      case "Gastos Semanais Totais":
        return LineChart( // Gráfico de linha
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: data, // Dados para o gráfico de linha
                isCurved: true, // Define se a linha será curva
                dotData: FlDotData(show: true), // Exibe os pontos no gráfico
              ),
            ],
          ),
        );

      default:
        return const Center(child: Text("Nenhum gráfico disponível.")); // Caso nenhum gráfico seja selecionado
    }
  }

  /// Formata a data no formato dd/MM/yyyy
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}"; // Formata a data
  }

  /// Simula a busca de dados para o gráfico com base no tipo selecionado
  List<FlSpot> fetchDataForGraph(String graphType) {
    // Aqui você integraria os dados reais do register_fuelling.dart
    switch (graphType) {
      case "Economia Correspondente (km/l)":
        return [FlSpot(1, 15), FlSpot(2, 14), FlSpot(3, 13), FlSpot(4, 16)]; // Dados simulados
      case "Comparação por Combustível":
        return [FlSpot(1, 10), FlSpot(2, 20), FlSpot(3, 30)]; // Dados simulados
      case "Gastos Mensais Totais":
        return [FlSpot(1, 200), FlSpot(2, 250), FlSpot(3, 300)]; // Dados simulados
      case "Gastos Semanais Totais":
        return [FlSpot(1, 50), FlSpot(2, 70), FlSpot(3, 100)]; // Dados simulados
      default:
        return []; // Retorna lista vazia caso o gráfico não tenha dados
    }
  }

  /// Método para abrir o calendário
  Future<List<DateTime>> showCalendarWidget(BuildContext context) async {
    final List<DateTime>? selectedDates = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalendarScreen(initialSelectedDates: []), // Abre a tela do calendário
      ),
    );

    // Verifique se há datas selecionadas e retorne uma lista vazia caso contrário
    return selectedDates ?? []; // Retorna as datas selecionadas ou uma lista vazia
  }
}