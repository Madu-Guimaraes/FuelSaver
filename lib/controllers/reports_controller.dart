class RefuelController {
  // Supondo que você tenha uma lista de registros de abastecimento
  List<Map<String, dynamic>> refuels = [
    {
      'liters': 50.0,
      'odometer': 12000.0,
      'pricePerLiter': 5.0,
      'date': DateTime.now(),
    },
    // Outros registros
  ];

  List<Map<String, dynamic>> filterRefuels({DateTime? startDate, DateTime? endDate}) {
    return refuels.where((refuel) {
      final date = refuel['date'];
      return (startDate == null || date.isAfter(startDate)) &&
          (endDate == null || date.isBefore(endDate));
    }).toList();
  }
}