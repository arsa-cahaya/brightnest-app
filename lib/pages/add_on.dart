import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:brightnest_application/custom_button.dart';
import 'package:brightnest_application/pages/checkout.dart';
import 'package:brightnest_application/color_schema.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddOnScreen extends StatefulWidget {
  final String name;
  final List<String> services;
  final int initialTotal;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final int selectedHours;
  final int selectedProfessionals;
  final bool needMaterials;

  const AddOnScreen({
    super.key,
    required this.name,
    required this.services,
    required this.initialTotal,
    required this.selectedDate,
    required this.selectedTime,
    required this.selectedHours,
    required this.selectedProfessionals,
    required this.needMaterials,
  });

  @override
  _AddOnScreenState createState() => _AddOnScreenState();
}

class _AddOnScreenState extends State<AddOnScreen> {
  final List<Map<String, dynamic>> _selectedServices = [];
  final Map<String, int> _servicePrices = {
    'Layanan Kebersihan Rumah': 75000,
    'Layanan Kebersihan Kantor': 100000,
    'Layanan Kebersihan Tambahan': 50000,
  };

  final Map<String, String> _serviceImages = {
    'Layanan Kebersihan Rumah': 'assets/image/home_cleaning.jpeg',
    'Layanan Kebersihan Kantor': 'assets/image/office_cleaning.jpeg',
    'Layanan Kebersihan Tambahan': 'assets/image/additional_cleaning.jpeg',
  };

  int _calculateTotal() {
    int total = widget.initialTotal;
    for (var service in _selectedServices) {
      total += service['Harga'] as int; // Cast to int
    }
    return total;
  }

  String _formatCurrency(int amount) {
    final format =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return format.format(amount);
  }

  void _addService(String service) {
    setState(() {
      if (!_selectedServices.any((element) => element['Layanan'] == service)) {
        _selectedServices.add({
          'Layanan': service,
          'Harga': _servicePrices[service] ?? 0,
        });
      }
    });
  }

  void _removeService(String service) {
    setState(() {
      _selectedServices.removeWhere((element) => element['Layanan'] == service);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightBlue200,
        elevation: 0,
        title: const Text(
          "Langkah 3 : Pilih layanan sesuai kebutuhan anda",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Layanan yang kami sediakan',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: widget.services.map((service) {
                        final price = _servicePrices[service] ?? 0;
                        final imagePath = _serviceImages[service] ??
                            'assets/image/placeholder.jpeg';
                        final isSelected = _selectedServices
                            .any((element) => element['Layanan'] == service);
                        return addOnCard(
                          context,
                          service,
                          'Deskripsi untuk $service',
                          price,
                          isSelected,
                          imagePath,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          CustomButton(
            text: 'Selanjutnya',
            onPressed: () async {
              User? user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutScreen(
                      name: widget.name,
                      email: user.email ?? '-',
                      selectedDate: widget.selectedDate,
                      selectedTimeSlot:
                          '${widget.selectedTime.hour.toString().padLeft(2, '0')}:${widget.selectedTime.minute.toString().padLeft(2, '0')}', // Convert TimeOfDay to String
                      selectedProfessionals: widget.selectedProfessionals,
                      selectedHours: widget.selectedHours,
                      needMaterials: widget.needMaterials,
                      totalPrice: _calculateTotal(),
                    ),
                  ),
                );
              } else {
                // Handle user not logged in
              }
            },
          ),
        ],
      ),
    );
  }

  Widget addOnCard(BuildContext context, String service, String description,
      int price, bool isSelected, String imagePath) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(10),
            ),
            child: Image.asset(
              imagePath,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(description, style: const TextStyle(fontSize: 14)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatCurrency(price),
                        style: const TextStyle(fontSize: 14)),
                    TextButton(
                      onPressed: () {
                        if (isSelected) {
                          _removeService(service);
                        } else {
                          _addService(service);
                        }
                      },
                      child: Text(isSelected ? 'Batalkan -' : 'Tambahkan +'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
