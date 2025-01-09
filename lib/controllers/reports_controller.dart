import 'package:fl_chart/fl_chart.dart';

class Report {
  final int currentOdometer;
  final int previousOdometer;
  final double liters;

  Report({
    required this.currentOdometer,
    required this.previousOdometer,
    required this.liters,
  });
}

List<FlSpot> generateData(List<Report> reports) {
  return reports.map((report) {
    double distance = (report.currentOdometer - report.previousOdometer).toDouble();
    double economy = distance / report.liters;
    return FlSpot(report.currentOdometer.toDouble(), economy);
  }).toList();
}

List<FlSpot> generateFuelComparisonData(List<Report> reports) {
  return reports.map((report) {
    double distance = (report.currentOdometer - report.previousOdometer).toDouble();
    double economy = distance / report.liters;
    double costPerKm = 5.0 / economy; // Exemplo de preço por litro
    return FlSpot(report.currentOdometer.toDouble(), costPerKm);
  }).toList();
}

List<FlSpot> generateMonthlyExpensesData(List<Report> reports) {
  return reports.map((report) {
    double distance = (report.currentOdometer - report.previousOdometer).toDouble();
    double economy = distance / report.liters;
    double monthlyExpense = report.liters * 5.0; // Exemplo de preço por litro
    return FlSpot(report.currentOdometer.toDouble(), monthlyExpense);
  }).toList();
}
