import 'package:flutter/material.dart';
import 'package:fuel_saver/screens/type_fuel_screen.dart';
import 'package:fuel_saver/widgets/calendar_widget.dart';
import 'package:fuel_saver/widgets/input_field.dart';
import 'package:intl/intl.dart'; // Para formatar as datas
import 'package:fuel_saver/controllers/refuel_controller.dart'; // Importando o controlador

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
  final RefuelController refuelController = RefuelController(); // Instância do controlador

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
          // Se houver apenas uma data selecionada
          dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDates.first);
        } else if (_selectedDates.length > 1) {
          // Se houver mais de uma data selecionada
          final startDate = DateFormat('dd/MM/yyyy').format(_selectedDates.first);
          final endDate = DateFormat('dd/MM/yyyy').format(_selectedDates.last);
          dateController.text = '$startDate - $endDate';
        }
      });
    }
  }

  //função para abrir a tela de seleção de combustível
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

  // Função para calcular os litros automaticamente
  void _calculateLiters() {
    if (totalCostController.text.isEmpty || pricePerLiterController.text.isEmpty) {
      return;
    }

    try {
      final double totalCost = double.parse(totalCostController.text);
      final double pricePerLiter = double.parse(pricePerLiterController.text);

      final double liters = refuelController.calculateLiters(totalCost, pricePerLiter);
      setState(() {
        litersController.text = liters.toStringAsFixed(2);
      });
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
  };

  if (refuelController.validateRefuelData(
    odometer: refuelData["odometer"] as double,
    fuelType: refuelData["fuelType"] as String,
    pricePerLiter: refuelData["pricePerLiter"] as double,
    totalCost: refuelData["totalCost"] as double,
  )) {
    refuelController.saveRefuelData(refuelData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Dados de abastecimento salvos com sucesso!"),
        duration: const Duration(seconds: 05),
      ),
    );

    // Limpar os campos e atualizar a tela
    setState(() {
      dateController.clear();
      odometerController.clear();
      fuelTypeController.clear();
      pricePerLiterController.clear();
      totalCostController.clear();
      litersController.clear();
      _selectedDates = [];
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Dados inválidos!")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar Abastecimento", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),),
        backgroundColor: const Color(0XFFDCEDFF),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Campo para selecionar a data
              const SizedBox(height: 16),
              InputField(
                controller: dateController,
                label: "Data",
                icon: Icons.calendar_month_outlined,
                filled: false,
                borderBottom: true,
                onTap: _openCalendar,
                readOnly: true,
              ),
              const SizedBox(height: 16),
              // Campo para o odômetro
              InputField(
                controller: odometerController,
                label: "Odômetro",
                icon: Icons.speed,
                filled: false,
                borderBottom: true,
              ),
              const SizedBox(height: 16),
              // Campo para o tipo de combustível
              InputField(
                controller: fuelTypeController,
                label: "Combustível",
                icon: Icons.local_gas_station,
                filled: false,
                borderBottom: true,
                onTap: _openFuelTypeSelector,
                readOnly: true,
              ),
              const SizedBox(height: 16),
              // Campo para o preço por litro
              InputField(
                controller: pricePerLiterController,
                label: "Preço/L",
                icon: Icons.attach_money,
                filled: false,
                borderBottom: true,
                onChanged: (_) => _calculateLiters(),
              ),
              const SizedBox(height: 16),
              // Campo para o valor total abastecido
              InputField(
                controller: totalCostController,
                label: "Valor Abastecido",
                icon: Icons.money,
                filled: false,
                borderBottom: true,
                onChanged: (_) => _calculateLiters(),
              ),
              const SizedBox(height: 16),
              // Exibição dos litros calculados
              InputField(
                controller: litersController,
                label: "Litros",
                icon: Icons.local_drink,
                filled: false,
                readOnly: true, // campo somente leitura
                borderBottom: true,
              ),
              const SizedBox(height: 16),
              // Botões para salvar ou cancelar
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _saveData,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
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
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: const Text("Limpar", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}