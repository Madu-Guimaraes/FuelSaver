import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fuel_saver/widgets/calendar_widget.dart';
import 'package:fuel_saver/controllers/refuel_controller.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime? startDate;
  DateTime? endDate;
  String selectedGraph = "Selecione um Gráfico";
  final RefuelController refuelController = RefuelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Relatórios",
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
        ),
        backgroundColor: const Color(0XFFDCEDFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: const Text("Selecionar Datas"),
                  onPressed: () async {
                    final dates = await showCalendarWidget(context);
                    if (dates.isNotEmpty) {
                      setState(() {
                        startDate = dates[0];
                        endDate = dates.length > 1 ? dates[1] : null;
                      });
                    }
                  },
                ),
                Expanded(
                  child: Text(
                    endDate == null
                        ? startDate != null
                            ? _formatDate(startDate!)
                            : "Nenhuma data selecionada"
                        : "${_formatDate(startDate!)} - ${_formatDate(endDate!)}",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: selectedGraph,
              items: [
                "Selecione um Gráfico",
                "Economia Correspondente (km/l)",
                "Comparação por Combustível",
                "Gastos Mensais Totais",
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGraph = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _buildGraph(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGraph() {
    final data = _getGraphData();

    if (selectedGraph == "Selecione um Gráfico") {
      return const Center(child: Text("Por favor, selecione um gráfico."));
    }

    switch (selectedGraph) {
      case "Economia Correspondente (km/l)":
        return LineChart(
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
                    return Text('${value.toStringAsFixed(1)} km/L');
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text('Abast.${value.toInt()}');
                  },
                ),
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
                barRods: [BarChartRodData(toY: spot.y)],
              );
            }).toList(),
          ),
        );

      case "Gastos Mensais Totais":
        return BarChart(
          BarChartData(
            barGroups: data.map((spot) {
              return BarChartGroupData(
                x: spot.x.toInt(),
                barRods: [BarChartRodData(toY: spot.y)],
              );
            }).toList(),
          ),
        );

      default:
        return const Center(child: Text("Nenhum gráfico disponível."));
    }
  }

List<FlSpot> _getGraphData() {
  // Filtrando os dados com base nas datas selecionadas
  final filteredData = refuelController.filterRefuels(
    startDate: startDate,
    endDate: endDate,
  );

  List<FlSpot> graphData = [];
  
  // Ajustando o cálculo dos dados para o gráfico
  for (var entry in filteredData) {
    final double liters = entry['liters'];
    final double odometer = entry['odometer'];
    final double pricePerLiter = entry['pricePerLiter']; // Obtendo o preço do combustível diretamente

    // Aqui, você pode ajustar a lógica para refletir o gráfico desejado
    graphData.add(FlSpot(odometer, liters / pricePerLiter)); // Exemplo: Dividir litros pelo preço do combustível
  }

  return graphData;
}

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  Future<List<DateTime>> showCalendarWidget(BuildContext context) async {
    final List<DateTime>? selectedDates = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalendarScreen(initialSelectedDates: []),
      ),
    );
    return selectedDates ?? [];
  }
}