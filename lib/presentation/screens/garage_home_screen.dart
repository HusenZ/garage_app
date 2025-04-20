import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garage_app/presentation/screens/g_customers_screen.dart';
import 'package:garage_app/presentation/screens/garage_booking_history.dart';
import 'package:garage_app/presentation/screens/garage_sales_screen.dart';
import 'package:garage_app/presentation/screens/live_booking_screen.dart';
import 'package:garage_app/presentation/widgets/garage_card.dart';
import 'package:sizer/sizer.dart';

class GarageHomeScreen extends StatefulWidget {
  const GarageHomeScreen({super.key});

  @override
  State<GarageHomeScreen> createState() => _GarageHomeScreenState();
}

class _GarageHomeScreenState extends State<GarageHomeScreen> {
  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    Color? iconColor,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.sp),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey.shade300 : Colors.transparent,
            borderRadius: BorderRadius.circular(10.sp),
          ),
          padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.5.h),
          child: Row(
            children: [
              Icon(icon, color: iconColor ?? Colors.black),
              SizedBox(width: 2.h),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<double>? calculateTotalRevenue() async {
    double total = 0.0;
    final garageId = FirebaseAuth.instance.currentUser!.uid;
    final bookingsRef = FirebaseFirestore.instance
        .collection('garage')
        .doc(garageId)
        .collection('bookings');

    final acceptedBookings =
        await bookingsRef.where('status', isEqualTo: 'accepted').get();

    for (var doc in acceptedBookings.docs) {
      final price = doc['price'];
      if (price != null) {
        total += (price as num).toDouble();
      }
    }

    return total;
  }

  Future<int> getApprovedBookingsCount() async {
    final garageId = FirebaseAuth.instance.currentUser!.uid;

    // Await the query snapshot before accessing the size
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('garage')
            .doc(garageId)
            .collection('bookings')
            .where('status', isEqualTo: 'accepted')
            .get();

    // Return the count of documents
    return querySnapshot.size;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 2.h),
            children: [
              SizedBox(height: 2.h),
              _buildDrawerItem(
                context,
                icon: Icons.dashboard,
                label: 'Dashboard',
                isSelected: true,
                onTap: () {
                  Navigator.pop(context);
                  // Already on Dashboard
                },
              ),
              _buildDrawerItem(
                context,
                icon: Icons.shopping_bag_outlined,
                label: 'Sales',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GarageSalesScreen(),
                    ),
                  );
                },
              ),
              _buildDrawerItem(
                context,
                icon: Icons.build_circle_outlined,
                label: 'Live Booking',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LiveBookingScreen(),
                    ),
                  );
                },
              ),
              _buildDrawerItem(
                context,
                icon: Icons.group_outlined,
                label: 'Customers',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CustomersScreen()),
                  );
                },
              ),
              _buildDrawerItem(
                context,
                icon: Icons.calendar_today_outlined,
                label: 'Bookings History',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GBookingHistoryScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Dashboard",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(3.h),
        child: Column(
          children: [
            SizedBox(height: 4.h),
            FutureBuilder<double>(
              future: calculateTotalRevenue(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return DashboardCard(
                    icon: Icons.error,
                    iconBgColor: Colors.red.shade100,
                    title: "Net Income",
                    value: "Error",
                    change: "",
                    changeColor: Colors.red,
                    barColors: [Colors.grey.shade300],
                  );
                }
                final revenue = snapshot.data ?? 0.0;

                return DashboardCard(
                  icon: Icons.attach_money,
                  iconBgColor: Colors.grey.shade200,
                  title: "New Net Income",
                  value: revenue.toString(),
                  change: "- 0.5%",
                  changeColor: Colors.red,
                  barColors: [
                    Colors.black87,
                    Colors.grey,
                    Colors.black87,
                    Colors.black87,
                  ],
                );
              },
            ),
            SizedBox(height: 3.h),
            FutureBuilder<int>(
              future: getApprovedBookingsCount(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show loading indicator while fetching the data
                  return DashboardCard(
                    icon: Icons.shopping_cart_outlined,
                    iconBgColor: Colors.yellow.shade100,
                    title: "Total Bookings",
                    value: "Loading...", // Show loading state
                    change: "+ 0.0%", // Show a dummy change while loading
                    changeColor: Colors.grey,
                    barColors: [
                      Colors.black87,
                      Colors.grey,
                      Colors.black87,
                      Colors.grey,
                    ],
                  );
                } else if (snapshot.hasError) {
                  // Handle errors (e.g., no internet connection, Firebase issues)
                  return DashboardCard(
                    icon: Icons.shopping_cart_outlined,
                    iconBgColor: Colors.yellow.shade100,
                    title: "Total Bookings",
                    value: "Error", // Show error message
                    change: "+ 0.0%", // Show a dummy change on error
                    changeColor: Colors.red,
                    barColors: [
                      Colors.black87,
                      Colors.grey,
                      Colors.black87,
                      Colors.grey,
                    ],
                  );
                } else if (!snapshot.hasData || snapshot.data == 0) {
                  // Handle the case when there are no approved bookings
                  return DashboardCard(
                    icon: Icons.shopping_cart_outlined,
                    iconBgColor: Colors.yellow.shade100,
                    title: "Total Bookings",
                    value: "0", // Show no approved bookings
                    change: "+ 0.0%", // Show no change
                    changeColor: Colors.grey,
                    barColors: [
                      Colors.black87,
                      Colors.grey,
                      Colors.black87,
                      Colors.grey,
                    ],
                  );
                } else {
                  // Display the approved bookings count
                  return DashboardCard(
                    icon: Icons.shopping_cart_outlined,
                    iconBgColor: Colors.yellow.shade100,
                    title: "Total Bookings",
                    value: snapshot.data.toString(), // Display the actual count
                    change:
                        "+ 1.0%", // You can calculate the change dynamically if needed
                    changeColor: Colors.green,
                    barColors: [
                      Colors.black87,
                      Colors.grey,
                      Colors.black87,
                      Colors.grey,
                    ],
                  );
                }
              },
            ),

            SizedBox(height: 3.h),
            DashboardCard(
              icon: Icons.verified_outlined,
              iconBgColor: Colors.green.shade100,
              title: "Resolved Issues",
              value: "1,256",
              change: "+ 1.0%",
              changeColor: Colors.green,
              barColors: [
                Colors.grey,
                Colors.black87,
                Colors.black87,
                Colors.grey,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
