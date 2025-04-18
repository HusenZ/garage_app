import 'package:flutter/material.dart';
import 'package:garage_app/presentation/screens/login_garage_screen.dart';
import 'package:garage_app/presentation/screens/login_screen.dart';
import 'package:sizer/sizer.dart';

class RoleLogin extends StatelessWidget {
  const RoleLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset('assets/images/logo.webp'),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.all(10.sp),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.grey,
                ),
                child: Text('Customer Login'),
              ),
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.all(10.sp),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.grey,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LoginGarageScreen(),
                    ),
                  );
                },
                child: Text('Garage Owner Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
