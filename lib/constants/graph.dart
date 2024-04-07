import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'constants_imports.dart';

Widget myGraph(BuildContext context) {
  List<_SalesData> data = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 34),
    _SalesData('Apr', 32),
    _SalesData('May', 40)
  ];
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
    width: maxWidth(context),
    height: 290,
    decoration: BoxDecoration(
      color: kWhite.withOpacity(0.4),
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: Column(
      children: [
        SizedBox(
          height: 250,
          child: SfCartesianChart(
            // backgroundColor: Colors.amber,
            plotAreaBorderColor: Colors.green,

            // borderColor: Colors.red,
            primaryXAxis: CategoryAxis(),
            // Chart title
            title: ChartTitle(text: ''),
            // Enable legend
            legend: Legend(isVisible: false),
            // Enable tooltip
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <ChartSeries<_SalesData, String>>[
              LineSeries<_SalesData, String>(
                dataSource: data,
                xValueMapper: (_SalesData sales, _) => sales.year,
                yValueMapper: (_SalesData sales, _) => sales.sales,
                name: 'Value',
                // Enable data label
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ),
        // Expanded(
        //   child: Padding(
        //     padding:
        //         const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        //     //Initialize the spark charts widget
        //     child: SfSparkLineChart.custom(
        //       //Enable the trackball
        //       trackball: const SparkChartTrackball(
        //           activationMode: SparkChartActivationMode.tap),
        //       //Enable marker
        //       marker: const SparkChartMarker(
        //           displayMode: SparkChartMarkerDisplayMode.all),
        //       //Enable data label
        //       labelDisplayMode: SparkChartLabelDisplayMode.all,
        //       xValueMapper: (int index) => data[index].year,
        //       yValueMapper: (int index) => data[index].sales,
        //       dataCount: 5,
        //     ),
        //   ),
        // ),
      ],
    ),
  );
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
