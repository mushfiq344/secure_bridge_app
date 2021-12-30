import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secure_bridges_app/network_utils/global_utility.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/widgets/PAButton.dart';

class CodeCheckModal extends StatefulWidget {
  @override
  _CodeCheckModalState createState() => _CodeCheckModalState();
}

class _CodeCheckModalState extends State<CodeCheckModal> {
  final _formKey = GlobalKey<FormState>();
  String code;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                style: TextStyle(color: Color(0xFF000000)),
                cursorColor: Color(0xFF9b9b9b),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.approval,
                    color: Colors.grey,
                  ),
                  hintText: "Code",
                  hintStyle: TextStyle(
                      color: Color(0xFF9b9b9b),
                      fontSize: 15,
                      fontWeight: FontWeight.normal),
                ),
                validator: (codeValue) {
                  if (codeValue.isEmpty) {
                    return 'Please enter code';
                  }
                  code = codeValue;
                  return null;
                },
              ),
            ),
            PAButton(
              'Check',
              true,
              () async {
                bool callApi = await shouldMakeApiCall(context);
                if (!callApi) return;
                if (_formKey.currentState.validate()) {
                  // _confirmUser(
                  //     widget.opportunity.id,
                  //     code);
                }
              },
              fillColor: kGreyBackgroundColor,
              textColor: Colors.orange,
              capitalText: false,
            )
          ],
        ),
      ),
    );
  }
}
