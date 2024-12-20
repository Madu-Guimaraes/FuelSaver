import 'package:flutter/material.dart';

class VehicleScreen extends StatelessWidget {
  VehicleScreen({super.key});

  final _formKey = GlobalKey<FormState>(); // Para mexer com o formulário

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            _buildCarImage(), // Função de imagem do carro
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildInputField(
                      label: "Tipo de Automóvel",
                      icon: Icons.directions_car,
                    ),
                    const SizedBox(height: 15),
                    _buildInputField(
                      label: "Digite o Modelo do Automóvel",
                      icon: Icons.drive_eta,
                    ),
                    const SizedBox(height: 15),
                    _buildInputField(
                      label: "Digite a Marca do Automóvel",
                      icon: Icons.branding_watermark,
                    ),
                    const SizedBox(height: 15),
                    _buildInputField(
                      label: "Digite o Ano do Automóvel",
                      icon: Icons.calendar_today,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    _buildAddMoreVehiclesButton(),
                    const SizedBox(height: 20),
                    _buildSubmitButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //função para criar botão de submit
  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          // Ações para submeter o formulário
        }
      },
      child: const Text('Submeter'),
    );
  }

  // Função para construir a imagem do carro
  Widget _buildCarImage() {
    return Image.asset(
      'assets/img/carro_logo.png',
      height: 150,
      width: 150,
      fit: BoxFit.cover,
    );
  }

  // Função para criar um campo de input com ícone e validação
  Widget _buildInputField({
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Este campo é obrigatório';
        }
        return null;
      },
    );
  }

  // Botão para adicionar mais veículos
  Widget _buildAddMoreVehiclesButton() {
    return ElevatedButton(
      onPressed: () {
        // Função para adicionar mais veículos
      },
      child: const Text('Adicionar mais veículos'),
    );
  }  
}