import 'package:flutter/material.dart';
import 'package:garage_app/presentation/widgets/fancy_bar.dart';
import 'package:sizer/sizer.dart';

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String value;
  final String change;
  final Color changeColor;
  final List<Color> barColors;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.iconBgColor,
    required this.title,
    required this.value,
    required this.change,
    required this.changeColor,
    required this.barColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(2.h),
      ),
      child: Row(
        children: [
          // Left side
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: iconBgColor,
                      radius: 4.h,
                      child: Icon(icon, color: Colors.black, size: 3.h),
                    ),
                    SizedBox(width: 1.h),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    //  CircleAvatar(radius: 1.5.h, backgroundImage: AssetImage("assets/user1.png")),
                    // const SizedBox(width: 4),
                    // const CircleAvatar(radius: 1.5.h, backgroundImage: AssetImage("assets/user2.png")),
                    // const SizedBox(width: 4),
                    // CircleAvatar(
                    //   radius: 1.5.h,
                    //   backgroundColor: Colors.black,
                    //   child: Text(
                    //     "25+",
                    //     style: TextStyle(fontSize: 8.sp, color: Colors.white),
                    //   ),
                    // ),
                    // const SizedBox(width: 6),
                    // Icon(Icons.more_vert, size: 2.5.h),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  "$change from last week",
                  style: TextStyle(fontSize: 15.sp, color: changeColor),
                ),
              ],
            ),
          ),

          // Right side bars
          SizedBox(
            width: 28.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(barHeights.length, (index) {
                return FancyBar(
                  height: barHeights[index],
                  color: barColors[index],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

final List<double> barHeights = [5.h, 3.h, 6.5.h, 5.5.h];
