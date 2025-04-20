import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garage_app/presentation/screens/book_service_screen.dart';
import 'package:sizer/sizer.dart';

class GarageNearMeScreen extends StatefulWidget {
  const GarageNearMeScreen({super.key});

  @override
  _GarageNearMeScreenState createState() => _GarageNearMeScreenState();
}

class _GarageNearMeScreenState extends State<GarageNearMeScreen> {
  bool _isLoading = true;
  bool _hasError = false;
  List<Map<String, dynamic>> _garages = [];

  @override
  void initState() {
    super.initState();
    _fetchGarages();
  }

  Future<void> _fetchGarages() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('garage').get();
      if (querySnapshot.docs.isEmpty) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
        return;
      }

      setState(() {
        _garages = querySnapshot.docs.map((doc) => doc.data()).toList();
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_garages);
    final carGarages =
        _garages.where((garage) => garage['garageType'] == 'CAR').toList();
    final bikeGarages =
        _garages.where((garage) => garage['garageType'] == 'BIKE').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Garage Near me'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey.shade100,
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _hasError
              ? Center(
                child: Text(
                  'Error fetching data. Please try again later.',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              )
              : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    "🚗 Car Workshops",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...carGarages.map((garage) => GarageCard(garage: garage)),
                  const SizedBox(height: 24),
                  const Text(
                    "🏍️ Bike Workshops",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...bikeGarages.map((garage) => GarageCard(garage: garage)),
                ],
              ),
    );
  }
}

class GarageCard extends StatelessWidget {
  final Map<String, dynamic> garage;

  const GarageCard({super.key, required this.garage});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingScreen(garage: garage),
          ),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            // Header bar with avatar and type
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                ),
                Positioned(
                  top: 2,
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 20,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Image.asset(
                        'assets/icons/mechanic.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
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
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Garage name and ID
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Garage Name', style: TextStyle(fontSize: 12)),
                      const Text('Garage ID', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Text(
                          garage['garageName'],
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 22.w,
                        child: Text(
                          garage['uid'],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Location and Time
                  // Row(
                  //   children: [
                  //     const Icon(Icons.location_on, size: 16),
                  //     const SizedBox(width: 4),
                  //     Text(
                  //       '.............  ${garage['distance']}',
                  //       style: const TextStyle(fontSize: 12),
                  //     ),
                  //     const Spacer(),
                  //     const Text('Time', style: TextStyle(fontSize: 12)),
                  //   ],
                  // ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      Expanded(
                        child: Text(
                          garage['garageAddress'],
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      // Text(
                      //   garage['time'],
                      //   style: const TextStyle(
                      //     fontSize: 13,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ],
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
