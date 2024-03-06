import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:harajsedirah/api/api_config.dart';
import '../api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class RegisterFnish extends StatefulWidget {
  var phone, state_key;
  RegisterFnish({this.state_key, this.phone});

  @override
  _RegisterFnishState createState() => _RegisterFnishState();
}

class _RegisterFnishState extends State<RegisterFnish> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  _RegisterFnishState({Key key});
  _RegisterFnishState.formSnapShot(DataSnapshot snapshot) {
    _name = (snapshot.value  as Map)['first_name'];
    _email = (snapshot.value  as Map)['email'];
    _mobile = (snapshot.value  as Map)['mobile'];
  }

  // inputs controller
  TextEditingController userController = TextEditingController();
  TextEditingController keyController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();
  // valdite name
  bool _autoValidate = false;
  String _name;
  String _email;
  String _mobile;
  String _passord;
  String _repassord;
  bool _obscureText = true;
  bool _obscureTextPass = true;
  Icon _obscureTextIcon = const Icon(
    Icons.remove_red_eye,
    color: Color(0xFF4559f3),
    size: 25,
  );
  Icon _obscureTextIcon2 = const Icon(
    Icons.remove_red_eye,
    color: Color(0xFF4559f3),
    size: 25,
  );
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var textFormField = TextFormField(
      controller: repasswordController,
      decoration: const InputDecoration(
          fillColor: Colors.black,
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(
            right: 19.0,
          ),
          hintText: 'تأكيد كلمة المرور',
          hintStyle: TextStyle(
              color: Colors.black38,
              fontSize: 16.0,
              fontFamily: 'Cocan',
              fontWeight: FontWeight.bold)),
      obscureText: _obscureText,
      keyboardType: TextInputType.text,
      validator: validaterePassword,
      onSaved: (String val) {
        setState(() {
          _repassord = val;
        });
      },
    );
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('أكمال عملية التسجيل'),
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
                                controller: emailController,
                                decoration: const InputDecoration(
                                    fillColor: Colors.black,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                      right: 19.0,
                                    ),
                                    hintText: 'البريد الألكتروني',
                                    hintStyle: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 16.0,
                                        fontFamily: 'Cocan',
                                        fontWeight: FontWeight.bold)),
                                keyboardType: TextInputType.emailAddress,
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
                                  contentPadding: EdgeInsets.only(
                                    right: 19.0,
                                  ),
                                  hintText: "كلمة المرور",
                                  hintStyle: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 16.0,
                                      fontFamily: 'Cocan',
                                      fontWeight: FontWeight.bold),
                                ),
                                obscureText: _obscureTextPass,
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
                                  if (_obscureTextPass == true) {
                                    _obscureTextPass = false;
                                    _obscureTextIcon2 = Icon(
                                      Icons.lock,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      size: 25,
                                    );
                                  } else {
                                    _obscureTextPass = true;
                                    _obscureTextIcon2 = Icon(
                                      Icons.remove_red_eye,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      size: 25,
                                    );
                                  }
                                });
                              },
                              child: _obscureTextIcon2,
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
                              child: textFormField,
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        isLoading = true;
      });

      var data = {
        'phone': widget.phone,
        'state_key': widget.state_key,
        'country_id': widget.state_key,
        'username': userController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'device_token': 'test',
        'Latitude': 'test',
        'longitude': 'test',
        'language': 'ar'
      };

      var res = await Api().postData(data, ApiConfig.registerPath);

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
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
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
    if (value.length < 5) {
      return "يجب أن يكون اسم المستخدم أكثر من 5 أرقام أو أحرف";
    } else {
      return null;
    }
  }

  String validateMobile(String value) {
    if (value.length != 10) {
      return "رقم الهاتف مطلوب";
    } else {
      return null;
    }
  }

  String validateEmail(String value) {
    if (value != null) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = RegExp(pattern);
      if (!regex.hasMatch(value)) {
        return "أدخل بريد الكتروني صالح";
      } else {
        return null;
      }
    }
    return null;
  }

  String validatePassword(String value) {
    _passord = value;
    if (value.length < 8) {
      return "يجب أن تكون كلمة المرور أكثر من 8 أرقام أو أحرف";
    } else {
      return null;
    }
  }

  String validaterePassword(String value) {
    _repassord = value;
    if (value.length < 8) {
      return "يجب أن تكون كلمة المرور أكثر من 8 أرقام أو أحرف";
    } else if (_passord != value) {
      return 'كلمتا المرور غير متطابقتان';
    } else {
      return null;
    }
  }
}
