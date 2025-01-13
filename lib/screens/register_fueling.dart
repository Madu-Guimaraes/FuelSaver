import 'package:flutter/material.dart';
import 'package:fuel_saver/screens/type_fuel_screen.dart';
import 'package:fuel_saver/widgets/calendar_widget.dart';
import 'package:fuel_saver/widgets/input_field.dart';
import 'package:intl/intl.dart'; // Para formatar as datas

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

  List<Map<String, dynamic>> refuelDataList = []; // Lista para armazenar os dados de abastecimento
  List<DateTime> _selectedDates = [];

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

  // Função para calcular os litros automaticamente sem setState
  void _calculateLiters() {
    if (totalCostController.text.isEmpty || pricePerLiterController.text.isEmpty) {
      return;
    }

    try {
      final double totalCost = double.parse(totalCostController.text);
      final double pricePerLiter = double.parse(pricePerLiterController.text);

      final double liters = totalCost / pricePerLiter;
      litersController.text = liters.toStringAsFixed(2); // Atualiza diretamente sem setState
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, insira valores válidos para o cálculo!")),
      );
    }
  }

  // Função para salvar os dados de abastecimento
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

    double odometer = 0.0;
    double pricePerLiter = 0.0;
    double totalCost = 0.0;

    try {
      odometer = double.parse(odometerController.text);
      pricePerLiter = double.parse(pricePerLiterController.text);
      totalCost = double.parse(totalCostController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, insira valores válidos!")),
      );
      return;
    }

    final refuelData = {
      "odometer": odometer,
      "fuelType": fuelTypeController.text,
      "pricePerLiter": pricePerLiter,
      "totalCost": totalCost,
      "liters": double.parse(litersController.text),
      "date": _selectedDates.isNotEmpty
          ? DateFormat('dd/MM/yyyy').format(_selectedDates.first)
          : '',
    };

    // Adicionando os dados à lista
    setState(() {
      refuelDataList.add(refuelData);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Dados de abastecimento salvos com sucesso!"),
        duration: const Duration(seconds: 5),
      ),
    );

    // Limpar os campos
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
        title: const Text("Registrar Abastecimento"),
        backgroundColor: const Color(0XFFDCEDFF),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Campos para inserir os dados
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
                onChanged: (_) => _calculateLiters(),
              ),
              InputField(
                controller: totalCostController,
                label: "Valor Abastecido",
                icon: Icons.money,
                filled: false,
                borderBottom: true,
                onChanged: (_) => _calculateLiters(),
              ),
              InputField(
                controller: litersController,
                label: "Litros",
                icon: Icons.local_drink,
                filled: false,
                readOnly: true,
                borderBottom: true,
              ),
              // Botões
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _saveData,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("Salvar", style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        dateController.clear();
                        odometerController.clear();
                        fuelTypeController.clear();
                        pricePerLiterController.clear();
                        totalCostController.clear();
                        litersController.clear();
                        _selectedDates = [];
                      });
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: const Text("Limpar", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              // Exibir dados salvos (opcional)
              const SizedBox(height: 20),
              Text("Dados Salvos:"),
              ListView.builder(
                shrinkWrap: true,
                itemCount: refuelDataList.length,
                itemBuilder: (context, index) {
                  final refuel = refuelDataList[index];
                  return ListTile(
                    subtitle: Text("Odômetro: ${refuel['odometer']} - Combustível: ${refuel['fuelType']} - Data: ${refuel['date']} - Litros: ${refuel['liters']}"),
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