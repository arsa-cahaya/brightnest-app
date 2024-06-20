import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:brightnest_application/color_schema.dart';

class DetailProfilPage extends StatelessWidget {
  final String name;
  final String fullName;
  final String npm;
  final String birthPlace;
  final String birthDate;
  final String phone;
  final String email;
  final String githubLink;
  final String education;
  final String imagePath;

  const DetailProfilPage({
    super.key,
    required this.name,
    required this.fullName,
    required this.npm,
    required this.birthPlace,
    required this.birthDate,
    required this.phone,
    required this.email,
    required this.githubLink,
    required this.education,
    required this.imagePath,
  });

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightBlue200,
        elevation: 0,
        title: Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(imagePath),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  fullName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  education,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'NPM: $npm',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Tempat Lahir: $birthPlace',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Tanggal Lahir: $birthDate',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'No. HP: $phone',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Email: $email',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () => _launchURL(githubLink),
                child: Text(
                  githubLink,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
