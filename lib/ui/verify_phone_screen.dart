import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:harajsedirah/ui/screens/rest_password/rest_password_screen.dart';
import 'package:otp_text_field/style.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:validators/validators.dart';
import 'register_fnish.dart';
import 'package:otp_text_field/otp_text_field.dart';

class VerifyPhoneScreen extends StatefulWidget {
  bool restPassword;
  var code, state_key, phone;
  VerifyPhoneScreen({this.restPassword, this.code, this.phone, this.state_key});
  @override
  _VerifyPhoneScreenState createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("كود التفعيل"),
        centerTitle: true,
        elevation: 0.4,
      ),
      body: Builder(
        builder: (_) {
          return Container(
              margin: const EdgeInsets.only(
                  top: 50, right: 10, left: 10, bottom: 20),
              child: MyCustomForm(
                  restPassword: widget.restPassword,
                  code: widget.code,
                  phone: widget.phone,
                  state_key: widget.state_key,
                  scaffoldKey: _scaffoldKey));
        },
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  bool restPassword;
  var code, state_key, phone;
  final GlobalKey<ScaffoldState> scaffoldKey;
  MyCustomForm(
      {this.code,
      this.phone,
      this.state_key,
      this.scaffoldKey,
      this.restPassword});
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  final bool _autoValidate = false;
  final focus = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  final _controller = OtpFieldController();
  int code1;
  int code2;
  int code3;
  int code4;
  Color colorCode1 = const Color(0xFF2e4082);
  Color colorCode2 = const Color(0xFF2e4082);
  Color colorCode3 = const Color(0xFF2e4082);
  Color colorCode4 = const Color(0xFF2e4082);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: ListView(
        children: <Widget>[
          Directionality(
              textDirection: TextDirection.ltr,
              child: OTPTextField(
                //  controller: _controller,١
                onChanged: (value) {
                  log("on changed" + value);
                },
                otpFieldStyle: OtpFieldStyle(
                    borderColor: Theme.of(context).colorScheme.primary),
                length: 4,
                width: MediaQuery.of(context).size.width,
                fieldWidth: 80,
                style: const TextStyle(fontSize: 17),
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.box,
                onCompleted: (pin) {
                  final pinString = !isInt(pin)
                      ? NumberUtility.changeDigit(pin, NumStrLanguage.English)
                      : pin;
                  if (pinString == widget.code.toString()) {
                    if (widget.restPassword) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => RestPasswordScreen(
                              otp: pinString, phone: widget.phone),
                        ),
                      );
                    } else {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => RegisterFnish(
                            phone: widget.phone,
                            state_key: widget.state_key,
                          ),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'كود خاطئ',
                          style: TextStyle(fontSize: 20, fontFamily: 'Cocan'),
                        ),
                        duration: const Duration(seconds: 3),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                      ),
                    );
                  }
                },
              )),
          Container(
            height: 10,
          ),
        ],
      ),
    );
  }
}
