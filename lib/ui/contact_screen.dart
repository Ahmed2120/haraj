import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:harajsedirah/api/api.dart';
import 'package:harajsedirah/api/api_config.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key key}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  _ContactScreenState({Key key});
  TextEditingController nameController = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController reason = TextEditingController();
  TextEditingController msgText = TextEditingController();
  TextEditingController phone = TextEditingController();
  String _mobile;
  String _email;
  String _name;
  String _name2;
  bool isLoading = false;
  bool _autoValidate = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('اتصل بنا'),
        centerTitle: true,
        elevation: 0.4,
        actions: <Widget>[
          IconButton(
            // icon: Text("أرسال",style: TextStyle(fontSize: 13),),
            icon: FittedBox(
              child: Text(
                isLoading == true ? "جارى..." : 'أرسال',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontFamily: 'Cocan',
                    fontWeight: FontWeight.bold),
              ),
            ),
            onPressed: () {
              isLoading ? null : _handleLogin();
            },
          ),
        ],
      ),
      body: Builder(
        builder: (_) {
          return Container(
            margin: const EdgeInsets.only(top: 20),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, right: 10, left: 10, bottom: 20),
                    child: GestureDetector(
                      onTap: () {
                        isLoading ? null : _handleLogin();
                      },
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.9),
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(15.0),
                            topLeft: Radius.circular(15.0),
                          ),
                        ),
                        child: Text(
                          isLoading == true ? "جارى..." : 'أرسال',
                          style: const TextStyle(
                              fontSize: 22, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 90,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 70,
                          margin: const EdgeInsets.only(right: 20, left: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(25.0),
                              topRight: Radius.circular(0.0),
                              bottomLeft: Radius.circular(0.0),
                              topLeft: Radius.circular(25.0),
                            ),
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Material(
                              color: Colors.white,
                              elevation: 0.1,
                              borderRadius: BorderRadius.circular(30.0),
                              child: TextFormField(
                                controller: nameController,
                                maxLines: null,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                    fillColor: Colors.black,
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.only(right: 19.0, top: 8.0),
                                    hintText: 'الإسم',
                                    hintStyle: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 14.0,
                                        fontFamily: 'Cocan',
                                        fontWeight: FontWeight.bold)),
                                validator: validateName,
                                onSaved: (String val) {
                                  _email = val;
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 90,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 70,
                          margin: const EdgeInsets.only(right: 20, left: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(25.0),
                              topRight: Radius.circular(0.0),
                              bottomLeft: Radius.circular(0.0),
                              topLeft: Radius.circular(25.0),
                            ),
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Material(
                              color: Colors.white,
                              elevation: 0.1,
                              borderRadius: BorderRadius.circular(30.0),
                              child: TextFormField(
                                controller: email,
                                maxLines: null,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                    fillColor: Colors.black,
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.only(right: 19.0, top: 8.0),
                                    hintText: 'البريد الألكتروني',
                                    hintStyle: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 14.0,
                                        fontFamily: 'Cocan',
                                        fontWeight: FontWeight.bold)),
                                validator: validateEmail,
                                onSaved: (String val) {
                                  _email = val;
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 90,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 70,
                          margin: const EdgeInsets.only(right: 20, left: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(25.0),
                              topRight: Radius.circular(0.0),
                              bottomLeft: Radius.circular(0.0),
                              topLeft: Radius.circular(25.0),
                            ),
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Material(
                              color: Colors.white,
                              elevation: 0.1,
                              borderRadius: BorderRadius.circular(30.0),
                              child: TextFormField(
                                controller: reason,
                                maxLines: null,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    fillColor: Colors.black,
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.only(right: 19.0, top: 8.0),
                                    hintText: 'سبب الأتصال',
                                    hintStyle: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 14.0,
                                        fontFamily: 'Cocan',
                                        fontWeight: FontWeight.bold)),
                                validator: validateNull,
                                onSaved: (String val) {
                                  _name = val;
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 130,
                          margin: const EdgeInsets.only(right: 20, left: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(25.0),
                              topRight: Radius.circular(0.0),
                              bottomLeft: Radius.circular(0.0),
                              topLeft: Radius.circular(25.0),
                            ),
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Material(
                              color: Colors.white,
                              elevation: 0.1,
                              borderRadius: BorderRadius.circular(30.0),
                              child: TextFormField(
                                controller: msgText,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                decoration: const InputDecoration(
                                    fillColor: Colors.black,
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.only(right: 19.0, top: 8.0),
                                    hintText: 'نص الرسالة',
                                    hintStyle: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 14.0,
                                        fontFamily: 'Cocan',
                                        fontWeight: FontWeight.bold)),
                                validator: validateNull2,
                                onSaved: (String val) {
                                  _name2 = val;
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 90,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 70,
                          margin: const EdgeInsets.only(right: 20, left: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(25.0),
                              topRight: Radius.circular(0.0),
                              bottomLeft: Radius.circular(0.0),
                              topLeft: Radius.circular(25.0),
                            ),
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Material(
                              color: Colors.white,
                              elevation: 0.1,
                              borderRadius: BorderRadius.circular(30.0),
                              child: TextFormField(
                                controller: phone,
                                maxLines: null,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                    fillColor: Colors.black,
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.only(right: 19.0, top: 8.0),
                                    hintText: 'أدخل رقم الجوال',
                                    hintStyle: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 14.0,
                                        fontFamily: 'Cocan',
                                        fontWeight: FontWeight.bold)),
                                validator: validateMobile,
                                onSaved: (String val) {
                                  _mobile = val;
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String validateName(String value) {
    if (value == "") {
      return "برجاء إدخال الإسم";
    } else
      return null;
  }

  String validateMobile(String value) {
    if (value.length < 1)
      return "يجب أن يكون رقم الجوال من 10 أرقام";
    else
      return null;
  }

  String validateEmail(String value) {
    if (value != null) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = RegExp(pattern);
      if (!regex.hasMatch(value))
        return "أدخل بريد الكتروني صالح";
      else
        return null;
    }
    return null;
  }

  String validateNull(String value) {
    if (value.length < 1)
      return "الرجاء أدخال سبب الأتصال";
    else
      return null;
  }

  String validateNull2(String value) {
    if (value.length < 1)
      return "الرجاء أدخال رسالتك ";
    else
      return null;
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

      var data = {
        'name': nameController.text,
        'email': email.text,
        'phone': phone.text,
        'msg': msgText.text,
        'reason_msg': reason.text
      };

      var res = await Api().postData(data, ApiConfig.contactUsPath);

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
      if (body['status'] == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${body['msg']}",
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${body['msg']}",
              style: const TextStyle(fontSize: 20, fontFamily: 'Cocan'),
            ),
            duration: const Duration(seconds: 1),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
        Future initData() async {
          await Future.delayed(const Duration(seconds: 2));
        }

        initData().then((value) {
          Navigator.pushNamed(context, 'home');
        });
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
