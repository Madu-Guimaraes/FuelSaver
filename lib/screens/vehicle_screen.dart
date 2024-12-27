import 'package:flutter/material.dart';
import 'package:fuel_saver/widgets/input_field.dart';
import 'package:fuel_saver/widgets/custom_button.dart';
import 'package:fuel_saver/controllers/vehicle_controller.dart';

class VehicleScreen extends StatefulWidget {
  const VehicleScreen({super.key});

  @override
  _VehicleScreenState createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final VehicleController _vehicleController = VehicleController();

  // Controladores para os campos de texto fixos
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  // Lista para os inputs adicionais
  List<Map<String, dynamic>> additionalInputs = [];

  // Função para adicionar novos inputs
  void _addVehicleInput() {
    setState(() {
      additionalInputs.add({
        'modelController': TextEditingController(),
        'brandController': TextEditingController(),
        'yearController': TextEditingController(),
      });
    });
  }

  // Função para limpar todos os inputs adicionais
  void _clearAllAdditionalInputs() {
    setState(() {
      additionalInputs.clear();
    });
  }

  // Função para limpar todos os inputs, incluindo os fixos
  void _clearAllInputs() {
    setState(() {
      _modelController.clear();
      _brandController.clear();
      _yearController.clear();
      additionalInputs.clear();
    });
  }

  // Função para submeter os dados
  void _submitData() {
    if (_formKey.currentState?.validate() ?? false) {
      // Captura os dados do input fixo
      List<Map<String, dynamic>> vehiclesData = [
        {
          'model': _modelController.text,
          'brand': _brandController.text,
          'year': _yearController.text,
        },
      ];

      // Captura os dados dos inputs adicionais
      for (var input in additionalInputs) {
        vehiclesData.add({
          'model': input['modelController'].text,
          'brand': input['brandController'].text,
          'year': input['yearController'].text,
        });
      }

      // Envia os dados para o controlador
      for (var vehicleData in vehiclesData) {
        _vehicleController.addVehicle(vehicleData);
      }

      // Exibe mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Dados do(s) automóvel(is) salvos com sucesso!")),
      );

      // Limpa todos os inputs
      _clearAllInputs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCarImage(), // Imagem do carro
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Inputs fixos
                    InputField(
                      label: "Digite o Modelo do Automóvel",
                      icon: Icons.drive_eta,
                      borderBottom: false,
                      controller: _modelController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo é obrigatório';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    InputField(
                      label: "Digite a Marca do Automóvel",
                      icon: Icons.branding_watermark,
                      borderBottom: false,
                      controller: _brandController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo é obrigatório';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    InputField(
                      label: "Digite o Ano do Automóvel",
                      icon: Icons.calendar_today,
                      borderBottom: false,
                      keyboardType: TextInputType.number,
                      controller: _yearController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo é obrigatório';
                        }
                        if (!RegExp(r'^\d{4}$').hasMatch(value)) {
                          return 'O ano deve ser no formato AAAA';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Inputs adicionais
                    ...additionalInputs.map((input) {
                      return Column(
                        children: [
                          InputField(
                            label: "Digite o Modelo do Automóvel",
                            icon: Icons.drive_eta,
                            borderBottom: false,
                            controller: input['modelController'],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Este campo é obrigatório';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          InputField(
                            label: "Digite a Marca do Automóvel",
                            icon: Icons.branding_watermark,
                            borderBottom: false,
                            controller: input['brandController'],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Este campo é obrigatório';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          InputField(
                            label: "Digite o Ano do Automóvel",
                            icon: Icons.calendar_today,
                            borderBottom: false,
                            keyboardType: TextInputType.number,
                            controller: input['yearController'],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Este campo é obrigatório';
                              }
                              if (!RegExp(r'^\d{4}$').hasMatch(value)) {
                                return 'O ano deve ser no formato AAAA';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    }),

                    // Botão "X" para limpar todos os inputs adicionais
                    if (additionalInputs.isNotEmpty)
                      Center(
                        child: FloatingActionButton(
                          mini: true,
                          onPressed: _clearAllAdditionalInputs,
                          child: const Icon(Icons.close),
                        ),
                      ),

                    // Botão para adicionar mais veículos
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: _addVehicleInput,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add),
                          const SizedBox(width: 8),
                          const Text('Adicionar mais veículos'),
                        ],
                      ),
                    ),

                    // Botão para submeter
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      width: 200,
                      child: CustomButton(
                        label: 'Submeter',
                        color: const Color(0xFF2236BD),
                        textColor: Colors.white,
                        onPressed: _submitData,
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

  // Função para exibir a imagem do carro
  Widget _buildCarImage() {
    return Image.asset(
      'assets/img/carro_logo.png',
      height: 220,
      width: 190,
      fit: BoxFit.cover,
    );
  }
}
