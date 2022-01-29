import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:secure_bridges_app/Models/bar_chart_model.dart';

// class BarChartGraph extends StatefulWidget {
//   final List<BarChartModel> data;
//   String title;
//
//   BarChartGraph({Key key, this.data, this.title});
//
//   @override
//   _BarChartGraphState createState() => _BarChartGraphState();
// }

class BarChartGraph extends StatelessWidget {
  final List<BarChartModel> data;
  String title;

  BarChartGraph({Key key, this.data, this.title});
  List<BarChartModel> _barChartList;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   print("widget.title : ${widget.title}");
  //   super.initState();
  //   _barChartList = [
  //     BarChartModel(month: widget.title),
  //   ];
  // }

  @override
  Widget build(BuildContext context) {
    _barChartList = [
      BarChartModel(month: title),
    ];
    List<charts.Series<BarChartModel, String>> series = [
      charts.Series(
          id: "Financial",
          data: data,
          domainFn: (BarChartModel series, _) => series.year,
          measureFn: (BarChartModel series, _) => series.financial,
          colorFn: (BarChartModel series, _) => series.color),
    ];

    return _buildFinancialList(series);
  }

  Widget _buildFinancialList(series) {
    return _barChartList != null
        ? ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => Divider(
              color: Colors.white,
              height: 5,
            ),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _barChartList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: MediaQuery.of(context).size.height / 2.3,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_barChartList[index].month,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Expanded(child: charts.BarChart(series, animate: true)),
                  ],
                ),
              );
            },
          )
        : SizedBox();
  }
}
