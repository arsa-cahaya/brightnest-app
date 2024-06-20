import 'package:brightnest_application/color_schema.dart';
import 'package:flutter/material.dart';
import 'package:brightnest_application/custom_button.dart';
import 'package:brightnest_application/pages/date_time_selection.dart';

class ServiceSelectionScreen extends StatefulWidget {
  final String name;
  final List<String> services;

  const ServiceSelectionScreen({
    super.key,
    required this.name,
    required this.services,
  });

  @override
  _ServiceSelectionScreenState createState() => _ServiceSelectionScreenState();
}

class _ServiceSelectionScreenState extends State<ServiceSelectionScreen> {
  int _selectedHours = 2;
  int _selectedProfessionals = 1;
  bool _needMaterials = false;

  void _proceedToDateTimeSelection() {
    int total = _calculateTotal();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DateTimeSelectionScreen(
          name: widget.name,
          services: widget.services,
          initialTotal: total,
          selectedHours: _selectedHours,
          selectedProfessionals: _selectedProfessionals,
          needMaterials: _needMaterials,
        ),
      ),
    );
  }

  int _calculateTotal() {
    int baseRatePerHour =
        50000; // base rate per hour for one professional in IDR
    int materialCost = 20000; // additional cost for materials in IDR
    int total = _selectedHours * _selectedProfessionals * baseRatePerHour;

    if (_needMaterials) {
      total += materialCost;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightBlue200,
        elevation: 0,
        title: const Text(
          "Langkah 1 : Pilih sesuai kebutuhan anda",
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
              'Berapa waktu yang dibutuhkan untuk pekerja kami bekerja?',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: List.generate(8, (index) {
                return ChoiceChip(
                  label: Text('${index + 1}'),
                  selected: _selectedHours == index + 1,
                  backgroundColor: Colors.transparent,
                  selectedColor: Colors.lightBlue[200],
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedHours = index + 1;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 20),
            const Text(
              'Berapa orang yang dibutuhkan untuk bekerja?',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: List.generate(4, (index) {
                return ChoiceChip(
                  label: Text('${index + 1}'),
                  selected: _selectedProfessionals == index + 1,
                  backgroundColor: Colors.transparent,
                  selectedColor: Colors.lightBlue[200],
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedProfessionals = index + 1;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 20),
            const Text(
              'Apakah anda membutuhkan material kebersihan dari kami?',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ChoiceChip(
                  label: const Text('Tidak, saya memilikinya'),
                  selected: !_needMaterials,
                  backgroundColor: Colors.transparent,
                  selectedColor: Colors.lightBlue[200],
                  onSelected: (bool selected) {
                    setState(() {
                      _needMaterials = !selected;
                    });
                  },
                ),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text('Iya, saya membutuhkan'),
                  selected: _needMaterials,
                  backgroundColor: Colors.transparent,
                  selectedColor: Colors.lightBlue[200],
                  onSelected: (bool selected) {
                    setState(() {
                      _needMaterials = selected;
                    });
                  },
                ),
              ],
            ),
            const Spacer(),
            CustomButton(
              text: 'Selanjutnya',
              onPressed: _proceedToDateTimeSelection,
            ),
          ],
        ),
      ),
    );
  }
}
