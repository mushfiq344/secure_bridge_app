import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secure_bridges_app/Models/bar_chart_model.dart';
import 'package:secure_bridges_app/features/org_admin/bar_chart_graph.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:secure_bridges_app/utls/dimens.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class OrgAdminHome extends StatefulWidget {
  @override
  _OrgAdminHomeState createState() => _OrgAdminHomeState();
}

class _OrgAdminHomeState extends State<OrgAdminHome> {
  final List<BarChartModel> data = [
    BarChartModel(
      year: "2014",
      financial: 250,
      color: charts.ColorUtil.fromDartColor(Colors.lightBlueAccent),
    ),
    BarChartModel(
      year: "2015",
      financial: 300,
      color: charts.ColorUtil.fromDartColor(Colors.lightBlueAccent),
    ),
    BarChartModel(
      year: "2016",
      financial: 100,
      color: charts.ColorUtil.fromDartColor(Colors.lightBlueAccent),
    ),
    BarChartModel(
      year: "2017",
      financial: 450,
      color: charts.ColorUtil.fromDartColor(Colors.lightBlueAccent),
    ),
    BarChartModel(
      year: "2018",
      financial: 630,
      color: charts.ColorUtil.fromDartColor(Colors.lightBlueAccent),
    ),
    BarChartModel(
      year: "2019",
      financial: 1000,
      color: charts.ColorUtil.fromDartColor(Colors.lightBlueAccent),
    ),
    BarChartModel(
      year: "2020",
      financial: 400,
      color: charts.ColorUtil.fromDartColor(Colors.lightBlueAccent),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFE5E5E5),
        appBar: AppBar(
          title: Text(kOpportunities),
          backgroundColor: kPurpleColor,
        ),
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: kMargin32),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: kPurpleColor,
                      borderRadius: BorderRadius.circular(kMargin35),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: kMargin12, horizontal: kMargin18),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: kMargin10),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(kMargin16),
                                    ),
                                    color: kLightPurpleBackgroundColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(kMargin10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "2",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: kMargin30,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "Opportunities",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: kMargin14,
                                                fontWeight: FontWeight.w400),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(kMargin16),
                                    ),
                                    color: kLightPurpleBackgroundColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(kMargin10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "20",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: kMargin30,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "Users",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: kMargin14,
                                                fontWeight: FontWeight.w400),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(kMargin16),
                                    ),
                                    color: kLightPurpleBackgroundColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(kMargin10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "\$530",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: kMargin30,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "Rewards",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: kMargin14,
                                                fontWeight: FontWeight.w400),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(kMargin35),
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kMargin32, vertical: kMargin14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Updates",
                                  style: TextStyle(
                                      fontSize: kMargin14,
                                      fontWeight: FontWeight.bold,
                                      color: kPurpleColor),
                                ),
                                SizedBox(
                                  height: kMargin8,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(kMargin16),
                                        ),
                                        color: kPinkBackground,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: kMargin8,
                                              horizontal: kMargin24),
                                          child: Text(
                                            "Pending Approvals[16]",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(kMargin16),
                                        ),
                                        color: kPinkBackground,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: kMargin8,
                                              horizontal: kMargin24),
                                          child: Text(
                                            "reward request[10]",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(kMargin35),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kMargin32, vertical: kMargin14),
                          child: Text(
                            "Participation Growth",
                            style: TextStyle(
                                fontSize: kMargin14,
                                fontWeight: FontWeight.bold,
                                color: kPurpleColor),
                          ),
                        ),
                        SizedBox(
                          height: kMargin8,
                        ),
                        BarChartGraph(
                          data: data,
                        ),
                        SizedBox(
                          height: kMargin8,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: kMargin10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(kMargin35),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kMargin32, vertical: kMargin14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "30 Day Activity - Establish a Habit of Daily Journaling",
                            style: TextStyle(
                                fontSize: kMargin14,
                                fontWeight: FontWeight.bold,
                                color: kPurpleColor),
                          ),
                          SizedBox(
                            height: kMargin8,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(kMargin16),
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(kRadius10)),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "http://securebridges.ubitrixbd.com/uploads/images/opportunities/1635618560617d8f003ee32.png",
                                        placeholder: (context, url) => Image(
                                            image: AssetImage(
                                                kPlaceholderImagePath)),
                                        errorWidget: (context, url, error) =>
                                            Image(
                                                image: AssetImage(
                                                    kPlaceholderImagePath)),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: AspectRatio(
                                  aspectRatio: 1 / 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Start on 1st October 2021",
                                          style: TextStyle(
                                              fontSize: kMargin12,
                                              fontWeight: FontWeight.w400,
                                              color: kPurpleColor),
                                        ),
                                        SizedBox(
                                          height: kMargin10,
                                        ),
                                        Text(
                                          "Offered by Jet Constellations",
                                          style: TextStyle(
                                              fontSize: kMargin12,
                                              fontWeight: FontWeight.w700,
                                              color: kPurpleColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: AspectRatio(
                                  aspectRatio: 1 / 1,
                                  child: GestureDetector(
                                    child: Card(
                                      color: kBlackBackground,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(kMargin16),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image(
                                              image: AssetImage(
                                                  kRightArrowWhiteIconPath)),
                                          SizedBox(
                                            height: kMargin10,
                                          ),
                                          Text(
                                            "Run",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      EasyLoading.showToast(kComingSoon);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
