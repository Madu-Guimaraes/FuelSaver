import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fuel_saver/widgets/calendar_widget.dart';
import 'package:intl/intl.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

//exemplo mokado
class RefuelController {
  List<Map<String, dynamic>> getAllRefuelData() {
    return [
      {'date': '25/12/2024', 'fuelType': 'Gasolina', 'liters': 20},
      {'date': '26/12/2024', 'fuelType': 'Álcool', 'liters': 15},
    ];
  }
}


class _ReportScreenState extends State<ReportScreen> {
  final RefuelController _refuelController = RefuelController();
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedFuelType;

  List<Map<String, dynamic>> _filteredData = [];

  void _filterData() {
    final allData = _refuelController.getAllRefuelData();
    setState(() {
      _filteredData = allData.where((entry) {
        final entryDate = DateFormat('dd/MM/yyyy').parse(entry['date']);
        final isWithinDateRange = _startDate != null &&
            _endDate != null &&
            entryDate.isAfter(_startDate!.subtract(const Duration(days: 1))) &&
            entryDate.isBefore(_endDate!.add(const Duration(days: 1)));
        final isFuelTypeMatch = _selectedFuelType == null ||
            entry['fuelType'] == _selectedFuelType;
        return isWithinDateRange && isFuelTypeMatch;
      }).toList();
    });
  }

  void _selectDateRange() async {
    final List<DateTime>? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalendarScreen(),
      ),
    );

    if (result != null && result.length == 2) {
      setState(() {
        _startDate = result.first;
        _endDate = result.last;
      });
      _filterData();
    }
  }

  Widget _buildBarChart() {
    if (_filteredData.isEmpty) {
      return const Center(
        child: Text("Nenhum dado disponível para o filtro selecionado."),
      );
    }

    final List<BarChartGroupData> barGroups = _filteredData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data['liters'],
            color: Colors.blue,
          ),
        ],
      );
    }).toList();

    return BarChart(
      BarChartData(
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < _filteredData.length) {
                  return Text(
                    DateFormat('dd/MM').format(
                      DateFormat('dd/MM/yyyy').parse(_filteredData[index]['date']),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
        ),
        barGroups: barGroups,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Relatórios"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _selectDateRange,
                  child: const Text("Selecionar Datas"),
                ),
                DropdownButton<String>(
                  value: _selectedFuelType,
                  hint: const Text("Selecione o combustível"),
                  items: ['Gasolina', 'Álcool', 'Diesel'].map((fuelType) {
                    return DropdownMenuItem(
                      value: fuelType,
                      child: Text(fuelType),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFuelType = value;
                    });
                    _filterData();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _buildBarChart(),
            ),
          ],
        ),
      ),
    );
  }
}
