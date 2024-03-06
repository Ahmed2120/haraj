import 'dart:convert';
import 'dart:developer';

import 'package:harajsedirah/api/api_config.dart';
import 'package:harajsedirah/model/home_data.dart';
import 'package:http/http.dart';

import '../api/api.dart';

class AdService {
  Future<HomeData> readHomeData(String uid) async {
    print('AdSErvice');
    Response res = await Api().getData(
        '${ApiConfig.sectionsPath}?${ApiConfig.userIdQueryParmKey}=$uid');
    final int statusCode = res.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      log(res.body.toString());
      throw Exception("Server Error");
    }
    print('====================');
    print(res.body.toString());
    final homeData = HomeData.fromJson(res.body);
    return homeData;
  }
}
