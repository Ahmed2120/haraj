import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:harajsedirah/api/api_config.dart';
import 'package:harajsedirah/main.dart';
import 'package:harajsedirah/util/cons.dart';
import 'package:intl_phone_field/phone_number.dart';
import '../api/api.dart';
import 'phone_field_widget.dart';
import 'verify_phone_screen.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  _RegisterState();
  // inputs controller
  TextEditingController phoneController = TextEditingController();
  TextEditingController keyController = TextEditingController();

  // valdite name
  bool _autoValidate = false;
  String _mobile;
  String _key;
  String _selectionCountries;
  String _error;
  bool isLoading = false;
  List country_data = [];
  PhoneNumber phoneNumber;
  String hintText = "565512345";
  _getCountries() async {
    var res = await Api().getData(ApiConfig.countriesPath);
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {}
    var body = json.decode(res.body);
    if (body['status']) {
      var dataCountries = body['data'];
      setState(() {
        // countries = dataCountries.toList();
        country_data = dataCountries;
      });
    }
  }

  @override
  void initState() {
    _getCountries();
    super.initState();
    // var initializationSettingsAndroid =
    //     const AndroidInitializationSettings('app_icon');
    // var initializationSettingsIOS = const IOSInitializationSettings();
    // var initializationSettings = InitializationSettings(
    //     android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    // flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //     onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Notification'),
        content: Text(payload),
      ),
    );
  }

  // showNotification(String code) async {
  //   var androidN = const AndroidNotificationDetails(
  //       'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
  //       priority: Priority.high, importance: Importance.max);
  //   var iOSN = const IOSNotificationDetails();
  //   var platform = NotificationDetails(android: androidN, iOS: iOSN);
  //   await flutterLocalNotificationsPlugin.show(
  //       0, 'كود التفعيل الخاص بك', code, platform,
  //       payload: 'Nitish Kumar Singh is part time Youtuber');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("التسجيل"),
        centerTitle: true,
        elevation: 0.4,
      ),
      body: Builder(
        builder: (_) {
          return Container(
            margin:
                const EdgeInsets.only(top: 30, right: 10, left: 10, bottom: 20),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: ListView(
                children: <Widget>[
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: PhoneFieldWidget(
                      hintText: hintText,
                      onCountryChanged: (p0) {
                        setState(() {
                          if (p0.code == "EG") {
                            hintText = "1123456789";
                          } else {
                            hintText = "0565512345";
                          }
                        });
                      },
                      onSaved: (newValue) {
                        setState(() {
                          log(newValue.number);
                          phoneNumber = newValue;
                        });
                      },
                    ),
                  ),
                  // Container(
                  //   margin:
                  //       const EdgeInsets.only(right: 10, left: 10, bottom: 10),
                  //   child: _error != null
                  //       ? Text(_error,
                  //           style: const TextStyle(color: Colors.red))
                  //       : Container(),
                  // ),
                  // SizedBox(
                  //   height: 65,
                  //   child: Stack(
                  //     children: <Widget>[
                  //       Container(
                  //         width: MediaQuery.of(context).size.width / 1,
                  //         height: 55,
                  //         margin: const EdgeInsets.only(right: 10, left: 10),
                  //         decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           borderRadius: const BorderRadius.only(
                  //             bottomRight: Radius.circular(25.0),
                  //             topRight: Radius.circular(0.0),
                  //             bottomLeft: Radius.circular(0.0),
                  //             topLeft: Radius.circular(25.0),
                  //           ),
                  //           border: Border.all(
                  //             width: 1,
                  //             color: Theme.of(context).primaryColor,
                  //           ),
                  //         ),
                  //         child: Padding(
                  //           padding: const EdgeInsets.only(
                  //               left: 25, right: 25, top: 3),
                  //           child: Material(
                  //             color: Colors.white,
                  //             elevation: 0.1,
                  //             borderRadius: BorderRadius.circular(30.0),
                  //             child: DropdownButton(
                  //               value: _selectionCountries,
                  //               hint: const Text('أختر الدولة'),
                  //               underline: Container(),
                  //               icon: Icon(
                  //                 Icons.arrow_drop_down_circle,
                  //                 color:
                  //                     Theme.of(context).colorScheme.secondary,
                  //               ),
                  //               isExpanded: true,
                  //               onChanged: (String newValue) {
                  //                 setState(() {
                  //                   _selectionCountries = newValue;
                  //                   _error = '';
                  //                 });
                  //               },
                  //               items: country_data.map((item) {
                  //                 return DropdownMenuItem<String>(
                  //                   value: item["id"].toString(),
                  //                   child: Text(
                  //                     "${item["country_name"]} (${item["country_key"]})",
                  //                   ),
                  //                 );
                  //               }).toList(),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 65,
                  //   child: Stack(
                  //     children: <Widget>[
                  //       Container(
                  //         height: 55,
                  //         margin: const EdgeInsets.only(right: 10, left: 10),
                  //         decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           borderRadius: const BorderRadius.only(
                  //             bottomRight: Radius.circular(25.0),
                  //             topRight: Radius.circular(0.0),
                  //             bottomLeft: Radius.circular(0.0),
                  //             topLeft: Radius.circular(25.0),
                  //           ),
                  //           border: Border.all(
                  //             width: 1,
                  //             color: Theme.of(context).primaryColor,
                  //           ),
                  //         ),
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(5),
                  //           child: Material(
                  //             color: Colors.white,
                  //             elevation: 0.1,
                  //             borderRadius: BorderRadius.circular(30.0),
                  //             child: TextFormField(
                  //               controller: phoneController,
                  //               // inputFormatters: [
                  //               //   FilteringTextInputFormatter.allow(
                  //               //     RegExp("[0-9.]"),
                  //               //   ),
                  //               // ],
                  //               decoration: const InputDecoration(
                  //                   fillColor: Colors.black,
                  //                   border: InputBorder.none,
                  //                   contentPadding: EdgeInsets.only(
                  //                     right: 19.0,
                  //                   ),
                  //                   hintText: 'رقم الجوال',
                  //                   hintStyle: TextStyle(
                  //                       color: Colors.black38,
                  //                       fontSize: 16.0,
                  //                       fontFamily: 'Cocan',
                  //                       fontWeight: FontWeight.bold)),
                  //               keyboardType: TextInputType.phone,
                  //               validator: validateMobile,
                  //               onSaved: (String val) {
                  //                 _mobile = val;
                  //               },
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Container(
                      margin: const EdgeInsets.only(
                          top: 100, left: 10, right: 10, bottom: 10),
                      height: 60,
                      width: MediaQuery.of(context).size.width / 1,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: InkWell(
                        onTap: isLoading ? null : _handleLogin,
                        child: Align(
                          child: Text(
                            isLoading ? "جارى..." : "التسجيل",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                                fontFamily: 'Cocan',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                  Container(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleLogin() {
    _validateInputs();
  }

  void _validateInputs() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        isLoading = true;
      });
      final phoneString = phoneController.text;
      var data = {
        'phone': phoneNumber.number,
        'state_key': country_data.firstWhere((element) =>
            element["country_key"] == phoneNumber.countryCode)["id"],
        'device_token': fcmToken,
      };

      var res = await Api().postData(data, ApiConfig.confirmPhonePath);

      final int statusCode = res.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "هناك خطأ ما جاري أصلاحة",
              style: TextStyle(fontSize: 20, fontFamily: 'Cocan'),
            ),
            duration: const Duration(seconds: 3),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );

        setState(() {
          isLoading = false;
        });
      }

      var body = json.decode(res.body);
      log(body.toString());
      if (body['status'] == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              body['msg'].toString(),
              style: const TextStyle(fontSize: 20, fontFamily: 'Cocan'),
            ),
            duration: const Duration(seconds: 3),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
        setState(() {
          isLoading = false;
        });
      } else {
        var code = body['data']['code'];
        await getCollection();
        log(code.toString());
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => VerifyPhoneScreen(
              restPassword: false,
              code: code,
              phone: data['phone'],
              state_key: data['state_key'],
            ),
          ),
        );
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String validateMobile(String value) {
    if (value.length != 10) {
      return "يجب أن يكون رقم الجوال من 10 أرقام";
    } else {
      return null;
    }
  }
}
