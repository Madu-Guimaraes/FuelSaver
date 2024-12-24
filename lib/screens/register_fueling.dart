import 'package:flutter/material.dart';
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
  final RefuelController refuelController =
      RefuelController(); // Instância do controlador

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

  if (result != null && result.length == 2) {
    setState(() {
      // Ordena as datas para garantir que a primeira é o início e a segunda é o fim
      result.sort();

      // Gera todas as datas entre a data inicial e a final
      final startDate = result.first;
      final endDate = result.last;

      _selectedDates = [];
      for (var date = startDate;
          date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
          date = date.add(const Duration(days: 1))) {
        _selectedDates.add(date);
      }

      // Atualiza o campo de texto com o intervalo
      dateController.text =
          '${DateFormat('dd/MM/yyyy').format(startDate)} - ${DateFormat('dd/MM/yyyy').format(endDate)}';
    });
  } else if (result != null && result.length == 1) {
    setState(() {
      // Apenas uma data foi selecionada
      _selectedDates = result;
      dateController.text = DateFormat('dd/MM/yyyy').format(result.first);
    });
  }
}

  // Função para salvar os dados de abastecimento
  void _saveData() {
    if (odometerController.text.isEmpty ||
        fuelTypeController.text.isEmpty ||
        pricePerLiterController.text.isEmpty ||
        litersController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, preencha todos os campos!")),
      );
      return;
    }

    double odometer = 0.0;
    double pricePerLiter = 0.0;
    double liters = 0.0;

    try {
      odometer = double.parse(odometerController.text);
      pricePerLiter = double.parse(pricePerLiterController.text);
      liters = double.parse(litersController.text);
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
      "liters": liters,
    };

    if (refuelController.validateRefuelData(
      odometer: refuelData["odometer"] as double,
      fuelType: refuelData["fuelType"] as String,
      pricePerLiter: refuelData["pricePerLiter"] as double,
      liters: refuelData["liters"] as double,
    )) {
      final totalCost = refuelController.calculateTotalCost(
        refuelData["liters"] as double,
        refuelData["pricePerLiter"] as double,
      );
      totalCostController.text = totalCost.toStringAsFixed(2);

      refuelController.saveRefuelData(refuelData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Abastecimento salvo com sucesso!")),
      );
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
        title: const Text("Registrar Abastecimento"),
        backgroundColor: const Color(0XFFDCEDFF),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Campo para selecionar a data
              GestureDetector(
                onTap: _openCalendar,
                child: AbsorbPointer(
                  child: InputField(
                    controller: dateController,
                    label: "Data",
                    icon: Icons.calendar_month_outlined,
                    filled: false,
                    borderBottom: true,
                  ),
                ),
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
              ),
              const SizedBox(height: 16),
              // Campo para o preço por litro
              InputField(
                controller: pricePerLiterController,
                label: "Preço/L",
                icon: Icons.attach_money,
                filled: false,
                borderBottom: true,
              ),
              const SizedBox(height: 16),
              // Campo para os litros abastecidos
              InputField(
                controller: litersController,
                label: "Litros",
                icon: Icons.local_drink,
                filled: false,
                borderBottom: true,
              ),
              const SizedBox(height: 16),
              // Exibição do custo total
              InputField(
                controller: totalCostController,
                label: "Valor Total",
                icon: Icons.money,
                filled: false,
                readOnly: true, //campo somente leitura
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
                    child: const Text("Salvar"),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      //ação para cancelar
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text("Cancelar"),
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
