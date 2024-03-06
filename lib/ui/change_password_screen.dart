import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'package:http/http.dart' as http;
import 'register.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return Directionality(
          textDirection: //'ar' == "ar" ?
              TextDirection.rtl, //: TextDirection.ltr,
          child: Material(
            child: Stack(
              children: <Widget>[
                //  AppBarBackgroundSection(),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(71.0),
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      // backgroundColor:Theme.of(context).primaryColor,
                      elevation: 0.1,
                      iconTheme: const IconThemeData(color: Colors.white),
                      centerTitle: true,
                      title: const Padding(
                        padding: EdgeInsets.only(right: 0.0),
                        child: Text('تغيير كلمة المرور',
                            style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'Cocan',
                                color: Colors.white)),
                      ),
                    ),
                  ),
                  body: Padding(
                    padding:
                        const EdgeInsets.only(top: 50, right: 10, left: 10),
                    child: Stack(
                      children: const <Widget>[
                        MyCustomForm(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ));
    });
  }
}

class Post {
  final String userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map["userId"] = userId;
    map["title"] = title;
    map["body"] = body;

    return map;
  }
}

Future<Post> createPost(String url, {Map body}) async {
  return http.post(Uri.parse(url), body: body).then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw Exception("Error while fetching data");
    }
    return Post.fromJson(json.decode(response.body));
  });
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key key}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  final Future<Post> post;
  MyCustomFormState({Key key, this.post});
  // url
  static const createPostUrl = 'https://jsonplaceholder.typicode.com/posts';

  // inputs controller
  TextEditingController codeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();
  // valdite name
  bool _autoValidate = false;
  bool _visible = false;
  String _code;
  String _passord;
  String _repassord;
  bool _obscureText = true;
  bool _obscureTextPass = true;
  Icon _obscureTextIcon = const Icon(
    Icons.remove_red_eye,
    color: Colors.white,
    size: 20,
  );
  final _obscureTextIcon2 = const Icon(
    Icons.remove_red_eye,
    color: Colors.white,
    size: 20,
  );
  @override
  Widget build(BuildContext context) {
    var textFormField = TextFormField(
      controller: repasswordController,
      decoration: const InputDecoration(
          fillColor: Colors.black,
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(right: 19.0, top: 12.0),
          hintText: ' تأكيد كلمة المرور الجديدة',
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
    return ListView(
      children: <Widget>[
        Center(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 60.0,
                      width: MediaQuery.of(context).size.width / 7.2,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(25.0),
                            topRight: Radius.circular(25.0)),
                        border: Border.all(
                          width: 0.5,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      child: const Icon(
                        Icons.security,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                    Container(
                      height: 60.0,
                      width: MediaQuery.of(context).size.width / 1.3,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(25.0),
                            topLeft: Radius.circular(25)),
                        border: Border.all(
                          width: 0.5,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      child: Material(
                        elevation: 0.1,
                        borderRadius: BorderRadius.circular(30.0),
                        child: TextFormField(
                          textDirection: TextDirection.rtl,
                          controller: codeController,
                          decoration: const InputDecoration(
                              fillColor: Colors.black,
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.only(right: 19.0, top: 17.0),
                              hintText: ' كود التفعيل',
                              hintStyle: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 16.0,
                                  fontFamily: 'Cocan',
                                  fontWeight: FontWeight.bold)),
                          keyboardType: TextInputType.number,
                          validator: validateCode,
                          onSaved: (String val) {
                            _code = val;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 60.0,
                        width: MediaQuery.of(context).size.width / 7.2,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(25.0),
                              topRight: Radius.circular(25.0)),
                          border: Border.all(
                            width: 0.5,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        child: const Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      Container(
                        height: 60.0,
                        width: MediaQuery.of(context).size.width / 1.5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // borderRadius: BorderRadius.only(
                          //   bottomLeft: const Radius.circular(25.0),
                          //   topLeft: const Radius.circular(25)
                          // ),
                          border: Border.all(
                            width: 0.5,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        child: Material(
                          elevation: 0.1,
                          borderRadius: BorderRadius.circular(30.0),
                          child: TextFormField(
                            controller: passwordController,
                            decoration: const InputDecoration(
                                fillColor: Colors.black,
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.only(right: 19.0, top: 17.0),
                                hintText: ' كلمة المرور الجديدة',
                                hintStyle: TextStyle(
                                    color: Colors.black38,
                                    fontSize: 16.0,
                                    fontFamily: 'Cocan',
                                    fontWeight: FontWeight.bold)),
                            obscureText: _obscureText,
                            keyboardType: TextInputType.text,
                            validator: validatePassword,
                            onSaved: (String val) {
                              _passord = val;
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: 60.0,
                        width: MediaQuery.of(context).size.width / 8.7,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(25.0),
                              topLeft: Radius.circular(25.0)),
                          border: Border.all(
                            width: 0.5,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (_obscureText == true) {
                                _obscureText = false;
                                _obscureTextIcon = const Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                  size: 20,
                                );
                              } else {
                                _obscureText = true;
                                _obscureTextIcon = const Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.white,
                                  size: 20,
                                );
                              }
                            });
                          },
                          child: _obscureTextIcon,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 60.0,
                        width: MediaQuery.of(context).size.width / 7.2,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(25.0),
                              topRight: Radius.circular(25.0)),
                          border: Border.all(
                            width: 0.5,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        child: const Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      Container(
                        height: 60.0,
                        width: MediaQuery.of(context).size.width / 1.5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // borderRadius: BorderRadius.only(
                          //   bottomLeft: const Radius.circular(25.0),
                          //   topLeft: const Radius.circular(25)
                          // ),
                          border: Border.all(
                            width: 0.5,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        child: Material(
                          elevation: 0.1,
                          borderRadius: BorderRadius.circular(30.0),
                          child: textFormField,
                        ),
                      ),
                      Container(
                        height: 60.0,
                        width: MediaQuery.of(context).size.width / 8.7,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(25.0),
                              topLeft: Radius.circular(25.0)),
                          border: Border.all(
                            width: 0.5,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (_obscureText == true) {
                                _obscureText = false;
                                _obscureTextIcon = const Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                  size: 20,
                                );
                              } else {
                                _obscureText = true;
                                _obscureTextIcon = const Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.white,
                                  size: 20,
                                );
                              }
                            });
                          },
                          child: _obscureTextIcon,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.only(right: 10, left: 10, top: 20),
                        child: Text(
                          'تسجيل الدخول ',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 15.0,
                              fontFamily: 'Cocan',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Register(),
                          ),
                        );
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.only(right: 10, left: 10, top: 20),
                        child: Text(
                          'تسجيل جديد',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 15.0,
                              fontFamily: 'Cocan',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                    margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                    height: 60,
                    width: MediaQuery.of(context).size.width / 1,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: InkWell(
                      onTap: () async {
                        _validateInputs();

                        // Post newPost = Post(
                        //   userId: "123", id: 0, title: phoneController.text, body: userController.text
                        // );
                        // Post p = await createPost(CREATE_POST_URL,
                        //     body: newPost.toMap());
                        // print(p.title);
                      },
                      child: const Align(
                        child: Text(
                          'حفظ',
                          style: TextStyle(
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
        ),
        Center(
          child: Visibility(
            visible: _visible,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: Container(
              margin: const EdgeInsets.only(top: 100),
              width: 160,
              height: 40,
              color: Theme.of(context).colorScheme.secondary,
              child: Align(
                alignment: Alignment.center,
                child: Text('تم تغيير كلمة المرور',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Cocan',
                      color: Theme.of(context).primaryColor,
                    )),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      setState(() {
        _visible = true;
      });
      _formKey.currentState.save();
      initData().then((value) {
        _visible = false;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  Future initData() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  String validateCode(String value) {
    if (value.isEmpty)
      return 'ادخل كود التفعيل';
    else
      return null;
  }

  String validatePassword(String value) {
    _passord = value;
    if (value.length < 8)
      return 'يجب أن تكون كلمة المرور أكثر من 8 أرقام أو أحرف';
    else
      return null;
  }

  String validaterePassword(String value) {
    _repassord = value;
    if (value.length < 8)
      return 'يجب أن تكون كلمة المرور أكثر من 8 أرقام أو أحرف';
    else if (_passord != value)
      return 'كلمتا المرور غير متطابقتان';
    else
      return null;
  }
}
