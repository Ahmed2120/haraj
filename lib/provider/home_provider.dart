import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:harajsedirah/api/api.dart';
import 'package:harajsedirah/api/api_config.dart';
import 'package:harajsedirah/main.dart';
import 'package:harajsedirah/model/home_data.dart';
import 'package:harajsedirah/services/ad_service.dart';
import 'package:harajsedirah/util/Themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider extends ChangeNotifier {
  final _adService = AdService();

  List<SectionCategory> categoreis = [];
  List<Ad> ads = [];

  bool isLogin = false;
  bool _visibleMore = false;
  final bool _visibleApps = false;

  bool isData = false, isAdsLoading = true;

  bool get visibleMore => _visibleMore;

  Future<void> init() async {
    await _cheackLogin();
    await _getSections();
  }

  Future<void> _getSections() async {
    log("get sections called");
    try {
      final homeData = await _adService.readHomeData(userId);

      if (homeData.status) {
        categoreis = homeData.sectionCategory;
        ads = homeData.ads;
        isData = true;
        isAdsLoading = false;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "هناك مشكله ما جارى حلها",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    notifyListeners();
  }

  void toggleVisibilty() {
    _visibleMore = _visibleMore == true ? false : true;

    notifyListeners();
  }

  void setVisibilty(bool isVisibile) {
    _visibleMore = isVisibile;
    notifyListeners();
  }

  Future<void> _cheackLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('token') != null) {
      isLogin = true;
      if (isLogin) {
        userId = prefs.get('id');

        log("User Id = " + userId.toString());
      }
      notifyListeners();
    }
  }

  void handleFavorite(int indexItem, BuildContext context) async {
    var data = {
      'ad_id': ads[indexItem].id,
    };

    var res = await Api().postAuthData(data, ApiConfig.favoritePath);
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      // Fluttertoast.showToast(
      //   msg: "هناك خطأ ما جاري أصلاحة",
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.SNACKBAR,
      //   timeInSecForIosWeb: 10,
      //   backgroundColor: Colors.redAccent,
      //   textColor: Colors.white,
      //   fontSize: 16.0,
      // );
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
    log("response ::" + body.toString());
    log(body.toString());
    if (body["data"]['user_id'] == null) {
      ads[indexItem].favUser = false;
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
      ads[indexItem].favUser = true;

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
    notifyListeners();
  }

  void ChangeCollection(int c) async {
    CollectionCount = c;

    notifyListeners();
  }
}
