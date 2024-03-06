import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:harajsedirah/api/api.dart';
import 'package:harajsedirah/api/api_config.dart';
import 'package:harajsedirah/main.dart';
import 'package:harajsedirah/ui/screens/forget_password/forgot_password_screen.dart';
import 'package:harajsedirah/util/cons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'register.dart';
import 'screens/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  final data;
  const LoginScreen({this.data});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  _LoginScreenState({Key key});

  bool isLoading = false;
  // inputs controller
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // valdite name
  bool _autoValidate = false;
  String _email;
  String _passord;
  bool _obscureText = true;
  Icon _obscureTextIcon = const Icon(
    Icons.remove_red_eye,
    color: Color(0xFF4559f3),
    size: 25,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('دخول'),
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
                  SizedBox(
                    height: 65,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 55,
                          margin: const EdgeInsets.only(right: 10, left: 10),
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
                            padding: const EdgeInsets.all(5),
                            child: Material(
                              color: Colors.white,
                              elevation: 0.1,
                              borderRadius: BorderRadius.circular(30.0),
                              child: TextFormField(
                                controller: userController,
                                maxLines: null,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  fillColor: Colors.black,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                    right: 19.0,
                                  ),
                                  hintText: 'اسم المستخدم',
                                  hintStyle: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 14.0,
                                      fontFamily: 'Cocan',
                                      fontWeight: FontWeight.bold),
                                ),
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
                    height: 65,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 55,
                          margin: const EdgeInsets.only(right: 10, left: 10),
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
                            padding: const EdgeInsets.all(5),
                            child: Material(
                              color: Colors.white,
                              elevation: 0.1,
                              borderRadius: BorderRadius.circular(30.0),
                              child: TextFormField(
                                controller: passwordController,
                                decoration: const InputDecoration(
                                  fillColor: Colors.black,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(right: 19.0),
                                  hintText: "كلمه السر",
                                  hintStyle: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 16.0,
                                      fontFamily: 'Cocan',
                                      fontWeight: FontWeight.bold),
                                ),
                                obscureText: _obscureText,
                                keyboardType: TextInputType.text,
                                validator: validatePassword,
                                onSaved: (String val) {
                                  setState(() {
                                    _passord = val;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        // show password
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 22, top: 18, left: 35, right: 35),
                          child: Align(
                            alignment: Alignment
                                .bottomLeft, //'ar' == 'ar' ? Alignment.bottomLeft : Alignment.bottomRight,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (_obscureText == true) {
                                    _obscureText = false;
                                    _obscureTextIcon = Icon(
                                      Icons.lock,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      size: 25,
                                    );
                                  } else {
                                    _obscureText = true;
                                    _obscureTextIcon = Icon(
                                      Icons.remove_red_eye,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      size: 25,
                                    );
                                  }
                                });
                              },
                              child: _obscureTextIcon,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(ForgotPasswordScreen.routeName);
                    },
                    child: Container(
                      padding:
                          const EdgeInsets.only(right: 10, left: 10, top: 5),
                      child: Text(
                        'هل نسيت كلمة المرور؟',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                      margin:
                          const EdgeInsets.only(top: 20, left: 10, right: 10),
                      height: 60,
                      width: MediaQuery.of(context).size.width / 1,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: InkWell(
                        onTap: isLoading ? null : _handleLogin,
                        child: Align(
                          child: Text(
                            isLoading ? "جارى..." : "دخول",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                                fontFamily: 'Cocan',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Register(),
                        ),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding:
                          const EdgeInsets.only(right: 10, left: 10, top: 40),
                      child: Text(
                        'ليس لديك حساب؟ أنشئ حسابًا',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
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

      var data = {
        'username': userController.text,
        'password': passwordController.text,
        'device_token': fcmToken,
      };

      var res = await Api().postData(data, ApiConfig.loginPath);

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
              body['msg'],
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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('id', body['data']['id'].toString());

        prefs.setString('username', body['data']['first_name'].toString());
        prefs.setString('email', body['data']['email'].toString());
        prefs.setString('active', body['data']['active'].toString());
        prefs.setString('country_id', body['data']['country_id'].toString());
        prefs.setString('phone', body['data']['phone'].toString());
        prefs.setString('state_key', body['data']['state_key'].toString());
        prefs.setString('img', body['data']['img'].toString());
        //prefs.setString('language', "ar");
        //body['data']['language'].toString());
        prefs.setString('token', body['data']['token'].toString());
        await getCollection();

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
    } else {
      //    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String validateName(String value) {
    if (value.isEmpty) {
      return "الرجاء أدحال اسم المستخدم";
    } else {
      return null;
    }
  }

  String validatePassword(String value) {
    _passord = value;
    if (value.length < 8) {
      return "يجب أن تكون كلمة المرور أكثر من 8 أرقام أو أحرف";
    } else {
      return null;
    }
  }
}
