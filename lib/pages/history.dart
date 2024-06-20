import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brightnest_application/color_schema.dart';
import 'package:brightnest_application/custom_button.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Order> ongoingOrders = [];
  List<Order> completedOrders = [];
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchUserEmail();
  }

  void _fetchUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email!;
      });
      _fetchOrders(user.email!);
    }
  }

  void _fetchOrders(String email) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('riwayat_pemesanan')
        .where('email', isEqualTo: email)
        .get();

    List<Order> fetchedOngoingOrders = [];
    List<Order> fetchedCompletedOrders = [];

    snapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Order order = Order(
        id: doc.id,
        partnerName: data['name'],
        service: "Layanan Kebersihan",
        imagePath: 'assets/image/cleaning1.jpg',
        status: data['done_status'] == true ? "Selesai" : "Sedang Berjalan",
        bookingDate: DateTime.parse(data['selectedDate']),
        bookingTime: data['selectedTimeSlot'],
        workers: data['selectedProfessionals'],
        hours: data['selectedHours'],
        needMaterials: data['needMaterials'],
        totalPrice: data['totalPrice'],
        rating: data['rating'] ?? 0,
        feedback: data['feedback'] ?? '',
      );

      if (data['done_status'] == true) {
        fetchedCompletedOrders.add(order);
      } else {
        fetchedOngoingOrders.add(order);
      }
    });

    setState(() {
      ongoingOrders = fetchedOngoingOrders;
      completedOrders = fetchedCompletedOrders;
    });
  }

  void _navigateToFeedback(BuildContext context, Order order) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FeedbackPage(order: order)),
    ).then((value) => _fetchOrders(userEmail)); // Refresh orders after feedback
  }

  void _markOrderAsCompleted(Order order) async {
    await FirebaseFirestore.instance
        .collection('riwayat_pemesanan')
        .doc(order.id)
        .update({'done_status': true});

    setState(() {
      ongoingOrders.remove(order);
      order.status = "Selesai";
      completedOrders.add(order);
    });
  }

  Widget _buildActivityCard(
      {required Order order, bool showFeedbackButton = false}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(order.imagePath),
        ),
        title: Text(order.partnerName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(order.service),
            Text(
              order.status,
              style: TextStyle(
                  color: order.status == 'Sedang Berjalan'
                      ? Colors.green
                      : Colors.blue),
            ),
            if (order.rating > 0) ...[
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < order.rating ? Icons.star : Icons.star_border,
                    size: 20,
                    color: Colors.amber,
                  );
                }),
              ),
              Text(order.feedback),
            ]
          ],
        ),
        trailing: order.status == 'Sedang Berjalan'
            ? TextButton(
                onPressed: () => _markOrderAsCompleted(order),
                child: const Text('Selesai'),
              )
            : (showFeedbackButton && order.rating == 0)
                ? IconButton(
                    icon: const Icon(Icons.feedback),
                    onPressed: () => _navigateToFeedback(context, order),
                  )
                : null,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OrderDetailPage(order: order, userEmail: userEmail),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat Pemesanan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: lightBlue200,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white
              .withOpacity(0.7), // Slightly dimmer for unselected tabs
          tabs: const [
            Tab(text: 'Sedang Berjalan'),
            Tab(text: 'Selesai'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ongoingOrders.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          'Kamu belum memiliki pesanan aktif, Coba pesan layanan kebersihan sekarang'),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: ongoingOrders
                      .map((order) => _buildActivityCard(order: order))
                      .toList(),
                ),
          completedOrders.isEmpty
              ? const Center(
                  child: Text('Belum ada pesanan selesai'),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: completedOrders
                      .map((order) => _buildActivityCard(
                          order: order, showFeedbackButton: true))
                      .toList(),
                ),
        ],
      ),
    );
  }
}

class Order {
  final String id;
  final String partnerName;
  final String service;
  final String imagePath;
  String status;
  final DateTime bookingDate;
  final String bookingTime;
  final int workers;
  final int hours;
  final bool needMaterials;
  final int totalPrice;
  final int rating;
  final String feedback;

  Order({
    required this.id,
    required this.partnerName,
    required this.service,
    required this.imagePath,
    required this.status,
    required this.bookingDate,
    required this.bookingTime,
    required this.workers,
    required this.hours,
    required this.needMaterials,
    required this.totalPrice,
    this.rating = 0,
    this.feedback = '',
  });
}

class OrderDetailPage extends StatelessWidget {
  final Order order;
  final String userEmail;

  const OrderDetailPage(
      {super.key, required this.order, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightBlue200,
        elevation: 0,
        title: const Text(
          "Detail Pesanan",
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.partnerName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text('Email: $userEmail'),
                  Text(
                      'Tanggal booking: ${DateFormat('yyyy-MM-dd').format(order.bookingDate)}'),
                  Text('Waktu kehadiran: ${order.bookingTime}'),
                  Text('Jumlah pekerja: ${order.workers}'),
                  Text('Waktu pekerja: ${order.hours}'),
                  Text(
                      'Material tambahan: ${order.needMaterials ? 'Ya' : 'Tidak'}'),
                  Text('Status: ${order.status}',
                      style: TextStyle(
                          color: order.status == 'Sedang Berjalan'
                              ? Colors.green
                              : Colors.blue)),
                  const SizedBox(height: 10),
                  Text('Total Price: Rp ${order.totalPrice}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (order.rating > 0) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < order.rating ? Icons.star : Icons.star_border,
                          size: 20,
                          color: Colors.amber,
                        );
                      }),
                    ),
                    Text(order.feedback),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedbackPage extends StatefulWidget {
  final Order order;

  const FeedbackPage({super.key, required this.order});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  void _submitFeedback() async {
    await FirebaseFirestore.instance
        .collection('riwayat_pemesanan')
        .doc(widget.order.id)
        .update({'rating': _rating, 'feedback': _feedbackController.text});

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightBlue200,
        elevation: 0,
        title: const Text(
          "Feedback",
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
            const Text('Beri Rating', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    size: 32,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 20),
            const Text('Masukkan Feedback', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            TextField(
              controller: _feedbackController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Tulis feedback Anda di sini...',
              ),
            ),
            const Spacer(),
            CustomButton(
              text: 'Submit Feedback',
              onPressed: _submitFeedback,
            ),
          ],
        ),
      ),
    );
  }
}
