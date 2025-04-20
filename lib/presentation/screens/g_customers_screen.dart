import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sizer/sizer.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  Map<String, double> userSpending = {};
  Map<String, Map<String, dynamic>> userDetails = {};

  @override
  void initState() {
    super.initState();
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    String garageId = FirebaseAuth.instance.currentUser!.uid;
    final bookingsSnap =
        await FirebaseFirestore.instance
            .collection('garage')
            .doc(garageId)
            .collection('bookings')
            .where('status', isEqualTo: 'accepted')
            .get();

    Map<String, double> tempSpending = {};
    Set<String> userIds = {};

    for (var doc in bookingsSnap.docs) {
      String uid = doc['userId'];
      double amount = (doc['price'] ?? 0).toDouble();
      userIds.add(uid);
      tempSpending[uid] = (tempSpending[uid] ?? 0) + amount;
    }

    Map<String, Map<String, dynamic>> tempDetails = {};
    for (String uid in userIds) {
      final userSnap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userSnap.exists) {
        tempDetails[uid] = userSnap.data()!;
      }
    }

    setState(() {
      userSpending = tempSpending;
      userDetails = tempDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Customers', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body:
          userSpending.isEmpty
              ? const Center(
                child: Text(
                  'No accepted bookings found',
                  style: TextStyle(color: Colors.grey),
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildHeader(),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: userSpending.length,
                        itemBuilder: (context, index) {
                          String uid = userSpending.keys.elementAt(index);
                          final user = userDetails[uid];
                          final spent = userSpending[uid] ?? 0.0;

                          return _buildCustomerTile(
                            name: user?['username'] ?? 'Unknown',
                            email: user?['email'] ?? 'N/A',

                            spent: spent,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: const [
        Expanded(
          flex: 3,
          child: Text(
            'Customer name ⬍',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'Spent',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerTile({
    required String name,
    required String email,
    required double spent,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Icon(Icons.person),
                ),
                SizedBox(width: 2.w),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(fontSize: 16.sp, color: Colors.black),
                      ),
                      Text(email, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '\₹${spent.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
