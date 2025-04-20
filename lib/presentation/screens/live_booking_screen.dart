import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage_app/utils/get_booking_service.dart' show BookingService;
import 'package:url_launcher/url_launcher.dart';

class LiveBookingScreen extends StatefulWidget {
  const LiveBookingScreen({super.key});

  @override
  _LiveBookingScreenState createState() => _LiveBookingScreenState();
}

class _LiveBookingScreenState extends State<LiveBookingScreen> {
  final BookingService _bookingService = BookingService();

  Future<void> launchGoogleMaps(double lat, double long) async {
    final Uri webUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$long',
    );

    try {
      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open Google Maps.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Function to build the UI with stream
  Widget _buildBookingsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _bookingService.getLiveBookings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No live bookings available.',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        var allBookings = snapshot.data!.docs;
        var acceptedBookings =
            allBookings.where((b) => b['status'] == 'accepted').toList();
        var pendingBookings =
            allBookings.where((b) => b['status'] != 'accepted').toList();
        var bookings = [...acceptedBookings, ...pendingBookings];

        return ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            var booking = bookings[index];
            var bookingId = booking.id;
            var userId = booking['userId'];
            var serviceType = booking['service'];
            var vehicleType = booking['type'];
            var status = booking['status'];
            var lat = booking['lat'].toString();
            var long = booking['long'].toString();
            print(
              "----------------------->Latittue: $lat || longitude: $long<---------------------",
            );
            return FutureBuilder<DocumentSnapshot>(
              future:
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .get(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var userData =
                    userSnapshot.data!.data() as Map<String, dynamic>;
                var username = userData['username'] ?? 'Unknown';
                var email = userData['email'] ?? 'N/A';

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  color: status == 'accepted' ? Colors.black : Colors.grey[900],
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    title: Text(
                      'Booking for $serviceType',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      'Name: $username\nEmail: $email\nVehicle: $vehicleType\nStatus: $status',
                      style: TextStyle(fontSize: 14, color: Colors.grey[300]),
                    ),
                    trailing:
                        status == 'accepted'
                            ? ElevatedButton.icon(
                              onPressed: () async {
                                try {
                                  launchGoogleMaps(
                                    double.parse(lat),
                                    double.parse(long),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Error: ${e.toString()}"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.navigation,
                                color: Colors.white,
                              ),
                              label: const Text('Navigate'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            )
                            : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.check,
                                    color: Colors.greenAccent,
                                  ),
                                  onPressed:
                                      () => _bookingService.acceptBooking(
                                        bookingId,
                                        userId,
                                      ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed:
                                      () => _bookingService.declineBooking(
                                        bookingId,
                                        userId,
                                      ),
                                ),
                              ],
                            ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        255,
        255,
        255,
      ), // Background color for the entire screen
      appBar: AppBar(
        title: Text('Live Bookings', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white, // AppBar background color
        elevation: 0,
        iconTheme: IconThemeData(color: const Color.fromARGB(255, 0, 0, 0)),
      ),
      body: _buildBookingsList(),
    );
  }
}
