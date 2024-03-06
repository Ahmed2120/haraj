import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:harajsedirah/api/api.dart';

import 'package:harajsedirah/api/api_config.dart';

import 'package:harajsedirah/ui/screens/home/home_screen.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class EditAdScreen extends StatefulWidget {
  final String adId, adTitle, phone, description;
  const EditAdScreen(
      {Key key, this.adId, this.adTitle, this.phone, this.description})
      : super(key: key);
  @override
  _EditAdScreenState createState() => _EditAdScreenState();
}

class _EditAdScreenState extends State<EditAdScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  TextEditingController adTitle;
  TextEditingController phone;
  TextEditingController description;
  String _adTitle, _phone, _description;
  bool _autoValidate = false;
  bool isLoading = false;

  File file;
  final List _imageList = [];
  final List _imageListString = [];
  File _image;

  bool isUpload = false;
  var picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    adTitle = TextEditingController(text: widget.adTitle);
    phone = TextEditingController(text: widget.phone);
    description = TextEditingController(text: widget.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("أضافة إعلان"),
        centerTitle: true,
        elevation: 0.4,
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
                                  maxLines: null,
                                  keyboardType: TextInputType.text,
                                  controller: adTitle,
                                  decoration: const InputDecoration(
                                      fillColor: Colors.black,
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                          right: 19.0, top: 8.0),
                                      hintText: "أدخل عنوان الأعلان",
                                      hintStyle: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 14.0,
                                          fontFamily: 'Cocan',
                                          fontWeight: FontWeight.bold)),
                                  validator: (value) => value.isEmpty
                                      ? "عنوان الأعلان مطلوب"
                                      : null,
                                  onSaved: (String val) {
                                    _adTitle = val;
                                  }),
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
                                maxLines: null,
                                keyboardType: TextInputType.phone,
                                controller: phone,
                                decoration: const InputDecoration(
                                    fillColor: Colors.black,
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.only(right: 19.0, top: 8.0),
                                    hintText: "أدخل رقم الجوال",
                                    hintStyle: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 14.0,
                                        fontFamily: 'Cocan',
                                        fontWeight: FontWeight.bold)),
                                onSaved: (String val) {
                                  _phone = val;
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
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                controller: description,
                                decoration: const InputDecoration(
                                    fillColor: Colors.black,
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.only(right: 19.0, top: 8.0),
                                    hintText: "أدخل نص الأعلان",
                                    hintStyle: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 14.0,
                                        fontFamily: 'Cocan',
                                        fontWeight: FontWeight.bold)),
                                validator: (value) =>
                                    value.isEmpty ? "نص الأعلان مطلوب" : null,
                                onSaved: (String val) {
                                  _description = val;
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(20),
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),

                          // backgroundColor:
                          //     Theme.of(context).colorScheme.secondary,
                          // elevation: 0.5,
                        ),
                        child: const Text(
                          "أرسال",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          isLoading ? null : _handleAdd(context);
                        },
                      ),
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

  void _handleAdd(BuildContext context) {
    _validateInputs(context);
  }

  void _validateInputs(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        isLoading = true;
      });
      log(widget.adId, name: "add_id");
      var data = {
        "ad_id": widget.adId,
        "ad_title": _adTitle,
        "phone": _phone,
        "description": _description,
      };

      var res = await Api().postAuthData(data, ApiConfig.updateAdPath);
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
      } else {
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
      }

      Future initData() async {
        await Future.delayed(const Duration(seconds: 2));
      }

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
