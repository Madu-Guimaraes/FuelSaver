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

  List<Map<String, dynamic>> refuelDataList = [];
  List<DateTime> _selectedDates = [];
  Timer? _debounce;

  // Função debounce para evitar chamadas frequentes de cálculos
  void _onChangedDebounced(VoidCallback action) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), action);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  // Função para abrir o calendário
  void _openCalendar() async {
    final List<DateTime>? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalendarScreen(
          initialSelectedDates: _selectedDates,
        ),
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _selectedDates = result;
        if (_selectedDates.length == 1) {
          dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDates.first);
        } else if (_selectedDates.length > 1) {
          final startDate = DateFormat('dd/MM/yyyy').format(_selectedDates.first);
          final endDate = DateFormat('dd/MM/yyyy').format(_selectedDates.last);
          dateController.text = '$startDate - $endDate';
        }
      });
    }
  }

  // Função para abrir a tela de seleção de combustível
  void _openFuelTypeSelector() async {
    final selectedFuelType = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TypeFuelScreen(),
      ),
    );

    if (selectedFuelType != null) {
      setState(() {
        fuelTypeController.text = selectedFuelType;
      });
    }
  }

  // Função para calcular os litros
  void _calculateLiters() {
    if (totalCostController.text.isEmpty || pricePerLiterController.text.isEmpty) {
      return;
    }

    try {
      final double totalCost = double.parse(totalCostController.text);
      final double pricePerLiter = double.parse(pricePerLiterController.text);

      final double liters = totalCost / pricePerLiter;
      litersController.text = liters.toStringAsFixed(2);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, insira valores válidos para o cálculo!")),
      );
    }
  }

  // Função para salvar os dados de abastecimento
final RefuelController refuelController = RefuelController();

void _saveData() {
  if (odometerController.text.isEmpty ||
      fuelTypeController.text.isEmpty ||
      pricePerLiterController.text.isEmpty ||
      totalCostController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Por favor, preencha todos os campos!")),
    );
    return;
  }

  try {
    final refuelData = {
      "odometer": double.parse(odometerController.text),
      "fuelType": fuelTypeController.text,
      "pricePerLiter": double.parse(pricePerLiterController.text),
      "totalCost": double.parse(totalCostController.text),
      "liters": double.parse(litersController.text),
      "date": _selectedDates.isNotEmpty
          ? DateFormat('dd/MM/yyyy').format(_selectedDates.first)
          : '',
    };

    refuelController.saveRefuelData(refuelData); // Salva no controlador

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Dados de abastecimento salvos com sucesso!")),
    );

    _clearFields();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Erro ao salvar os dados. Verifique os campos!")),
    );
  }
}

  // Função para limpar os campos
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar Abastecimento",style: TextStyle(color: Colors.grey)),
        backgroundColor: const Color(0XFFDCEDFF),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              InputField(
                controller: dateController,
                label: "Data",
                icon: Icons.calendar_month_outlined,
                filled: false,
                borderBottom: true,
                onTap: _openCalendar,
                readOnly: true,
              ),
              InputField(
                controller: odometerController,
                label: "Odômetro",
                icon: Icons.speed,
                filled: false,
                borderBottom: true,
              ),
              InputField(
                controller: fuelTypeController,
                label: "Combustível",
                icon: Icons.local_gas_station,
                filled: false,
                borderBottom: true,
                onTap: _openFuelTypeSelector,
                readOnly: true,
              ),
              InputField(
                controller: pricePerLiterController,
                label: "Preço/L",
                icon: Icons.attach_money,
                filled: false,
                borderBottom: true,
                onChanged: (_) {
                  _onChangedDebounced(_calculateLiters);
                },
              ),
              InputField(
                controller: totalCostController,
                label: "Valor Abastecido",
                icon: Icons.money,
                filled: false,
                borderBottom: true,
                onChanged: (_) {
                  _onChangedDebounced(_calculateLiters);
                },
              ),
              InputField(
                controller: litersController,
                label: "Litros",
                icon: Icons.local_drink,
                filled: false,
                readOnly: true,
                borderBottom: true,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _saveData,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.save, color: Colors.white),
                        SizedBox(width: 8),
                        Text("Salvar", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _clearFields,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.clear, color: Colors.white),
                        SizedBox(width: 8),
                        Text("Limpar", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: refuelDataList.length,
                itemBuilder: (context, index) {
                  final refuel = refuelDataList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text("Odômetro: ${refuel['odometer']}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Combustível: ${refuel['fuelType']}"),
                          Text("Data: ${refuel['date']}"),
                          Text("Litros: ${refuel['liters']}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}