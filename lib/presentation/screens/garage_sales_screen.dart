import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GarageSalesScreen extends StatelessWidget {
  const GarageSalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sales Overview',
          style: TextStyle(fontSize: 17.sp, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.all(3.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Monthly Revenue',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.h),
              SizedBox(
                height: 28.h,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final months = [
                              'Jan',
                              'Feb',
                              'Mar',
                              'Apr',
                              'May',
                              'Jun',
                            ];
                            return Text(
                              months[value.toInt()],
                              style: TextStyle(fontSize: 14.sp),
                            );
                          },
                          reservedSize: 25.sp,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 25.sp,
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(toY: 8500, color: Colors.black87),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(toY: 7200, color: Colors.grey),
                        ],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(toY: 9100, color: Colors.black87),
                        ],
                      ),
                      BarChartGroupData(
                        x: 3,
                        barRods: [
                          BarChartRodData(toY: 7900, color: Colors.grey),
                        ],
                      ),
                      BarChartGroupData(
                        x: 4,
                        barRods: [
                          BarChartRodData(toY: 10200, color: Colors.black87),
                        ],
                      ),
                      BarChartGroupData(
                        x: 5,
                        barRods: [
                          BarChartRodData(toY: 9400, color: Colors.grey),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 4.h), // Increased space between the charts
              Text(
                'Weekly Sales (Mon-Sun)',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 2.h),
              SizedBox(
                height: 30.h,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: 15,
                        title: 'Mon',
                        titleStyle: TextStyle(color: Colors.white),
                        color: Colors.black,
                        radius: 40,
                      ),
                      PieChartSectionData(
                        value: 20,
                        title: 'Tue',
                        color: Colors.grey,
                        titleStyle: TextStyle(color: Colors.white),
                        radius: 40,
                      ),
                      PieChartSectionData(
                        value: 12,
                        title: 'Wed',
                        color: Colors.black,
                        titleStyle: TextStyle(color: Colors.white),
                        radius: 40,
                      ),
                      PieChartSectionData(
                        value: 10,
                        title: 'Thu',
                        color: Colors.grey,
                        titleStyle: TextStyle(color: Colors.white),
                        radius: 40,
                      ),
                      PieChartSectionData(
                        value: 18,
                        title: 'Fri',
                        color: Colors.black,
                        titleStyle: TextStyle(color: Colors.white),
                        radius: 40,
                      ),
                      PieChartSectionData(
                        value: 13,
                        title: 'Sat',
                        color: Colors.grey.shade400,
                        titleStyle: TextStyle(color: Colors.white),
                        radius: 40,
                      ),
                      PieChartSectionData(
                        value: 12,
                        title: 'Sun',
                        color: Colors.grey,
                        titleStyle: TextStyle(color: Colors.white),
                        radius: 40,
                      ),
                    ],
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
