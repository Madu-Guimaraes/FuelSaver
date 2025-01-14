import 'package:fl_chart/fl_chart.dart';
class ReportsController {
  final List<Map<String, dynamic>> fuelRecords;

  ReportsController(this.fuelRecords);

  // Economia Correspondente (KM/L)
  List<FlSpot> calculateEconomy(DateTime? startDate, DateTime? endDate) {
    final filteredRecords = _filterRecords(startDate, endDate);
    List<FlSpot> results = [];

    for (int i = 1; i < filteredRecords.length; i++) {
      final current = filteredRecords[i];
      final previous = filteredRecords[i - 1];

      final distance = current['odometer'] - previous['odometer'];
      final liters = current['liters'];

      if (liters != null && liters > 0) {
        final economy = distance / liters;
        results.add(FlSpot(liters, economy));
      } else {
        continue;
      }
    }

    return results;
  }

  // Comparação por Combustível
Map<String, double> calculateFuelComparison(DateTime? startDate, DateTime? endDate) {
  final filteredRecords = _filterRecords(startDate, endDate);
  Map<String, double> fuelEconomy = {};

  for (var record in filteredRecords) {
    final fuelType = record['fuelType'];
    final liters = record['liters'];
    final odometer = record['odometer'];
    final pricePerLiter = record['pricePerLiter'];

    if (liters != null && liters > 0 && odometer != null && pricePerLiter != null) {
      final distance = odometer - (filteredRecords.indexOf(record) > 0 ? filteredRecords[filteredRecords.indexOf(record) - 1]['odometer'] : 0);
      final economy = pricePerLiter / (distance / liters);

      fuelEconomy.update(fuelType, (value) => value + economy, ifAbsent: () => economy);
    }
  }

  return fuelEconomy;
}

  // Gastos Mensais
Map<String, double> calculateMonthlyExpenses() {
  Map<String, double> monthlyExpenses = {};

  for (var record in fuelRecords) {
    final month = "${record['date'].month}/${record['date'].year}";
    final expense = record['liters'] * record['pricePerLiter'];

    monthlyExpenses.update(month, (value) => value + expense, ifAbsent: () => expense);
  }

  return monthlyExpenses;
}

  // Filtra registros por data
  List<Map<String, dynamic>> _filterRecords(DateTime? startDate, DateTime? endDate) {
    return fuelRecords.where((record) {
      final date = record['date'];
      return (startDate == null || date.isAfter(startDate)) &&
             (endDate == null || date.isBefore(endDate));
    }).toList();
  }
}