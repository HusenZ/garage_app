import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GBookingHistoryScreen extends StatelessWidget {
  const GBookingHistoryScreen({super.key});

  Future<List<QueryDocumentSnapshot>> _fetchAllBookings() async {
    final garageId = FirebaseAuth.instance.currentUser!.uid;
    print("-----------------> $garageId");
    final snapshot =
        await FirebaseFirestore.instance
            .collection('garage')
            .doc(garageId)
            .collection('bookings')
            .get();
    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Booking History', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: _fetchAllBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No booking history found.',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            );
          }

          final allBookings = snapshot.data!;
          final accepted =
              allBookings.where((doc) => doc['status'] == 'accepted').toList();
          final pending =
              allBookings.where((doc) => doc['status'] == 'pending').toList();
          final declined =
              allBookings.where((doc) => doc['status'] == 'declined').toList();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (accepted.isNotEmpty) _buildSection('Accepted', accepted),
                if (pending.isNotEmpty) _buildSection('Pending', pending),
                if (declined.isNotEmpty) _buildSection('Declined', declined),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, List<QueryDocumentSnapshot> bookings) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title Bookings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          ...bookings.map((booking) {
            var data = booking.data() as Map<String, dynamic>;
            var userId = data['userId'];
            var service = data['service'];
            var type = data['type'];
            var status = data['status'];
            return FutureBuilder<DocumentSnapshot>(
              future:
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .get(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) return SizedBox.shrink();
                final user =
                    userSnapshot.data!.data() as Map<String, dynamic>? ?? {};
                final name = user['username'] ?? 'Unknown';
                final email = user['email'] ?? 'N/A';

                return Card(
                  color: Colors.grey[100],
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      '$service ($type)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name: $name',
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                        Text(
                          'Email: $email',
                          style: TextStyle(color: Colors.grey[700]),
                        ),

                        Text(
                          'Status: $status',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}
