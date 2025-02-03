import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fuel_saver/screens/type_fuel_screen.dart';
import 'package:fuel_saver/widgets/calendar_widget.dart';
import 'package:fuel_saver/widgets/input_field.dart';
import 'package:fuel_saver/controllers/refuel_controller.dart';
import 'package:intl/intl.dart';

class RegisterFueling extends StatefulWidget {
  const RegisterFueling({super.key});

  @override
  _RegisterFuelingState createState() => _RegisterFuelingState();
}

class _RegisterFuelingState extends State<RegisterFueling> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController odometerController = TextEditingController();
  final TextEditingController fuelTypeController = TextEditingController();
  final TextEditingController pricePerLiterController = TextEditingController();
  final TextEditingController totalCostController = TextEditingController();
  final TextEditingController litersController = TextEditingController();

  List<DateTime> _selectedDates = [];
  Timer? _debounce;
  final RefuelController refuelController = RefuelController();

  void _onChangedDebounced(VoidCallback action) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), action);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _openCalendar() async {
    final result = await Navigator.push<List<DateTime>>(
      context,
      MaterialPageRoute(builder: (context) => CalendarScreen(initialSelectedDates: _selectedDates)),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        _selectedDates = result;
        dateController.text = _formatDateRange(_selectedDates);
      });
    }
  }

  String _formatDateRange(List<DateTime> dates) {
    if (dates.length == 1) return DateFormat('dd/MM/yyyy').format(dates.first);
    return "${DateFormat('dd/MM/yyyy').format(dates.first)} - ${DateFormat('dd/MM/yyyy').format(dates.last)}";
  }

  void _openFuelTypeSelector() async {
    final selectedFuelType = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const TypeFuelScreen()),
    );
    if (selectedFuelType != null) {
      setState(() => fuelTypeController.text = selectedFuelType);
    }
  }

  void _calculateLiters() {
    if (totalCostController.text.isEmpty || pricePerLiterController.text.isEmpty) return;
    try {
      final double totalCost = double.parse(totalCostController.text);
      final double pricePerLiter = double.parse(pricePerLiterController.text);
      litersController.text = (totalCost / pricePerLiter).toStringAsFixed(2);
    } catch (e) {
      _showSnackbar("Por favor, insira valores válidos para o cálculo!");
    }
  }

  void _saveData() {
    if (_areFieldsEmpty()) {
      _showSnackbar("Por favor, preencha todos os campos!");
      return;
    }
    try {
      refuelController.saveRefuelData({
        "odometer": double.parse(odometerController.text),
        "fuelType": fuelTypeController.text,
        "pricePerLiter": double.parse(pricePerLiterController.text),
        "totalCost": double.parse(totalCostController.text),
        "liters": double.parse(litersController.text),
        "date": _selectedDates.isNotEmpty ? DateFormat('dd/MM/yyyy').format(_selectedDates.first) : '',
      });
      _showSnackbar("Dados de abastecimento salvos com sucesso!");
      _clearFields();
    } catch (e) {
      _showSnackbar("Erro ao salvar os dados. Verifique os campos!");
    }
  }

  bool _areFieldsEmpty() => odometerController.text.isEmpty || fuelTypeController.text.isEmpty ||
      pricePerLiterController.text.isEmpty || totalCostController.text.isEmpty;

  void _clearFields() {
    setState(() {
      dateController.clear();
      odometerController.clear();
      fuelTypeController.clear();
      pricePerLiterController.clear();
      totalCostController.clear();
      litersController.clear();
      _selectedDates = [];
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Abastecimento", style: TextStyle(color: Colors.grey)), backgroundColor: const Color(0XFFDCEDFF)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          InputField(controller: dateController, label: "Data", icon: Icons.calendar_month_outlined, onTap: _openCalendar, readOnly: true),
          SizedBox(height: 10),
          InputField(controller: odometerController, label: "Odômetro", icon: Icons.speed),
          SizedBox(height: 10),
          InputField(controller: fuelTypeController, label: "Combustível", icon: Icons.local_gas_station, onTap: _openFuelTypeSelector, readOnly: true),
          SizedBox(height: 10),
          InputField(controller: pricePerLiterController, label: "Preço/L", icon: Icons.attach_money, onChanged: (_) => _onChangedDebounced(_calculateLiters)),
          SizedBox(height: 10),
          InputField(controller: totalCostController, label: "Valor Abastecido", icon: Icons.money, onChanged: (_) => _onChangedDebounced(_calculateLiters)),
          SizedBox(height: 10),
          InputField(controller: litersController, label: "Litros", icon: Icons.local_drink, readOnly: true),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            _buildButton("Salvar", Icons.save, Colors.green, _saveData),
            const SizedBox(width: 16),
            _buildButton("Limpar", Icons.clear, Colors.orange, _clearFields),
          ]),
        ]),
      ),
    );
  }

  Widget _buildButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: Colors.white), const SizedBox(width: 8), Text(text, style: const TextStyle(color: Colors.white))]),
    );
  }
}