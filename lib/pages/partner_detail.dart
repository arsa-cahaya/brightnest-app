import 'package:flutter/material.dart';
import 'package:brightnest_application/pages/service_selection.dart';
import 'package:brightnest_application/color_schema.dart';

class PartnerDetailPage extends StatefulWidget {
  final String name;
  final String imagePath;
  final String description;
  final List<String> services;

  const PartnerDetailPage({
    super.key,
    required this.name,
    required this.imagePath,
    required this.description,
    required this.services,
  });

  @override
  _PartnerDetailPageState createState() => _PartnerDetailPageState();
}

class _PartnerDetailPageState extends State<PartnerDetailPage> {
  void _proceedToServiceSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceSelectionScreen(
          name: widget.name,
          services: widget.services,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: lightBlue200,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    widget.imagePath,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Deskripsi",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(widget.description),
                  const SizedBox(height: 20),
                  const Text(
                    "Layanan yang disediakan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: widget.services.map((service) {
                      return Chip(
                        label: Text(service),
                        avatar: _getServiceIcon(service),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _proceedToServiceSelection,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightBlue[200],
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }

  Icon _getServiceIcon(String service) {
    switch (service) {
      case "Layanan Kebersihan Rumah":
        return const Icon(Icons.home, color: Colors.blue);
      case "Layanan Kebersihan Kantor":
        return const Icon(Icons.business, color: Colors.blue);
      case "Layanan Kebersihan Tambahan":
        return const Icon(Icons.cleaning_services, color: Colors.blue);
      default:
        return const Icon(Icons.help, color: Colors.blue);
    }
  }
}
