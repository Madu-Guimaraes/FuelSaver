import 'package:flutter/material.dart'; // Importa o pacote Flutter para criação de interfaces
import 'package:fl_chart/fl_chart.dart'; // Importa o pacote fl_chart para gráficos
import 'package:fuel_saver/widgets/calendar_widget.dart'; // Importa o widget de calendário
import 'package:fuel_saver/controllers/reports_controller.dart'; // Importando os controllers dos gráficos

// Classe principal da tela de relatórios
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key}); // Construtor com chave

  @override
  State<ReportsScreen> createState() =>
      _ReportsScreenState(); // Criação do estado da tela
}

// Estado da tela de relatórios
class _ReportsScreenState extends State<ReportsScreen> {
  DateTime? startDate; // Armazena a data inicial selecionada
  DateTime? endDate; // Armazena a data final selecionada
  String selectedGraph = "Selecione um Gráfico"; // Valor inicial do Filtro

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Estrutura principal da tela
      appBar: AppBar(
        // Barra de navegação no topo
        title: const Text(
          // Título da tela
          "Relatórios",
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
        ),
        backgroundColor: const Color(0XFFDCEDFF), // Cor do fundo da AppBar
      ),
      body: Padding(
        // Cria um padding ao redor do conteúdo
        padding: const EdgeInsets.all(16.0), // Define o padding
        child: Column(
          // Layout de coluna para os widgets
          children: [
            // Seletor de datas
            Row(
              // Alinha os widgets na horizontal
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Espaçamento entre os widgets
              children: [
                TextButton.icon(
                  // Botão com ícone e texto
                  icon: const Icon(Icons.calendar_today), // Ícone de calendário
                  label: const Text("Selecionar Datas"), // Texto do botão
                  onPressed: () async {
                    // Ação ao pressionar o botão
                    final dates =
                        await showCalendarWidget(context); // Abre o calendário
                    if (dates.isNotEmpty) {
                      // Verifica se as datas foram selecionadas
                      setState(() {
                        // Atualiza o estado da tela
                        startDate = dates[0]; // Atribui a data inicial
                        endDate = dates.length > 1
                            ? dates[1]
                            : null; // Atribui a data final
                      });
                    }
                  },
                ),
                // Envolva o Text em um Expanded para garantir que ele ocupe o espaço disponível
                Expanded(
                  child: Text(
                    endDate == null
                        ? startDate != null
                            ? _formatDate(startDate!)
                            : "Nenhuma data selecionada"
                        : "${_formatDate(startDate!)} - ${_formatDate(endDate!)}",
                    overflow: TextOverflow
                        .ellipsis, // Adiciona "..." caso o texto ultrapasse o limite
                    textAlign: TextAlign.end, // Alinha o texto à direita
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16), // Espaço entre os widgets

            // Dropdown para seleção de gráficos
            DropdownButton<String>(
              // Dropdown para selecionar o tipo de gráfico
              value: selectedGraph, // Valor selecionado
              items: [
                "Selecione um Gráfico", // Adiciona a opção "Selecione um Gráfico"
                "Economia Correspondente (km/l)",
                "Comparação por Combustível",
                "Gastos Mensais Totais",
              ].map((String value) {
                // Cria a lista de itens
                return DropdownMenuItem<String>(
                  // Cada item do dropdown
                  value: value,
                  child: Text(value), // Exibe o texto do item
                );
              }).toList(),
              onChanged: (value) {
                // Ação ao selecionar um item
                setState(() {
                  // Atualiza o estado da tela
                  selectedGraph = value!; // Atualiza o gráfico selecionado
                });
              },
            ),

            const SizedBox(height: 16), // Espaço entre os widgets

            // Exibição do gráfico baseado na seleção
            Expanded(
              // Faz com que o gráfico ocupe o espaço restante
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
    if (selectedGraph == "Selecione um Gráfico") {
      // Se não for selecionado um gráfico
      return const Center(
          child:
              Text("Por favor, selecione um gráfico.")); // Mensagem de seleção
    }
    switch (selectedGraph) {
      case "Economia Correspondente (km/l)":
        return Container(
          height: 300,
          width: 300,
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: data,
                  isCurved: true,
                  dotData: FlDotData(show: true),
                ),
              ],
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Row(
                        children: [
                          Text('${value.toStringAsFixed(1)} km/L',
                              style: TextStyle(fontSize: 10)),
                        ],
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text('Abast.${value.toInt()}',
                          style: TextStyle(fontSize: 12));
                    },
                  ),
                ),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
            ),
          ),
        );

      case "Comparação por Combustível":
        return BarChart(
          BarChartData(
            barGroups: data.map((spot) {
              return BarChartGroupData(
                x: spot.x.toInt(),
                barRods: [BarChartRodData(toY: spot.y, color: Colors.blue)],
              );
            }).toList(),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    switch (value.toInt()) {
                      case 0:
                        return Text('Gasolina', style: TextStyle(fontSize: 8));
                      case 1:
                        return Text('Etanol', style: TextStyle(fontSize: 8));
                      case 2:
                        return Text('Diesel', style: TextStyle(fontSize: 8));
                      default:
                        return Text('', style: TextStyle(fontSize: 8));
                    }
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text('${value.toStringAsFixed(1)} km/L');
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
          ),
        );

      case "Gastos Mensais Totais":
        return BarChart(
          BarChartData(
            barGroups: data.map((spot) {
              return BarChartGroupData(
                x: spot.x.toInt(),
                barRods: [BarChartRodData(toY: spot.y, color: Colors.green)],
              );
            }).toList(),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const months = [
                      'Jan',
                      'Fev',
                      'Mar',
                      'Abr',
                      'Mai',
                      'Jun',
                      'Jul',
                      'Ago',
                      'Set',
                      'Out',
                      'Nov',
                      'Dez'
                    ];
                    return Text(months[value.toInt() % 12]);
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text('R\$${value.toStringAsFixed(2)}');
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
          ),
        );

      default:
        return const Center(child: Text("Nenhum gráfico disponível."));
    }
  }

  /// Formata a data no formato dd/MM/yyyy
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}"; // Formata a data
  }

  /// Busca os dados para o gráfico com base no tipo selecionado
  List<FlSpot> fetchDataForGraph(String graphType) {
    if (graphType == "Economia Correspondente (km/l)") {
      // Dados reais para o cálculo de economia correspondente
      List<Report> reports = [
        Report(currentOdometer: 2000, previousOdometer: 1900, liters: 10),
        Report(currentOdometer: 2100, previousOdometer: 2000, liters: 8),
        Report(currentOdometer: 2200, previousOdometer: 2100, liters: 7),
      ];
      return generateData(reports); // Chama o método do controlador
    }

    if (graphType == "Comparação por Combustível") {
      // Dados simulados para comparação por combustível
      List<Report> reports = [
        Report(currentOdometer: 2000, previousOdometer: 1900, liters: 10),
        Report(currentOdometer: 2100, previousOdometer: 2000, liters: 8),
        Report(currentOdometer: 2200, previousOdometer: 2100, liters: 7),
      ];
      return generateFuelComparisonData(reports);
    }

    if (graphType == "Gastos Mensais Totais") {
      // Dados simulados para gastos mensais
      List<Report> reports = [
        Report(currentOdometer: 2000, previousOdometer: 1900, liters: 10),
        Report(currentOdometer: 2100, previousOdometer: 2000, liters: 8),
        Report(currentOdometer: 2200, previousOdometer: 2100, liters: 7),
      ];
      return generateMonthlyExpensesData(reports);
    }

    return [];
  }

  /// Método para abrir o calendário
  Future<List<DateTime>> showCalendarWidget(BuildContext context) async {
    final List<DateTime>? selectedDates = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalendarScreen(
            initialSelectedDates: []), // Abre a tela do calendário
      ),
    );

    // Verifique se há datas selecionadas e retorne uma lista vazia caso contrário
    return selectedDates ??
        []; // Retorna as datas selecionadas ou uma lista vazia
  }
}