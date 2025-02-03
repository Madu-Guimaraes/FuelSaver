import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  final List<DateTime> initialSelectedDates;

  const CalendarScreen({super.key, this.initialSelectedDates = const []});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _focusedDay;
  late List<DateTime> _selectedDates;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDates = List<DateTime>.from(widget.initialSelectedDates);
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;

      if (_selectedDates.length == 2) _selectedDates.clear();

      if (!_selectedDates.contains(day)) {
        _selectedDates.add(day);
      } else {
        _selectedDates.remove(day);
      }

      if (_selectedDates.length == 2) {
        _selectedDates.sort();
        _fillDateRange();
      }
    });
  }

  void _fillDateRange() {
    DateTime startDate = _selectedDates.first;
    DateTime endDate = _selectedDates.last;
    _selectedDates.clear();

    while (!startDate.isAfter(endDate)) {
      _selectedDates.add(startDate);
      startDate = startDate.add(const Duration(days: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Selecione as datas"),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, _selectedDates),
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
            onPageChanged: (focusedDay) => _focusedDay = focusedDay,
            calendarBuilders: CalendarBuilders(
              selectedBuilder: (context, date, _) => _buildSelectedDay(date),
            ),
          ),
          const SizedBox(height: 16),
          _buildButtons(context),
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

  Widget _buildSelectedDay(DateTime date) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '${date.day}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _selectedDates),
          child: const Text("OK"),
        ),
        ElevatedButton(
          onPressed: () => setState(_selectedDates.clear),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          child: const Text("Limpar"),
        ),
      ],
    );
  }

  String _formatSelectedDates() {
    return _selectedDates.isEmpty
        ? "Nenhuma data selecionada"
        : _selectedDates.map((date) => DateFormat('dd/MM/yyyy').format(date)).join(", ");
  }
}