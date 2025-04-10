import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> bookService(Map<String, dynamic> garage, String selectedService) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;

  if (uid == null) {
    throw Exception("User not logged in");
  }

  final bookingData = {
    "garageId": garage['id'],
    "garageName": garage['name'],
    "garageType": garage['type'],
    "garageAddress": garage['address'],
    "garagePhone": garage['phone'],
    "distance": garage['distance'],
    "time": garage['time'],
    "service": selectedService,
    "status": "pending",
    "createdAt": FieldValue.serverTimestamp(),
  };

  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('bookings')
      .add(bookingData);
}



class BookingService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getPendingBookings() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('bookings')
        .where('status', isEqualTo: 'pending')
        
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Add doc ID if needed
        return data;
      }).toList();
    });
  }
}
