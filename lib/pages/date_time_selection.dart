import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:brightnest_application/pages/add_on.dart';
import 'package:brightnest_application/color_schema.dart';
import 'package:brightnest_application/custom_button.dart';

class DateTimeSelectionScreen extends StatefulWidget {
  final String name;
  final List<String> services;
  final int initialTotal;
  final int selectedHours;
  final int selectedProfessionals;
  final bool needMaterials;

  const DateTimeSelectionScreen({
    super.key,
    required this.name,
    required this.services,
    required this.initialTotal,
    required this.selectedHours,
    required this.selectedProfessionals,
    required this.needMaterials,
  });

  @override
  _DateTimeSelectionScreenState createState() =>
      _DateTimeSelectionScreenState();
}

class _DateTimeSelectionScreenState extends State<DateTimeSelectionScreen> {
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  List<String> _timeSlots = [];

  @override
  void initState() {
    super.initState();
    _generateTimeSlots();
  }

  void _generateTimeSlots() {
    _timeSlots = [];
    for (int hour = 8; hour < 13; hour++) {
      _timeSlots.add('${hour.toString().padLeft(2, '0')}:00');
    }
  }

  void _proceedToAddOnScreen() {
    if (_selectedDate != null && _selectedTimeSlot != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddOnScreen(
            name: widget.name,
            services: widget.services,
            initialTotal: widget.initialTotal,
            selectedDate: _selectedDate!,
            selectedTime: TimeOfDay(
              hour: int.parse(_selectedTimeSlot!.split(':')[0]),
              minute: 0,
            ),
            selectedHours: widget.selectedHours,
            selectedProfessionals: widget.selectedProfessionals,
            needMaterials: widget.needMaterials,
          ),
        ),
      );
    } else {
      // Show an error message or toast
    }
  }

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightBlue200,
        elevation: 0,
        title: const Text(
          "Langkah 2 : Pilih hari dan waktu",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih tanggal',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime(2100),
              focusedDay: DateTime.now(),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDate, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                });
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            if (_selectedDate != null)
              Text(
                'Tanggal yang dipilih : ${_formatDate(_selectedDate!)}',
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 20),
            const Text(
              'Pilih waktu kehadiran',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 10,
                  children: _timeSlots.map((slot) {
                    return ChoiceChip(
                      label: Text(slot),
                      selected: _selectedTimeSlot == slot,
                      onSelected: (selected) {
                        setState(() {
                          _selectedTimeSlot = slot;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
            if (_selectedTimeSlot != null)
              Text(
                'Waktu yang dipilih : $_selectedTimeSlot',
                style: const TextStyle(fontSize: 16),
              ),
            CustomButton(
              text: 'Selanjutnya',
              onPressed: _proceedToAddOnScreen,
            ),
          ],
        ),
      ),
    );
  }
}
