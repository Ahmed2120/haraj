import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:harajsedirah/api/api.dart';
import 'package:harajsedirah/api/api_config.dart';
import 'package:harajsedirah/provider/profile_provider.dart';
import 'package:harajsedirah/ui/phone_field_widget.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPhoneScreen extends StatefulWidget {
  const EditPhoneScreen({Key key}) : super(key: key);

  @override
  _EditPhoneScreenState createState() => _EditPhoneScreenState();
}

class _EditPhoneScreenState extends State<EditPhoneScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  // inputs controller
  TextEditingController phoneController = TextEditingController();
  TextEditingController keyController = TextEditingController();

  bool isLoading = false;
  List countryData = [];
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
        countryData = dataCountries;
      });
    }
  }

  @override
  void initState() {
    _getCountries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("تغيير رقم الجوال"),
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
                      initialValue: profileProvider.phone,
                      initialCountryCode: profileProvider.stateKey == '+20'
                          ? 'EG'
                          : profileProvider.stateKey == '+973'
                              ? 'BH'
                              : profileProvider.stateKey == '+965'
                                  ? 'KW'
                                  : profileProvider.stateKey == '+968'
                                      ? 'OM'
                                      : profileProvider.stateKey == '+974'
                                          ? 'QA'
                                          : profileProvider.stateKey == '+966'
                                              ? 'SA'
                                              : 'AE',
                      hintText: hintText,
                      onCountryChanged: (p0) {
                        setState(() {
                          if (p0.code == "EG") {
                            hintText = "1123456789";
                          } else {
                            hintText = "565512345";
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
                            isLoading ? "جارى..." : "تعديل",
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
      final profileProvider = context.read<ProfileProvider>();
      final phoneNumberData = phoneNumber.number;
      var data = {
        'id': profileProvider.id,
        'phone_number': phoneNumberData,
        'state_key': phoneNumber.countryCode,
      };

      var res = await Api().postData(data, ApiConfig.changePhone);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('phone', phoneNumberData.toString());
      prefs.setString('state_key', phoneNumber.countryCode.toString());
      context.read<ProfileProvider>().readUserProfile();

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
      }
      setState(() {
        isLoading = false;
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
