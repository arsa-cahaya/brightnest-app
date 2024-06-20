import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:brightnest_application/color_schema.dart';
import 'package:brightnest_application/custom_button.dart';
import 'package:brightnest_application/main_page.dart';

class CheckoutScreen extends StatefulWidget {
  final String name;
  final String email;
  final DateTime selectedDate;
  final String selectedTimeSlot;
  final int selectedProfessionals;
  final int selectedHours;
  final bool needMaterials;
  final int totalPrice;

  const CheckoutScreen({
    super.key,
    required this.name,
    required this.email,
    required this.selectedDate,
    required this.selectedTimeSlot,
    required this.selectedProfessionals,
    required this.selectedHours,
    required this.needMaterials,
    required this.totalPrice,
  });

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedMethod = 'qris';

  Future<void> _saveToFirestore(BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('riwayat_pemesanan').add({
        'name': widget.name,
        'email': widget.email,
        'selectedDate': widget.selectedDate.toIso8601String(),
        'selectedTimeSlot': widget.selectedTimeSlot,
        'selectedProfessionals': widget.selectedProfessionals,
        'selectedHours': widget.selectedHours,
        'needMaterials': widget.needMaterials,
        'selectedMethod': _selectedMethod,
        'totalPrice': widget.totalPrice,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _showPaymentDialog(context);
    } catch (e) {
      print("Error saving to Firestore: $e");
      // Handle error appropriately in your app
    }
  }

  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pembayaran'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Silahkan bayar disini'),
              const SizedBox(height: 20),
              BarcodeWidget(
                barcode: Barcode.qrCode(), // Barcode type and settings
                data: 'your-data-to-encode', // Content
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Selesai Pembayaran',
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainPage(
                              email: widget.email,
                            )),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatCurrency(int amount) {
    final format =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return format.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightBlue200,
        elevation: 0,
        title: const Text(
          "Langkah 4 : Konfirmasi dan lakukan pembayaran",
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
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text('Email: ${widget.email}'),
                        Text(
                            'Tanggal booking: ${DateFormat('yyyy-MM-dd').format(widget.selectedDate)}'),
                        Text('Waktu kehadiran: ${widget.selectedTimeSlot}'),
                        Text('Jumlah pekerja: ${widget.selectedProfessionals}'),
                        Text('Waktu pekerja: ${widget.selectedHours}'),
                        Text(
                            'Material tambahan: ${widget.needMaterials ? 'Ya' : 'Tidak'}'),
                        const SizedBox(height: 10),
                        Text(
                            'Total Price: ${_formatCurrency(widget.totalPrice)}',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Metode Pembayaran:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            PaymentMethodSelector(
              selectedMethod: _selectedMethod,
              onSelectedMethod: (String selectedMethod) {
                setState(() {
                  _selectedMethod = selectedMethod;
                });
              },
            ),
            const Spacer(),
            CustomButton(
              text: 'Checkout',
              onPressed: () {
                _saveToFirestore(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodSelector extends StatefulWidget {
  final String selectedMethod;
  final ValueChanged<String> onSelectedMethod;

  const PaymentMethodSelector({
    required this.selectedMethod,
    required this.onSelectedMethod,
    Key? key,
  }) : super(key: key);

  @override
  _PaymentMethodSelectorState createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  late String _selectedMethod;

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.selectedMethod;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile(
          title: const Text('QRIS'),
          value: 'qris',
          groupValue: _selectedMethod,
          onChanged: (String? value) {
            setState(() {
              _selectedMethod = value!;
            });
            widget.onSelectedMethod(_selectedMethod);
          },
        ),
        RadioListTile(
          title: const Text('ShopeePay'),
          value: 'shopeepay',
          groupValue: _selectedMethod,
          onChanged: (String? value) {
            setState(() {
              _selectedMethod = value!;
            });
            widget.onSelectedMethod(_selectedMethod);
          },
        ),
        RadioListTile(
          title: const Text('DANA'),
          value: 'dana',
          groupValue: _selectedMethod,
          onChanged: (String? value) {
            setState(() {
              _selectedMethod = value!;
            });
            widget.onSelectedMethod(_selectedMethod);
          },
        ),
        RadioListTile(
          title: const Text('OVO'),
          value: 'ovo',
          groupValue: _selectedMethod,
          onChanged: (String? value) {
            setState(() {
              _selectedMethod = value!;
            });
            widget.onSelectedMethod(_selectedMethod);
          },
        ),
      ],
    );
  }
}
