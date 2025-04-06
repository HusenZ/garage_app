import 'package:flutter/material.dart';

import '../app/constants/color_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    // const EnrollScreen(),
    // const MembersHomeScreen(),
    // const EnquiryHomeScreen(),
    // const ProfileScreen(),
  ];

  // Handle bottom navigation item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // void _onTabTapped(int index) {
  //   setState(() {
  //     _currentIndex = index;
  //   });
  //   // _saveCurrentIndex(index);
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.lightGrey,
      // body: _selectedIndex == 0 ? const EnrollScreen() : _pages[_selectedIndex],
      /*BOTTOM NAVIGATION BAR */
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ColorsManager.lightGrey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.miscellaneous_services_outlined),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_alt_outlined),
            label: 'My Bookings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: ColorsManager.blackColor,
        unselectedItemColor: ColorsManager.greyColor,
        // unselectedLabelStyle:
        // const TextStyle(color: ColorsManager.secondaryColor),
        onTap: _onItemTapped,
      ),
    );
  }
}
