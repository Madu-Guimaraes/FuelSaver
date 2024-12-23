import 'package:flutter/material.dart';
import 'package:fuel_saver/widgets/input_field.dart';
import 'package:fuel_saver/widgets/custom_button.dart';

class VehicleScreen extends StatelessWidget {
  VehicleScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //chamando img
            _buildCarImage(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    InputField(
                      label: "Tipo de Automóvel",
                      icon: Icons.directions_car,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo é obrigatório';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    InputField(
                      label: "Digite o Modelo do Automóvel",
                      icon: Icons.drive_eta,
                    ),
                    const SizedBox(height: 15),
                    InputField(
                      label: "Digite a Marca do Automóvel",
                      icon: Icons.branding_watermark,
                    ),
                    const SizedBox(height: 15),
                    InputField( //input personalizado
                      label: "Digite o Ano do Automóvel",
                      icon: Icons.calendar_today,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    CustomButton( //botão customizado
                      label: 'Adicionar mais veículos',
                      icon: Icons.add,
                      onPressed: () {
                        // Função para adicionar mais veículos
                      },
                      borderRadius: 12.0,
                    ),
                    SizedBox(height: 40, width: 200,
                      child: CustomButton(
                        label: 'Submeter',
                        color: Color(0xFF2236BD),
                        textColor: Colors.white,
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            // Ações para submeter o formulário
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//criando o widget da img
  Widget _buildCarImage() {
    return Image.asset(
      'assets/img/carro_logo.png',
      height: 220,
      width: 190,
      fit: BoxFit.cover,
    );
  }
}