import 'package:flutter/material.dart';
import 'package:brightnest_application/color_schema.dart';
import 'about_us_detail.dart';

class TentangKamiPage extends StatelessWidget {
  const TentangKamiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightBlue200,
        elevation: 0,
        title: const Text(
          "Tentang Kami",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Image.asset('assets/image/bg_asalusul.png'),
              const SizedBox(height: 20),
              const Text(
                "Asal Usul BrightNest",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "BrightNest adalah aplikasi pemesanan layanan kebersihan yang dibangun sebagai proyek akhir untuk mata kuliah Pemrograman Mobile. Aplikasi ini dirancang dengan tujuan utama untuk mengefisiensi waktu para pengguna, terutama ketika mereka tidak memiliki cukup waktu untuk membersihkan rumah. Dengan BrightNest, pengguna dapat dengan mudah memesan layanan kebersihan yang profesional dan andal, sehingga rumah tetap bersih tanpa mengorbankan waktu berharga mereka. Aplikasi ini hadir untuk memberikan solusi praktis dan efektif dalam menjaga kebersihan rumah di tengah kesibukan sehari-hari.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildFounderCard(
                context,
                name: "Arsa Cahaya Pradipta",
                imagePath: 'assets/image/arsa.png',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailProfilPage(
                        name: "Arsa Cahaya Pradipta",
                        fullName: "Arsa Cahaya Pradipta",
                        npm: "22082010015",
                        birthPlace: "Surabaya",
                        birthDate: "06 Maret 2004",
                        phone: "082257048548",
                        email: "arsapradipta04@gmail.com",
                        githubLink: "https://github.com/arsa-cahaya",
                        education:
                            "S1 Sistem Informasi, UPN Veteran Jawa Timur",
                        imagePath: 'assets/image/arsa.png',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              _buildFounderCard(
                context,
                name: "Rio Alghaniy Putra",
                imagePath: 'assets/image/rio.png',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailProfilPage(
                        name: "Rio Alghaniy Putra",
                        fullName: "Rio Alghaniy Putra",
                        npm: "22082010012",
                        birthPlace: "Surabaya",
                        birthDate: "25 April 2004",
                        phone: "081335163808",
                        email: "rioalghaniyputra25@gmail.com",
                        githubLink: "https://github.com/riooalghaniy",
                        education:
                            "S1 Sistem Informasi, UPN Veteran Jawa Timur",
                        imagePath: 'assets/image/rio.png',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFounderCard(
    BuildContext context, {
    required String name,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(imagePath),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
