import 'package:flutter/material.dart';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:secure_bridges_app/features/payment/existing_cards.dart';
import 'package:secure_bridges_app/features/payment/payment_service.dart';
import 'package:secure_bridges_app/network_utils/global_utility.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';

class PaymentHome extends StatefulWidget {
  final String amount;
  final int userId;
  final int planId;
  PaymentHome({this.amount, this.userId, this.planId});

  @override
  PaymentHomeState createState() => PaymentHomeState();
}

class PaymentHomeState extends State<PaymentHome> {
  onItemPress(BuildContext context, int index) async {
    switch (index) {
      case 0:
        payViaNewCard(context);
        break;
      case 1:
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => ExistingCardsPage()));
        break;
    }
  }

  payViaNewCard(BuildContext context) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var response = await StripeService.payWithNewCard(
        amount: widget.amount,
        currency: 'USD',
        userId: widget.userId,
        planId: widget.planId);
    print(response.message);
    await dialog.hide();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(response.message),
      duration:
          new Duration(milliseconds: response.success == true ? 1200 : 3000),
    ));
    if (response.success) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SELECT PAYMENT',
          style: TextStyle(color: kPurpleColor),
        ),
        backgroundColor: kAppBarBackgroundColor,
        iconTheme: IconThemeData(color: kPurpleColor),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.separated(
            itemBuilder: (context, index) {
              Icon icon;
              Text text;

              switch (index) {
                case 0:
                  icon = Icon(Icons.add_circle, color: kPurpleColor);
                  text = Text('Pay via new card');
                  break;
                // case 1:
                //   icon = Icon(Icons.credit_card, color: kPurpleColor);
                //   text = Text('Pay via existing card');
                //   break;
              }

              return InkWell(
                onTap: () async {
                  bool callApi = await shouldMakeApiCall(context);
                  if (!callApi) return;
                  onItemPress(context, index);
                },
                child: ListTile(
                  title: text,
                  leading: icon,
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(
                  color: theme.primaryColor,
                ),
            itemCount: 2),
      ),
    );
  }
}
