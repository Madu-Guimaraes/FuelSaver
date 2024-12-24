import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // Para formatar as datas

class CalendarScreen extends StatefulWidget {
  final List<DateTime> initialSelectedDates;

  const CalendarScreen({super.key, this.initialSelectedDates = const []});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _focusedDay;
  late List<DateTime> _selectedDates;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDates = widget.initialSelectedDates;
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      if (_selectedDates.contains(day)) {
        _selectedDates.remove(day);
      } else {
        _selectedDates.add(day);
      }

      // Se houver duas datas selecionadas, ordena e seleciona todas as datas entre elas
      if (_selectedDates.length == 2) {
        _selectedDates.sort();
        DateTime startDate = _selectedDates.first;
        DateTime endDate = _selectedDates.last;

        // Garante que as datas entre o intervalo também sejam selecionadas
        while (startDate.isBefore(endDate)) {
          startDate = startDate.add(Duration(days: 1));
          if (!_selectedDates.contains(startDate)) {
            _selectedDates.add(startDate);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Selecione as datas"),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, _selectedDates); // Retorna as datas selecionadas
          },
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 01, 01),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) => _selectedDates.contains(day),
            onDaySelected: _onDaySelected,
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: (day) {
              return _selectedDates.contains(day) ? [day] : [];
            },
            calendarBuilders: CalendarBuilders(
              selectedBuilder: (context, date, _) {
                // Cor para a data inicial e final
                if (_selectedDates.length == 2 &&
                    (_selectedDates.first.isAtSameMomentAs(date) ||
                        _selectedDates.last.isAtSameMomentAs(date))) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.blue, // Cor para a data inicial e final
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${date.day}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }
                // Cor mais clara para as datas entre a inicial e final
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.3), // Cor mais clara
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, _selectedDates); // Retorna as datas selecionadas
                },
                child: const Text("OK"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedDates.clear(); // Limpar as datas selecionadas
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text("Limpar"),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Datas selecionadas: ${_formatSelectedDates()}",
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  String _formatSelectedDates() {
    if (_selectedDates.isEmpty) {
      return "Nenhuma data selecionada";
    }
    return _selectedDates
        .map((date) => DateFormat('dd/MM/yyyy').format(date))
        .join(", ");
  }
}
