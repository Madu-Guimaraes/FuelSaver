import 'package:flutter/material.dart';
import 'package:fuel_saver/widgets/input_field.dart';
import 'package:fuel_saver/widgets/custom_button.dart';
import 'package:fuel_saver/widgets/calendar_widget.dart'; 

class RegisterFueling extends StatelessWidget {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController odometerController = TextEditingController();
  final TextEditingController fuelTypeController = TextEditingController();
  final TextEditingController pricePerLiterController = TextEditingController();
  final TextEditingController totalCostController = TextEditingController();
  final TextEditingController litersController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF96C0E2),
        title: const Text(
          "Abastecimento",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Ação para salvar
            },
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Adiciona a rolagem e impede que o teclado empurre o conteudo pra cima
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  // Quando o campo de data for tocado, abrir o calendário
                  DateTime? selectedDate = await showDialog<DateTime>(
                    context: context,
                    builder: (BuildContext context) {
                      return DateRangePicker(); // Exibe o calendário
                    },
                  );
                  if (selectedDate != null) {
                    dateController.text = selectedDate.toLocal().toString().split(' ')[0]; // Formata a data
                  }
                },
                child: InputField(
                  label: "Data",
                  icon: Icons.calendar_today,
                  keyboardType: TextInputType.datetime,
                  controller: dateController,
                ),
              ),
              const SizedBox(height: 16),
              InputField(
                label: "Odômetro",
                icon: Icons.speed,
                keyboardType: TextInputType.number,
                controller: odometerController,
              ),
              const SizedBox(height: 16),
              InputField(
                label: "Combustível",
                icon: Icons.local_gas_station,
                controller: fuelTypeController,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      label: "Preço/L",
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      controller: pricePerLiterController,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InputField(
                      label: "Valor Total",
                      icon: Icons.money,
                      keyboardType: TextInputType.number,
                      controller: totalCostController,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InputField(
                      label: "Litros",
                      icon: Icons.local_drink,
                      keyboardType: TextInputType.number,
                      controller: litersController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Está completando o tanque?",
                    style: TextStyle(fontSize: 16),
                  ),
                  Switch(
                    value: false,
                    onChanged: (value) {
                      true;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 125),
              CustomButton(
                label: "Cancelar",
                onPressed: () {
                  // Ação para cancelar;
                },
                color: Colors.red,
                textColor: Colors.white,
                icon: Icons.cancel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
