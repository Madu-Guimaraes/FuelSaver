class ReportData {
  final DateTime date;
  final double economy; // Economia em km/l
  final double expense; // Gasto total em R$

  ReportData({
    required this.date,
    required this.economy,
    required this.expense,
  });
}