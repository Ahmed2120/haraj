import 'dart:convert';
import 'dart:developer';

import 'package:harajsedirah/api/api.dart';

import 'package:harajsedirah/api/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

apiUrlImage(url) {
  // log("image ur requested =" + url.toString());
  return 'http://sedirah.com/storage/app/public/$url';
}

websiteUrl() {
  return 'http://sedirah.com';
}

harajToken() {
  return 'omar0966';
}

class Consts {
  Consts._();
  static const double padding = 16.0;
  static const double avatarRadius = 0.0;
}

class DialogReport extends StatelessWidget {
  var ad_id;
  DialogReport({Key key, this.ad_id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: DialogContentReport(id: ad_id),
    );
  }
}

class DialogContentReport extends StatefulWidget {
  var id;
  DialogContentReport({Key key, this.id}) : super(key: key);
  @override
  _DialogContentReportState createState() => _DialogContentReportState();
}

class _DialogContentReportState extends State<DialogContentReport> {
  var _report;
  bool isLoading = false;
  TextEditingController reportController = TextEditingController();
  Color _borderColor = Colors.black;
  bool isLogin = false;
  bool isError = false;
  var isErrorText;
  bool isSend = false;
  var isSendText;
  void cheackLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('token') != null) {
      setState(() {
        isLogin = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    cheackLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 225,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(Consts.padding),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding:
                      EdgeInsets.only(top: 70, right: 10, left: 10, bottom: 10),
                  child: Text(
                    "إذا كان الأعلان مخالف اترك لنا رسالة",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
                isError
                    ? Padding(
                        padding: const EdgeInsets.only(
                            top: 0, right: 10, left: 10, bottom: 10),
                        child: Container(
                          color: Colors.red,
                          height: 30,
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Text(
                            '$isErrorText',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 22),
                          ),
                        ),
                      )
                    : Container(),
                isSend
                    ? Padding(
                        padding: const EdgeInsets.only(
                            top: 0, right: 10, left: 10, bottom: 10),
                        child: Container(
                          color: Colors.green,
                          height: 30,
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Text(
                            '$isSendText',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 22),
                          ),
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 100,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 120,
                        margin: const EdgeInsets.only(right: 10, left: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                          border: Border.all(
                            width: 0.5,
                            color: _borderColor,
                          ),
                        ),
                        child: Material(
                          color: Colors.white,
                          elevation: 0.1,
                          borderRadius: BorderRadius.circular(30.0),
                          child: TextFormField(
                            textDirection: TextDirection.rtl,
                            maxLines: null,
                            controller: reportController,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              fillColor: Colors.black,
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.only(right: 10.0, left: 10),
                              hintText: "يمكنك كتابة تجربتك هنا",
                              hintStyle: TextStyle(
                                color: Colors.black38,
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold,
                              ),
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
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(Consts.padding),
                topLeft: Radius.circular(Consts.padding),
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onTap: () => Navigator.of(context).pop(),
                ),
                Text(
                  isLogin ? 'تبليغ' : 'يرجي تسجيل الدخول أولا',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                isLogin
                    ? InkWell(
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onTap: () {
                          isLoading ? null : _handleReport();
                        },
                      )
                    : InkWell(
                        child: const Icon(
                          Icons.person_add,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, 'login');
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleReport() async {
    setState(() {
      isLoading = true;
    });

    var data = {
      'ad_id': widget.id,
      'content': reportController.text,
    };

    var res = await Api().postAuthData(data, ApiConfig.reportAdPath);
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      setState(() {
        isLoading = false;
      });
    }

    var body = json.decode(res.body);
    if (body['status'] == false) {
      if (body['data']['content'][0] != null) {
        setState(() {
          _borderColor = Colors.red;
        });
      }
      setState(() {
        isLoading = false;
        isSend = false;
        isError = true;
        isErrorText = body['msg'];
      });
    } else {
      setState(() {
        isLoading = false;
        _borderColor = Colors.black;
        isSend = true;
        isSendText = body['msg'];
        isError = false;
      });
    }
  }
}

class CustomDialogAuth extends StatelessWidget {
  final cityOld;
  const CustomDialogAuth({Key key, this.cityOld}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: DialogContentAuth(city: cityOld),
    );
  }
}

class DialogContentAuth extends StatefulWidget {
  final city;
  const DialogContentAuth({Key key, this.city}) : super(key: key);
  @override
  _DialogContentAuthState createState() => _DialogContentAuthState();
}

class _DialogContentAuthState extends State<DialogContentAuth> {
  bool _visibleColors = false;
  Color _borderColors = Colors.black26;
  var _chooseCityId;
  var _chooseCityIndex;
  String _chosseCityName;
  List cities = [];

  _getCities() async {
    var res = await Api().getData(ApiConfig.citiesPath);
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {}
    var body = json.decode(res.body);
    if (body['status']) {
      var dataCities = body['data'];
      setState(() {
        cities = dataCities;
        cities.insert(0, {"id": '', "city_name": "كل المدن"});
        _chosseCityName = widget.city != ''
            ? cities[widget.city[0]]['city_name']
            : cities[0]['city_name'];
        _chooseCityId = widget.city != '' ? widget.city[1] : cities[0]['id'];
      });
    }
  }

  @override
  void initState() {
    _getCities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: const EdgeInsets.only(top: Consts.avatarRadius),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 0),
                      child: Text(
                        "المدينة",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _visibleColors = _visibleColors == false ? true : false;
                        _borderColors = _borderColors == Colors.black26
                            ? Colors.black87
                            : Colors.black26;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: _borderColors,
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(right: 20, left: 20),
                            child: Text(_chosseCityName,
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: _visibleColors,
                child: Container(
                  height: MediaQuery.of(context).size.height / 2.4,
                  color: Colors.white.withOpacity(0.7),
                  // margin: EdgeInsets.only(top: 155),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _chooseCityId = cities[index]['id'];
                                  _chosseCityName = cities[index]['city_name'];
                                  _chooseCityIndex = index;
                                  _visibleColors = false;
                                  _borderColors = Colors.black26;
                                });
                              },
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.all(15),
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      color:
                                          _chooseCityId == cities[index]['id']
                                              ? Theme.of(context).primaryColor
                                              : Colors.transparent,
                                      border: Border.all(
                                        color: _chosseCityName ==
                                                cities[index]['id']
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                        width: 3,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Text('${cities[index]['city_name']}',
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: cities.length,
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              Container(
                margin: const EdgeInsets.only(top: 6),
                height: 1.5,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 16.0),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      // color: Theme.of(context).primaryColor,
                      width: MediaQuery.of(context).size.width / 3,
                      child: TextButton(
                        onPressed: () {
                          var cityData = [0, ''];
                          Navigator.of(context).pop(cityData);
                        },
                        child: const Text(
                          "إلغاء",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      width: MediaQuery.of(context).size.width / 3,
                      child: TextButton(
                        onPressed: () async {
                          var cityData = [_chooseCityIndex, _chooseCityId];
                          Navigator.of(context).pop(cityData);
                        },
                        child: const Text(
                          "موافق",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
