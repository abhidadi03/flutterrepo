import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
import '../../../../user/data/models/user_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class UsersPieChart extends StatelessWidget {
  final List<UserModel> users;

  UsersPieChart({required this.users});

  @override
  Widget build(BuildContext context) {
    final activeCount = users.where((u) => u.is_active).length;
    final inactiveCount = users.length - activeCount;

    return SizedBox(
        // child: SizedBox(
        width: 350,
        height: 500,
        // child: Card(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                "Users:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                // height: 400,
                // width: 400,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SfCircularChart(
                        legend: const Legend(
                            isVisible: true,
                            // orientation: LegendItemOrientation.vertical,
                            position: LegendPosition.bottom),
                        series: <PieSeries<UserChartData, String>>[
                          PieSeries<UserChartData, String>(
                            dataSource: [
                              UserChartData('Active', activeCount),
                              UserChartData('Inactive', inactiveCount),
                            ],
                            xValueMapper: (data, _) => data.status,
                            yValueMapper: (data, _) => data.count,
                            dataLabelMapper: (data, _) => '${data.count}',
                            dataLabelSettings:
                                const DataLabelSettings(isVisible: true),
                          ),
                        ],
                      ),
                    ]),
              )
            ]))
        // )
        );
    // );
  }
}
