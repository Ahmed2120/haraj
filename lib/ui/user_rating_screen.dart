import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:harajsedirah/api/api.dart';
import 'package:harajsedirah/api/api_config.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UserRatingScreen extends StatefulWidget {
  var username;
  int user_id;
  UserRatingScreen({this.username, this.user_id});
  @override
  _UserRatingScreenState createState() => _UserRatingScreenState();
}

class _UserRatingScreenState extends State<UserRatingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _pledge = false;
  final _buy = 0;
  final _advice = 0;
  bool isEvaluation = false;
  bool isLoading = false;
  String evaluation_rating_text;
  TextEditingController ratingController = TextEditingController();

  _checkEvaluationRatingShow() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('evaluation_rating_text') != null) {
      setState(() {
        evaluation_rating_text = prefs.get('evaluation_rating_text');
        isEvaluation = true;
      });
    }
  }

  bool isQuestions = false;
  List questionsWidgets = [];
  List questions = [];
  int activeCount = 0;
  _getQuestions() async {
    var res = await Api().getData(ApiConfig.ratingQuestionsPath);
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {}
    var body = json.decode(res.body);
    if (body['status']) {
      var dataAd = body['data'];
      setState(() {
        questions = dataAd;
      });

      for (var question in questions) {
        questionsWidgets.add({
          "id": question['id'],
          "rate_title": question['rate_title'],
          'active': false
        });
      }
      setState(() {
        isQuestions = true;
      });
    }
  }

  bool isLogin = false;
  int user_from;
  void cheackLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('id') != null) {
      setState(() {
        isLogin = true;
        user_from = int.parse(prefs.get('id'));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkEvaluationRatingShow();
    _getQuestions();
    cheackLogin();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    const double itemHeight = 30;
    final double itemWidth = size.width / 3;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('أضافة تقييم'),
        centerTitle: true,
        elevation: 0.4,
      ),
      body: Builder(builder: (BuildContext context) {
        return Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50, right: 20, left: 20),
              child: ListView(
                children: <Widget>[
                  isEvaluation
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: CheckboxListTile(
                            value: _pledge,
                            onChanged: (val) {
                              setState(() {
                                _pledge = val;
                                if (val == true) {
                                  activeCount = activeCount + 1;
                                } else {
                                  activeCount = activeCount - 1;
                                }
                              });
                            },
                            activeColor:
                                Theme.of(context).colorScheme.secondary,
                            title: const Text('التعهد'),
                            subtitle: Text(evaluation_rating_text),
                            controlAffinity: ListTileControlAffinity.trailing,
                            selected: _pledge,
                            // key: ,
                          ),
                        )
                      : Container(),

                  isQuestions
                      ? Container(
                          margin: const EdgeInsets.all(18),
                          padding: const EdgeInsets.only(top: 10, bottom: 0),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(15.0),
                              topLeft: Radius.circular(15.0),
                            ),
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          child: GridView.builder(
                            addSemanticIndexes: true,
                            addAutomaticKeepAlives: true,
                            addRepaintBoundaries: true,
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: (itemWidth / itemHeight),
                            ),
                            itemCount: questionsWidgets.length,
                            itemBuilder: (BuildContext context, index) {
                              return CheckboxListTile(
                                value: questionsWidgets[index]['active'],
                                onChanged: (val) {
                                  setState(() {
                                    questionsWidgets[index]['active'] = val;
                                    if (val == true) {
                                      activeCount = activeCount + 1;
                                    } else {
                                      activeCount = activeCount - 1;
                                    }
                                  });
                                },
                                activeColor: Theme.of(context).primaryColor,
                                title: Text(
                                    '${questionsWidgets[index]['rate_title']}'),
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                selected: questionsWidgets[index]['active'],
                                // key: ,
                              );
                            },
                          ),
                        )
                      : Container(),

                  Padding(
                    padding: const EdgeInsets.only(
                        left: 18, right: 18, top: 10, bottom: 20),
                    child: Wrap(
                      children: const <Widget>[
                        Text('أذكر تجربتك للزوار'),
                      ],
                    ),
                  ),

                  // add comment
                  SizedBox(
                    height: 130,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 120,
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
                            padding: const EdgeInsets.only(left: 70),
                            child: Material(
                              color: Colors.white,
                              elevation: 0.1,
                              borderRadius: BorderRadius.circular(30.0),
                              child: TextFormField(
                                textDirection: TextDirection.rtl,
                                maxLines: null,
                                controller: ratingController,
                                keyboardType: TextInputType.multiline,
                                decoration: const InputDecoration(
                                    fillColor: Colors.black,
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.only(right: 19.0, top: 8.0),
                                    hintText: 'يمكنك كتابة تجربتك هنا',
                                    hintStyle: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 14.0,
                                        fontFamily: 'Cocan',
                                        fontWeight: FontWeight.bold)),
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
                      margin: const EdgeInsets.all(10),
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          primary: Theme.of(context).colorScheme.secondary,
                          elevation: 0.5,
                        ),
                        child: const Text(
                          'أرسال',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          isLogin
                              ? checkUser()
                              : ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'يرجي تسجيل الدخول أولا',
                                      style: TextStyle(
                                          fontSize: 20, fontFamily: 'Cocan'),
                                    ),
                                    duration: const Duration(seconds: 3),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                );
                          // Navigator.pushReplacementNamed(context, 'login');
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  void checkUser() {
    int checkActive = 0;
    if (isEvaluation) {
      setState(() {
        checkActive = checkActive + 1;
        checkActive = checkActive + questionsWidgets.length;
      });
    } else {
      setState(() {
        checkActive = checkActive + questionsWidgets.length;
      });
    }
    if (user_from == widget.user_id) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'لا يمكنك تقييم نفسك',
            style: TextStyle(fontSize: 20, fontFamily: 'Cocan'),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    } else {
      if (checkActive == activeCount) {
        _handleAddComment();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'يرجي الموافقه على الأسئلة السابقه',
              style: TextStyle(fontSize: 20, fontFamily: 'Cocan'),
            ),
            duration: const Duration(seconds: 3),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
      }
    }
  }

  void _handleAddComment() async {
    var data = {'user_to': widget.user_id, "comment": ratingController.text};

    if (ratingController.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'لايمكن ان يكون التعليق فارغ',
            style: TextStyle(fontSize: 20, fontFamily: 'Cocan'),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    } else {
      var res = await Api().postAuthData(data, ApiConfig.postRatingPath);
      final int statusCode = res.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'هناك خطأ ما جاري أصلاحة',
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
              body['msg'],
              style: const TextStyle(fontSize: 20, fontFamily: 'Cocan'),
            ),
            duration: const Duration(seconds: 3),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
      } else {
        setState(() {
          ratingController.text = '';
        });
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
      }
    }
  }
}
