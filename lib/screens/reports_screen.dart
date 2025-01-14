import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fuel_saver/widgets/calendar_widget.dart';
import 'package:fuel_saver/controllers/reports_controller.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime? startDate;
  DateTime? endDate;
  String selectedGraph = "Selecione um Gráfico";
  
  // Passando uma lista de registros de combustível fictícios para o ReportsController
  final ReportsController reportsController = ReportsController([
    {'date': DateTime(2025, 1, 1), 'odometer': 1000, 'liters': 50, 'fuelType': 'Gasolina', 'pricePerLiter': 5.0},
    {'date': DateTime(2024, 1, 5), 'odometer': 1050, 'liters': 40, 'fuelType': 'Gasolina', 'pricePerLiter': 5.2},
    // Adicione mais registros conforme necessário
  ]);

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
                    return Text('Abast. ${value.toStringAsFixed(2)} L');
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
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    switch (value.toInt()) {
                      case 0:
                        return Text('Gasolina');
                      case 1:
                        return Text('Álcool');
                      case 2:
                        return Text('Diesel');
                      default:
                        return Text('Outro');
                    }
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text('${value.toStringAsFixed(2)} R\$');
                  },
                ),
              ),
            ),
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
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final month = DateTime(2025, value.toInt());
                    return Text('${month.month}/${month.year}');
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text('R\$ ${value.toStringAsFixed(2)}');
                  },
                ),
              ),
            ),
          ),
        );

      default:
        return const Center(child: Text("Nenhum gráfico disponível."));
    }
  }

List<FlSpot> _getGraphData() {
  if (selectedGraph == "Economia Correspondente (km/l)") {
    return reportsController.calculateEconomy(startDate, endDate);
  } else if (selectedGraph == "Comparação por Combustível") {
    final fuelComparison = reportsController.calculateFuelComparison(startDate, endDate);
    return fuelComparison.entries.map((entry) {
      int index = _getFuelTypeIndex(entry.key); 
      return FlSpot(index.toDouble(), entry.value);
    }).toList();
  } else if (selectedGraph == "Gastos Mensais Totais") {
    return reportsController.calculateMonthlyExpenses().entries.map((entry) {
      return FlSpot(double.parse(entry.key.split('/')[0]), entry.value);
    }).toList();
  }
  return [];
}

int _getFuelTypeIndex(String fuelType) {
  switch (fuelType) {
    case 'Gasolina':
      return 0;
    case 'Álcool':
      return 1;
    case 'Diesel':
      return 2;
    default:
      return 3; // Adicione mais combustíveis conforme necessário
  }
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