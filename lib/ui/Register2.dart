import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:harajsedirah/api/api_config.dart';
import 'package:harajsedirah/helper/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final Future<Post> post;
  _RegisterState({Key key, this.post});
  // url
  static final CREATE_POST_URL =
      "${ApiConfig.baseUrl}/${ApiConfig.confirmPhonePath}";
  // inputs controller
  TextEditingController phoneController = TextEditingController();
  TextEditingController keyController = TextEditingController();

  // valdite name
  bool _autoValidate = false;
  String _mobile;
  String _key;
  String _selectionCountries;
  String _error;
  List<Map> countries = [
    {
      "id": "1",
      "name": 'السعودية (966)',
    },
    {
      "id": "2",
      "name": 'السعودية (967)',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('التسجيل'),
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
                  Container(
                    margin: const EdgeInsets.only(right: 10, left: 10),
                    child: _error != null
                        ? Text(_error,
                            style: const TextStyle(color: Colors.red))
                        : Container(),
                  ),
                  SizedBox(
                    height: 65,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 1,
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
                            padding: const EdgeInsets.only(
                                left: 25, right: 25, top: 3),
                            child: Material(
                              color: Colors.white,
                              elevation: 0.1,
                              borderRadius: BorderRadius.circular(30.0),
                              child: DropdownButton(
                                value: _selectionCountries,
                                hint: const Text('أختر الدولة'),
                                underline: Container(),
                                icon: Icon(
                                  Icons.arrow_drop_down_circle,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                isExpanded: true,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectionCountries = newValue;
                                    _error = '';
                                  });
                                },
                                items: countries.map((Map map) {
                                  return DropdownMenuItem(
                                    value: map["id"].toString(),
                                    child: Text(
                                      map["name"],
                                    ),
                                  );
                                }).toList(),
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
                                controller: phoneController,
                                decoration: const InputDecoration(
                                    fillColor: Colors.black,
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.only(right: 19.0, top: 12.0),
                                    hintText: 'رقم الجوال',
                                    hintStyle: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 16.0,
                                        fontFamily: 'Cocan',
                                        fontWeight: FontWeight.bold)),
                                keyboardType: TextInputType.phone,
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
                        onTap: () async {
                          if (_selectionCountries == null) {
                            setState(() {
                              _error = 'أختر الدولة';
                            });
                          } else {
                            setState(() {
                              _error = '';
                            });
                          }
                          _validateInputs();
                        },
                        child: const Align(
                          child: Text(
                            'التسجيل',
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
          );
        },
      ),
    );
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context)=>  RegisterNext(),
      //   ),
      // );
    } else {
      //    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String validateMobile(String value) {
    if (value.length != 10) {
      return 'يجب أن يكون رقم الجوال من 10 أرقام';
    } else {
      return null;
    }
  }
}

class Post {
  final String state_key;
  final String phone;
  Post({this.state_key, this.phone});
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      state_key: json['state_key'],
      phone: json['phone'],
    );
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map["state_key"] = state_key;
    map["phone"] = phone;
    return map;
  }
}

Future<Post> createPost(String url, {Map body}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return http
      .post(Uri.parse(url),
          headers: {
            "Accept": "application/json",
            "harajToken": harajToken(),
            "Accept-Language": 'ar'
          },
          body: body)
      .then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw Exception("Error while fetching data");
    }
    var responseJson = json.decode(response.body);
    // if(responseJson['status'] == false){
    //     return responseJson['status'];
    // }else{
    //    return responseJson['status'];
    // }
    return responseJson;
  });
}
