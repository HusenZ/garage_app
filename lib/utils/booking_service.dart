import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> bookService(
  Map<String, dynamic> garage,
  String selectedService,
  String garageId,
  int servicePrice,
  double latitude,
  double longitude,
) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;

  print('-------------> $garageId');

  if (uid == null) {
    throw Exception("User not logged in");
  }

  final bookingData = {
    "garageId": garage['uid'],
    "garageName": garage['garageName'],
    "garageType": garage['garageType'],
    "garageAddress": garage['garageAddress'],
    "garagePhone": garage['garagePhone'],
    "service": selectedService,
    "price": servicePrice,
    "lat": latitude,
    "long": longitude,
    "status": "pending",
    "createdAt": FieldValue.serverTimestamp(),
  };

  final garageCollectionData = {
    "status": "pending",
    "type": garage['garageType'],
    "service": selectedService,
    "lat": latitude,
    "long": longitude,
    "price": servicePrice,
    "userId": uid,
  };

  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('bookings')
      .add(bookingData);

  await FirebaseFirestore.instance
      .collection('garage')
      .doc(garageId)
      .collection('bookings')
      .add(garageCollectionData);
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
