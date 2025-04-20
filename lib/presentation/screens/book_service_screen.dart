import 'package:flutter/material.dart';
import 'package:garage_app/core/all_services_c.dart';
import 'package:garage_app/utils/booking_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingScreen extends StatefulWidget {
  final Map<String, dynamic> garage;

  const BookingScreen({super.key, required this.garage});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String? selectedService;
  final _formKey = GlobalKey<FormState>();
  int? generatedPrice;

  Future<Position?> _getUserLocation() async {
    LocationPermission permission;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enable location services."),
          backgroundColor: Colors.orange,
        ),
      );
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Location permission denied."),
            backgroundColor: Colors.red,
          ),
        );
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Location permission permanently denied."),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  @override
  Widget build(BuildContext context) {
    final garage = widget.garage;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Garage Booking'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Garage Card UI
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 2,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 22,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.asset(
                            'assets/images/mechanic.png',
                            width: 26,
                            height: 26,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 12,
                      top: 10,
                      child: Text(
                        '${garage['garageType'].toString().toUpperCase()} WORKSHOP',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name & ID
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Garage Name',
                            style: TextStyle(fontSize: 12),
                          ),
                          const Text(
                            'Garage ID',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            garage['garageName'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            garage['uid'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Address & Time
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16),

                          const Spacer(),
                          const Text('Time', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              garage['garageAddress'],
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text("Services", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          // Services list text (as per screenshot)
          Text(
            (garage['services'] as List<dynamic>).join(', '),
            style: TextStyle(fontSize: 13, height: 1.4),
          ),

          const SizedBox(height: 20),

          // Dropdown for service type
          Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonFormField<String>(
                value: selectedService,
                hint: const Text("Select Service Type"),
                isExpanded: true,
                decoration: const InputDecoration(border: InputBorder.none),
                items:
                    allServices.map((service) {
                      return DropdownMenuItem<String>(
                        value: service['title'],
                        child: Text(service['title'] ?? ''),
                      );
                    }).toList(),
                validator:
                    (value) =>
                        value == null ? "Please select a service type" : null,
                onChanged: (value) {
                  setState(() {
                    generatedPrice = 100 + (value.hashCode % 400);
                    selectedService = value;
                  });
                },
              ),
            ),
          ),

          if (selectedService != null && generatedPrice != null)
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Text(
                'Estimated Price: ₹$generatedPrice',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.green,
                ),
              ),
            ),

          SizedBox(height: 3.h),

          // Reviews stars
          const Text("Reviews", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) {
              return const Icon(Icons.star, color: Colors.amber, size: 24);
            }),
          ),

          const SizedBox(height: 24),

          // Booking Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.phone, color: Colors.white),
              label: const Text(
                "Call Now",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                final phone = widget.garage['phone'];
                final Uri url = Uri(scheme: 'tel', path: phone);
                launchUrl(url);
              },
            ),
          ),
          SizedBox(height: 2.h),
          // Book Now Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check_circle, color: Colors.white),
              label: const Text(
                "Book Now",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () async {
                // Show loading dialog
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder:
                      (context) => const AlertDialog(
                        title: Text("Getting your location"),
                        content: Row(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                "Please wait while we fetch your current location.",
                              ),
                            ),
                          ],
                        ),
                      ),
                );

                try {
                  // Ask permission and fetch location
                  LocationPermission permission =
                      await Geolocator.checkPermission();
                  if (permission == LocationPermission.denied ||
                      permission == LocationPermission.deniedForever) {
                    permission = await Geolocator.requestPermission();
                  }

                  if (permission == LocationPermission.denied ||
                      permission == LocationPermission.deniedForever) {
                    Navigator.pop(context); // Close loading dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Location permission is required to continue.",
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  // Get user location
                  final position = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high,
                  );

                  Navigator.pop(context); // Close loading dialog

                  // Show confirmation dialog
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text("Confirm Booking"),
                          content: const Text(
                            "Have you called the garage and confirmed availability?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    await bookService(
                                      garage,
                                      selectedService!,
                                      garage['uid'],
                                      generatedPrice ?? 100,
                                      position.latitude,
                                      position.longitude,
                                    );

                                    if (!mounted) return;

                                    Navigator.pop(context); // Close dialog
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Service booked successfully!",
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  } catch (e) {
                                    if (!mounted) return;

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Error: ${e.toString()}"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                              child: const Text("Yes, Book Now"),
                            ),
                          ],
                        ),
                  );
                } catch (e) {
                  Navigator.pop(context); // Close loading dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Failed to get location: $e"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
