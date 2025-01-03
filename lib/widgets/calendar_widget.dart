import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  final List<DateTime> initialSelectedDates;

  // Construtor que permite passar uma lista inicial de datas selecionadas
  const CalendarScreen({super.key, this.initialSelectedDates = const []});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _focusedDay; // Dia atualmente focado no calendário
  late List<DateTime> _selectedDates; // Lista de datas selecionadas

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now(); // Inicializa com o dia atual como foco
    _selectedDates = List<DateTime>.from(widget.initialSelectedDates); // Inicializa com as datas selecionadas passadas pelo widget
  }

  // Função chamada ao selecionar um dia no calendário
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay; // Atualiza o dia focado

      // Se já houver duas datas selecionadas, limpa a seleção e inicia uma nova
      if (_selectedDates.length == 2) {
        _selectedDates.clear();
      }

      // Adiciona ou remove a data selecionada
      if (!_selectedDates.contains(day)) {
        _selectedDates.add(day);
      } else {
        _selectedDates.remove(day);
      }

      // Se duas datas forem selecionadas, preenche o intervalo entre elas
      if (_selectedDates.length == 2) {
        _selectedDates.sort(); // Ordena as datas para garantir que estão na ordem correta
        DateTime startDate = _selectedDates.first; // Data inicial
        DateTime endDate = _selectedDates.last; // Data final

        _selectedDates.clear(); // Limpa a seleção atual para preencher o intervalo
        while (!startDate.isAfter(endDate)) {
          _selectedDates.add(startDate); // Adiciona cada data do intervalo
          startDate = startDate.add(const Duration(days: 1)); // Incrementa o dia
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Selecione as datas"), // Título da tela
        backgroundColor: Colors.blue, // Cor do AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Botão de voltar
          onPressed: () {
            Navigator.pop(context, _selectedDates); // Retorna as datas selecionadas ao fechar
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 01, 01), // Primeiro dia do calendário
              lastDay: DateTime.utc(2025, 12, 31), // Último dia do calendário
              focusedDay: _focusedDay, // Dia atualmente focado
              calendarFormat: CalendarFormat.month, // Formato do calendário (mensal)
              selectedDayPredicate: (day) => _selectedDates.contains(day), // Define quais dias estão selecionados
              onDaySelected: _onDaySelected, // Chama a função ao selecionar um dia
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay; // Atualiza o dia focado ao mudar de página
              },
              calendarBuilders: CalendarBuilders(
                selectedBuilder: (context, date, _) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.blue, // Cor de destaque para dias selecionados
                      shape: BoxShape.circle, // Formato circular
                    ),
                    child: Center(
                      child: Text(
                        '${date.day}', // Exibe o número do dia
                        style: const TextStyle(color: Colors.white), // Cor do texto
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16), // Espaçamento entre o calendário e os botões
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribui os botões uniformemente
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, _selectedDates); // Retorna as datas selecionadas
                  },
                  child: const Text("OK"), // Texto do botão
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedDates.clear(); // Limpa todas as datas selecionadas
                    });
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange), // Cor do botão
                  child: const Text("Limpar"), // Texto do botão
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0), // Margem ao redor do texto
              child: Text(
                "Datas selecionadas: ${_formatSelectedDates()}", // Exibe as datas selecionadas
                style: const TextStyle(fontSize: 16), // Estilo do texto
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Formata as datas selecionadas para exibição
  String _formatSelectedDates() {
    if (_selectedDates.isEmpty) {
      return "Nenhuma data selecionada"; // Mensagem padrão quando não há datas selecionadas
    }
    return _selectedDates
        .map((date) => DateFormat('dd/MM/yyyy').format(date)) // Converte cada data para o formato 'dd/MM/yyyy'
        .join(", "); // Junta todas as datas com uma vírgula
  }
}