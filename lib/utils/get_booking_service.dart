import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to fetch live bookings for the current garage
  Stream<QuerySnapshot> getLiveBookings() {
    String? garageId = _auth.currentUser?.uid;
    if (garageId != null) {
      return _firestore
          .collection('garage')
          .doc(garageId)
          .collection('bookings')
          .snapshots();
    }
    return Stream.empty(); // Return empty stream if no user is authenticated
  }

  // Function to accept the booking
  Future<void> acceptBooking(String bookingId, String userId) async {
    String? garageId = _auth.currentUser?.uid;
    if (garageId != null) {
      await _firestore
          .collection('garage')
          .doc(garageId)
          .collection('bookings')
          .doc(bookingId)
          .update({'status': 'accepted'});

      final userBookings =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('bookings')
              .where('garageId', isEqualTo: garageId)
              .get();

      for (var doc in userBookings.docs) {
        await doc.reference.update({'status': 'accepted'});
      }
    }
  }

  // Function to decline the booking
  Future<void> declineBooking(String bookingId, String userId) async {
    String? garageId = _auth.currentUser?.uid;
    if (garageId != null) {
      await _firestore
          .collection('garage')
          .doc(garageId)
          .collection('bookings')
          .doc(bookingId)
          .update({'status': 'declined'});

      final userBookings =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('bookings')
              .where('garageId', isEqualTo: garageId)
              .get();

      for (var doc in userBookings.docs) {
        await doc.reference.update({'status': 'accepted'});
      }
    }
  }
}
