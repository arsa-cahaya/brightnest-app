import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:brightnest_application/splash_screen.dart';
import 'package:brightnest_application/color_schema.dart';
import 'package:brightnest_application/pages/partner_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedType = "paket1";
  String searchText = "";
  final CarouselController _carouselController = CarouselController();
  int _currentSlide = 0;

  final List<Map<String, dynamic>> partners = [
    {
      "name": "CleanMate",
      "rating": 4.5,
      "imagePath": 'assets/image/cleaning1.jpg',
      "description":
          'CleanMate adalah mitra kebersihan profesional yang menawarkan layanan kebersihan dengan standar tinggi. Kami menggunakan produk ramah lingkungan untuk memastikan lingkungan yang bersih dan sehat bagi keluarga dan karyawan Anda.',
      "services": [
        "Layanan Kebersihan Rumah",
        "Layanan Kebersihan Kantor",
        "Layanan Kebersihan Tambahan"
      ],
    },
    {
      "name": "SparkleClean",
      "rating": 4.0,
      "imagePath": 'assets/image/cleaning2.jpeg',
      "description":
          'SparkleClean menyediakan layanan kebersihan yang handal dan efisien untuk rumah dan kantor Anda. Dengan tim yang terlatih dan berpengalaman, kami menjamin kepuasan pelanggan dengan hasil yang bersih dan berkilau.',
      "services": ["Layanan Kebersihan Rumah", "Layanan Kebersihan Kantor"],
    },
    {
      "name": "HomeShine",
      "rating": 3.8,
      "imagePath": 'assets/image/cleaning3.jpeg',
      "description":
          'HomeShine berfokus pada kebersihan rumah dengan layanan tambahan untuk kebutuhan khusus Anda. Kami berkomitmen untuk memberikan kebersihan menyeluruh yang membuat rumah Anda bersinar dan nyaman untuk ditinggali.',
      "services": ["Layanan Kebersihan Rumah", "Layanan Kebersihan Tambahan"],
    },
    {
      "name": "FreshHome",
      "rating": 4.2,
      "imagePath": 'assets/image/cleaning4.jpeg',
      "description":
          'FreshHome adalah solusi kebersihan rumah yang menawarkan layanan cepat dan efektif. Kami menggunakan teknologi terbaru dan metode terbaik untuk memastikan rumah Anda tetap segar dan bersih sepanjang waktu.',
      "services": ["Layanan Kebersihan Rumah"],
    },
    {
      "name": "EcoClean",
      "rating": 3.5,
      "imagePath": 'assets/image/cleaning5.jpeg',
      "description":
          'EcoClean mengutamakan lingkungan dengan menggunakan produk dan metode yang ramah lingkungan. Kami menyediakan layanan kebersihan kantor dan layanan tambahan untuk memastikan ruang kerja yang bersih dan sehat.',
      "services": ["Layanan Kebersihan Kantor", "Layanan Kebersihan Tambahan"],
    },
    {
      "name": "PristineCare",
      "rating": 4.7,
      "imagePath": 'assets/image/cleaning6.jpeg',
      "description":
          'PristineCare menyediakan layanan kebersihan komprehensif untuk rumah dan kantor Anda. Dengan perhatian terhadap detail dan penggunaan produk berkualitas, kami menjamin kebersihan yang prima dan lingkungan yang nyaman untuk Anda.',
      "services": [
        "Layanan Kebersihan Rumah",
        "Layanan Kebersihan Kantor",
        "Layanan Kebersihan Tambahan"
      ],
    },
  ];

  void onChangePaketType(String type) {
    setState(() {
      selectedType = type;
    });
  }

  void updateSearchText(String text) {
    setState(() {
      searchText = text;
    });
  }

  List<Map<String, dynamic>> getFilteredPartners() {
    List<Map<String, dynamic>> filteredPartners = partners;

    if (selectedType != "paket1") {
      filteredPartners = filteredPartners.where((partner) {
        return partner['services'].contains("layanan kebersihan $selectedType");
      }).toList();
    }

    if (searchText.isNotEmpty) {
      filteredPartners = filteredPartners.where((partner) {
        return partner['name'].toLowerCase().contains(searchText.toLowerCase());
      }).toList();
    }

    return filteredPartners;
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushNamedAndRemoveUntil(
      context,
      SplashScreen.id,
      (route) => false,
    );
  }

  final List<String> imgList = [
    'assets/image/img1.webp',
    'assets/image/img2.webp',
    'assets/image/img3.webp',
    'assets/image/img4.webp',
    'assets/image/img5.webp',
    'assets/image/img6.webp',
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredPartners = getFilteredPartners();

    return Scaffold(
      backgroundColor: lightBlue200,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "BrightNest",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.red[300],
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: ListView(
          children: [
            const SizedBox(height: 5),
            TextField(
              onChanged: updateSearchText,
              decoration: InputDecoration(
                hintText: 'Cari paket kebersihan...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.blue,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.blue,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.blue,
                  ),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 20),
            CarouselSlider(
              items: imgList
                  .map(
                    (item) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage(item),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              carouselController: _carouselController,
              options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                enlargeCenterPage: true,
                aspectRatio: 2.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentSlide = index;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imgList.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _carouselController.animateToPage(entry.key),
                  child: Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 4.0,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.blue)
                          .withOpacity(_currentSlide == entry.key ? 0.9 : 0.4),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              "Kategori Layanan",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    onChangePaketType("paket1");
                  },
                  child: Container(
                    height: 50,
                    width: 110,
                    decoration: selectedType == "paket1"
                        ? BoxDecoration(
                            color: blue400,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          )
                        : BoxDecoration(
                            border: Border.all(
                              color: Colors.black.withOpacity(0.3),
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                    child: Center(
                      child: Text(
                        "Semua",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: selectedType == "paket1"
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    onChangePaketType("rumah");
                  },
                  child: Container(
                    height: 50,
                    width: 110,
                    decoration: selectedType == "rumah"
                        ? BoxDecoration(
                            color: blue400,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          )
                        : BoxDecoration(
                            border: Border.all(
                              color: Colors.black.withOpacity(0.3),
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                    child: Center(
                      child: Text(
                        "Rumah",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: selectedType == "rumah"
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    onChangePaketType("kantor");
                  },
                  child: Container(
                    height: 50,
                    width: 110,
                    decoration: selectedType == "kantor"
                        ? BoxDecoration(
                            color: blue400,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          )
                        : BoxDecoration(
                            border: Border.all(
                              color: Colors.black.withOpacity(0.3),
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                    child: Center(
                      child: Text(
                        "Kantor",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: selectedType == "kantor"
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    onChangePaketType("tambahan");
                  },
                  child: Container(
                    height: 50,
                    width: 110,
                    decoration: selectedType == "tambahan"
                        ? BoxDecoration(
                            color: blue400,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          )
                        : BoxDecoration(
                            border: Border.all(
                              color: Colors.black.withOpacity(0.3),
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                    child: Center(
                      child: Text(
                        "Tambahan",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: selectedType == "tambahan"
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            filteredPartners.isEmpty
                ? Center(
                    child: Text(
                      'Pencarian mitra tidak ditemukan',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                  )
                : GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: filteredPartners.map((partner) {
                      return extraCard(
                        context,
                        partner["name"],
                        partner["rating"],
                        partner["imagePath"],
                        partner["description"],
                        partner["services"],
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget extraCard(BuildContext context, String name, double rating,
      String imagePath, String description, List<String> services) {
    String truncatedDescription = description.split('.').first + '.';

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PartnerDetailPage(
              name: name,
              imagePath: imagePath,
              description: description,
              services: services,
            ),
          ),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (index) {
                      return Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 20,
                      );
                    }),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    truncatedDescription,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
