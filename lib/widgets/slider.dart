import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secure_bridges_app/Models/Opportunity.dart';
import 'package:secure_bridges_app/Models/User.dart';
import 'package:secure_bridges_app/features/opportunity/opportunity_detail.dart';
import 'package:secure_bridges_app/utility/urls.dart';

class OpportunitySlider extends StatelessWidget {
  final List<Opportunity> featuredOpportunities;
  final String uploadPath;
  final User currentUser;
  final VoidCallback loadUserData;
  final VoidCallback loadOpportunitiesStats; // Notice the variable type
  OpportunitySlider(
      {this.featuredOpportunities,
      this.uploadPath,
      this.currentUser,
      this.loadUserData,
      this.loadOpportunitiesStats});

  Widget build(BuildContext context) {
    final List<Widget> imageSliders = featuredOpportunities
        .map((item) => GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => OpportunityDetail(
                            item, uploadPath, currentUser))).then((value) {
                  loadUserData();
                  loadOpportunitiesStats();
                });
              },
              child: Container(
                child: Container(
                  margin: EdgeInsets.all(5.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      child: Stack(
                        children: <Widget>[
                          Image.network(
                              "${BASE_URL}${uploadPath}${item.coverImage}",
                              fit: BoxFit.cover,
                              width: 1000.0),
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(200, 0, 0, 0),
                                    Color.fromARGB(0, 0, 0, 0)
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              child: Text(
                                '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ))
        .toList();
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          aspectRatio: 2.0,
          enlargeCenterPage: true,
        ),
        items: imageSliders,
      ),
    );
  }
}
