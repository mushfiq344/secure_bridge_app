import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secure_bridges_app/Models/Opportunity.dart';
import 'package:secure_bridges_app/features/authentication/login.dart';
import 'package:secure_bridges_app/network_utils/api.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:secure_bridges_app/utls/dimens.dart';
import 'package:secure_bridges_app/utls/styles.dart';
import 'package:secure_bridges_app/widgets/custom_alert_dialogue.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Opportunities extends StatefulWidget {
  @override
  _OpportunitiesState createState() => _OpportunitiesState();
}

class _OpportunitiesState extends State<Opportunities> {
  List<Opportunity> opportunities = <Opportunity>[];
  List<Opportunity> opportunitiesAll = <Opportunity>[];
  static List<Opportunity> searchedOpportunities = [];
  TextEditingController _searchController = TextEditingController();
  String uploadPath;
  @override
  void initState() {
    _searchController.addListener(_applySearchOnOpportunityeList);
    _loadOpportunitiesStats();
    super.initState();
  }

  void _applySearchOnOpportunityeList() {
    List<Opportunity> _tempSearchedList = [];
    for (Opportunity opportunity in opportunitiesAll) {
      if (opportunity.title != null) {
        if (opportunity.title
            .toLowerCase()
            .contains(_searchController.text.toLowerCase())) {
          _tempSearchedList.add(opportunity);
        }
      }
    }
    setState(() {
      opportunities = _tempSearchedList;
      searchedOpportunities = _tempSearchedList;
    });
  }

  _loadOpportunitiesStats() async {
    try {
      EasyLoading.show(status: kLoading);
      var res = await Network().getData(OPPORTUNITIES_URL);
      var body = json.decode(res.body);
      if (res.statusCode == 200) {
        print(body);
        await fetchOpportunities(
            body["data"]["max_duration"],
            body["data"]["min_duration"],
            body["data"]["max_reward"],
            body["data"]["min_reward"]);
      } else {
        EasyLoading.dismiss();
        showDialog(
            context: context,
            builder: (_) => CustomAlertDialogue("Error!", body["message"]));
        // EasyLoading.showError(body["message"]);
      }
    } catch (e) {
      EasyLoading.dismiss();
      showDialog(
          context: context,
          builder: (_) => CustomAlertDialogue("Error!", e.toString()));
      // EasyLoading.showError(e.toString());
    }
  }

  fetchOpportunities(int maxDuration, int minDuratin, String maxReward,
      String minReward) async {
    try {
      var data = {
        'duration_high': maxDuration,
        'duration_low': minDuratin,
        'reward_low': minReward,
        'reward_high': maxReward
      };

      var res = await Network().postData(data, FETCH_OPPORTUNITIES_URL);
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");
      log("body : $body");
      if (res.statusCode == 200) {
        List<Opportunity> _opportunities = List<Opportunity>.from(
            body['data']['opportunities'].map((i) => Opportunity.fromJson(i)));

        setState(() {
          opportunities = _opportunities;
          opportunitiesAll = _opportunities;
          searchedOpportunities = _opportunities;
          uploadPath = body["data"]["upload_path"];
        });
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        // EasyLoading.showError(body['message']);
        showDialog(
            context: context,
            builder: (_) => CustomAlertDialogue("Error!", body['message']));
      }
    } catch (e) {
      EasyLoading.dismiss();
      // EasyLoading.showError(e.toString());
      showDialog(
          context: context,
          builder: (_) => CustomAlertDialogue("Error!", e.toString()));
    }
  }

  _setUpSearchBar() {
    return Container(
      color: kLiteBackgroundColor,
      padding: EdgeInsets.symmetric(vertical: kMargin18, horizontal: kMargin18),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(kRadius10),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kBorderColor,
                    ),
                    borderRadius: BorderRadius.circular(kRadius10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kAccentColor,
                    ),
                    borderRadius: BorderRadius.circular(kRadius10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildOpportunityList(BuildContext context) {
    return opportunities.length > 0
        ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: opportunities.length,
            itemBuilder: (_, index) {
              final item = opportunities[index];
              return _buildListItem(item);
            },
          )
        : Center(child: Text("No Item Found"));
  }

  _buildListItem(Opportunity item) {
    String coverUrl = "${BASE_URL}${uploadPath}${item.coverImage}";

    return GestureDetector(
      onTap: () {
        setState(() {
          item.show = !item.show;
        });
      },
      child: Padding(
        padding:
            EdgeInsets.symmetric(vertical: kMargin12, horizontal: kMargin16),
        child: Container(
          decoration: BoxDecoration(
              color: kLiteBackgroundColor,
              borderRadius: BorderRadius.circular(kRadius10)),
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin:
                          EdgeInsets.only(left: kMargin24, right: kMargin12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              width:
                                  (2 * (MediaQuery.of(context).size.width)) / 5,
                              child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(kRadius10),
                                      bottomLeft: Radius.circular(kRadius10)),
                                  child: CachedNetworkImage(
                                    imageUrl: coverUrl,
                                    placeholder: (context, url) => Image(
                                        image:
                                            AssetImage(kPlaceholderImagePath)),
                                    errorWidget: (context, url, error) => Image(
                                        image:
                                            AssetImage(kPlaceholderImagePath)),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ), // image
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: item.show
                                        ? Icon(Icons.keyboard_arrow_up,
                                            size: 30)
                                        : Icon(Icons.keyboard_arrow_down,
                                            size: 30),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: kMargin24, right: kMargin12),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Title",
                                      style: labelStyle,
                                    ),
                                  ),
                                ),
                                SizedBox(height: kMargin12),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: kMargin24, right: kMargin12),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: RichText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      strutStyle: StrutStyle(fontSize: 12.0),
                                      text: TextSpan(
                                          style: valueStyle, text: item.title),
                                    ),
                                  ),
                                ),
                                Container(
                                  color: Colors.white,
                                  height: 1.0,
                                  margin: EdgeInsets.symmetric(
                                      vertical: kMargin16,
                                      horizontal: kMargin24),
                                ),
                                SizedBox(height: kMargin20)
                              ],
                            ),
                          ), // detail info
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(left: kMargin24, right: kMargin12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Sub Title",
                              style: smallLabel,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: RichText(
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  strutStyle: StrutStyle(fontSize: 12.0),
                                  text: TextSpan(
                                      style: valueStyle,
                                      text: item.subTitle == null
                                          ? ''
                                          : item.subTitle),
                                ), /*Text(
                                    item.problem == null ? " " : item.problem,
                                    style: valueStyle,
                                  ),*/
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: kMargin12),
                    Container(
                      color: Colors.white,
                      height: 1.0,
                      margin: EdgeInsets.symmetric(vertical: 0),
                    ),
                    SizedBox(height: kMargin12),
                    Container(
                      margin:
                          EdgeInsets.only(left: kMargin24, right: kMargin12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Duration",
                              style: smallLabel,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  strutStyle: StrutStyle(fontSize: 12.0),
                                  text: TextSpan(
                                    text: "${item.duration.toString()} Days",
                                    style: valueStyle,
                                  ),
                                ), /*Text(
                                    item.problem == null ? " " : item.problem,

                                  ),*/
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: kMargin12),
                    Container(
                      color: Colors.white,
                      height: 1.0,
                      margin: EdgeInsets.symmetric(vertical: 0),
                    ),
                    SizedBox(height: kMargin12),
                    Container(
                      margin:
                          EdgeInsets.only(left: kMargin24, right: kMargin12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Reward",
                              style: smallLabel,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  strutStyle: StrutStyle(fontSize: 12.0),
                                  text: TextSpan(
                                    text: "${item.reward} \$",
                                    style: valueStyle,
                                  ),
                                ), /*Text(
                                    item.problem == null ? " " : item.problem,

                                  ),*/
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: kMargin12),
                  ],
                ),
                item.show
                    ? Column(
                        children: [
                          SizedBox(height: kMargin12),
                          Container(
                            color: Colors.white,
                            height: 1.0,
                            margin: EdgeInsets.symmetric(vertical: 0),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  margin: EdgeInsets.only(left: kMargin24),
                                  child: Text(
                                    "Action",
                                    style: labelStyle,
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          onTap: () async {
                                            // bool callApi =
                                            //     await shouldMakeApiCall(
                                            //         context);
                                            // if (!callApi) return;
                                            // try {
                                            //   EasyLoading.show(
                                            //       status: AppLocalizations.of(
                                            //               context)
                                            //           .kLoading);
                                            //   final response =
                                            //       await Provider.of<ApiService>(
                                            //               context,
                                            //               listen: false)
                                            //           .getInvoice(item.id);
                                            //   // print("invoices  ${response.body}");
                                            //
                                            //   if (response.isSuccessful &&
                                            //       response.statusCode == 200) {
                                            //     EasyLoading.dismiss();
                                            //     Invoice invoice =
                                            //         Invoice.fromJson(
                                            //             response.body);
                                            //
                                            //     Navigator.push(
                                            //       context,
                                            //       MaterialPageRoute(
                                            //           builder: (context) =>
                                            //               InvoiceShow(invoice)),
                                            //     );
                                            //   } else {
                                            //     EasyLoading.dismiss();
                                            //     var errors = response.error;
                                            //
                                            //     final message =
                                            //         json.decode(errors);
                                            //
                                            //     Utils.showToast(context,
                                            //         message["error"], true);
                                            //   }
                                            // } catch (e) {
                                            //   EasyLoading.dismiss();
                                            //   EasyLoading.showError(
                                            //       jsonEncode(e.toString()));
                                            // }
                                          },
                                          child: Center(
                                            child: Image(
                                              width: 32,
                                              height: 32,
                                              image:
                                                  AssetImage(kPreviewIconPath),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          onTap: () async {
                                            // bool callApi =
                                            // await shouldMakeApiCall(
                                            //     context);
                                            // if (!callApi) return;
                                            // try {
                                            //   EasyLoading.show(
                                            //       status:
                                            //       AppLocalizations.of(
                                            //           context)
                                            //           .kLoading);
                                            //   final response =
                                            //   await Provider.of<
                                            //       ApiService>(
                                            //       context,
                                            //       listen: false)
                                            //       .getInvoice(
                                            //       item.id);
                                            //   // print("invoices  ${response.body}");
                                            //
                                            //   if (response.isSuccessful &&
                                            //       response.statusCode ==
                                            //           200) {
                                            //     EasyLoading.dismiss();
                                            //     Invoice invoice =
                                            //     Invoice.fromJson(
                                            //         response.body);
                                            //
                                            //     Navigator.push(
                                            //       context,
                                            //       MaterialPageRoute(
                                            //           builder: (context) =>
                                            //               FinanceHome(
                                            //                   invoice)),
                                            //     ).then((value) {
                                            //       getInvoiceList();
                                            //     });
                                            //   } else {
                                            //     EasyLoading.dismiss();
                                            //     var errors =
                                            //         response.error;
                                            //
                                            //     final message =
                                            //     json.decode(errors);
                                            //
                                            //     Utils.showToast(
                                            //         context,
                                            //         message["error"],
                                            //         true);
                                            //   }
                                            // } catch (e) {
                                            //   EasyLoading.dismiss();
                                            //   EasyLoading.showError(
                                            //       jsonEncode(
                                            //           e.toString()));
                                            // }
                                          },
                                          child: Center(
                                            child: Image(
                                              image: AssetImage(
                                                kEditIconPath,
                                              ),
                                              height: kMargin32,
                                              width: kMargin32,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          onTap: () async {
                                            // bool callApi =
                                            // await shouldMakeApiCall(
                                            //     context);
                                            // if (!callApi) return;
                                            // EasyLoading.show(
                                            //     status:
                                            //     AppLocalizations.of(
                                            //         context)
                                            //         .kDeleting);
                                            // try {
                                            //   final response =
                                            //   await Provider.of<
                                            //       ApiService>(
                                            //       context,
                                            //       listen: false)
                                            //       .deleteInvoice(
                                            //       item.id);
                                            //   // print("invoices  ${response.body}");
                                            //
                                            //   if (response.isSuccessful &&
                                            //       response.statusCode ==
                                            //           200) {
                                            //     EasyLoading.dismiss();
                                            //     Invoice invoice =
                                            //     Invoice.fromJson(
                                            //         response.body);
                                            //     setState(() {
                                            //       _invoiceList
                                            //           .remove(item);
                                            //       _invoiceListAll
                                            //           .remove(item);
                                            //       _filteredInvoiceList
                                            //           .remove(item);
                                            //       _searchedInvoiceList
                                            //           .remove(item);
                                            //     });
                                            //
                                            //     EasyLoading.showSuccess(
                                            //         AppLocalizations.of(
                                            //             context)
                                            //             .kDone);
                                            //   } else {
                                            //     EasyLoading.dismiss();
                                            //     EasyLoading.showError(
                                            //         AppLocalizations.of(
                                            //             context)
                                            //             .kSomethingWentWrong);
                                            //   }
                                            // } catch (e) {
                                            //   EasyLoading.dismiss();
                                            //   EasyLoading.showError(
                                            //       e.toString());
                                            // }
                                          },
                                          child: Center(
                                            child: Image(
                                              height: 32,
                                              width: 32,
                                              image: AssetImage(kTrashIconPath),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                              Expanded(
                                flex: 0,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: kMargin18),
                                    alignment: Alignment.topLeft,
                                    child: Container(),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 0,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: kMargin18),
                                    alignment: Alignment.topLeft,
                                    child: Container(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: kMargin16)
                        ],
                      )
                    : SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          kOpportunities,
          style: TextStyle(color: kPurpleColor),
        ),
        backgroundColor: kAppBarBackgroundColor,
        iconTheme: IconThemeData(color: kPurpleColor),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Column(
            children: [
              _setUpSearchBar(),
              SizedBox(height: kMargin12),
              _buildOpportunityList(context),
              SizedBox(height: kMargin300),
            ],
          ),
        ),
      ),
    );
  }

  void logout() async {
    var res = await Network().postData({}, '/logout');
    var body = json.decode(res.body);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('user');
    localStorage.remove('token');
    await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login()),
      (route) => false,
    );
  }
}
