import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:secure_bridges_app/features/payment/payment_service.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:stripe_payment/stripe_payment.dart';

class ExistingCardsPage extends StatefulWidget {
  ExistingCardsPage({Key key}) : super(key: key);

  @override
  ExistingCardsPageState createState() => ExistingCardsPageState();
}

class ExistingCardsPageState extends State<ExistingCardsPage> {
  List cards = [
    {
      'cardNumber': '4000056655665556',
      'expiryDate': '04/24',
      'cardHolderName': 'John Doe',
      'cvvCode': '424',
      'showBackView': false,
    },
    {
      'cardNumber': '5555555566554444',
      'expiryDate': '04/23',
      'cardHolderName': 'Jerim Kaura',
      'cvvCode': '123',
      'showBackView': false,
    },
    {
      'cardNumber': '3755555566554444',
      'expiryDate': '04/27',
      'cardHolderName': 'Van Waler',
      'cvvCode': '123',
      'showBackView': false,
    }
  ];

  payViaExistingCard(BuildContext context, card) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var expiryArr = card['expiryDate'].split('/');
    CreditCard stripeCard = CreditCard(
      number: card['cardNumber'],
      expMonth: int.parse(expiryArr[0]),
      expYear: int.parse(expiryArr[1]),
    );
    var response = await StripeService.payViaExistingCard(
        amount: '2500', currency: 'USD', card: stripeCard);
    await dialog.hide();
    Scaffold.of(context)
        .showSnackBar(SnackBar(
          content: Text(response.message),
          duration: new Duration(milliseconds: 1200),
        ))
        .closed
        .then((_) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CHOOSE CARD',
          style: TextStyle(color: kPurpleColor),
        ),
        backgroundColor: kAppBarBackgroundColor,
        iconTheme: IconThemeData(color: kPurpleColor),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: cards.length,
          itemBuilder: (BuildContext context, int index) {
            var card = cards[index];
            return InkWell(
              onTap: () {
                payViaExistingCard(context, card);
              },
              child: CreditCardWidget(
                cardNumber: card['cardNumber'],
                expiryDate: card['expiryDate'],
                cardHolderName: card['cardHolderName'],
                cvvCode: card['cvvCode'],
                showBackView: false,
              ),
            );
          },
        ),
      ),
    );
  }
}
