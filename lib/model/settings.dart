import 'dart:convert';
import 'package:harajsedirah/api/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../helper/helper.dart';

getData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  http.Response response = await http
      .get(Uri.parse("${ApiConfig.baseUrl}/haraj1_get-settings"), headers: {
    "Accept": "application/json",
    "harajToken": ApiConfig.harajToken,
    "Accept-Language": 'ar'
  });

  if (response.statusCode == 200) {
    String responseBody = response.body;
    var responseJson = json.decode(responseBody);
    if (responseJson['status'] == true) {
      prefs.setString(
          'app_title', responseJson['data']['app_title'].toString());
      prefs.setString('app_desc', responseJson['data']['app_desc'].toString());
      prefs.setString('email', responseJson['data']['email'].toString());
      prefs.setString('phone', responseJson['data']['phone'].toString());
      prefs.setString('drawer_end_cat_id',
          responseJson['data']['drawer_end_cat_id'].toString());
      prefs.setString('active_model_cat_id',
          responseJson['data']['active_model_cat_id'].toString());
      prefs.setString('evaluation_rating_text',
          responseJson['data']['evaluation_rating_text'].toString());
      prefs.setString('evaluation_rating_show',
          responseJson['data']['evaluation_rating_show'].toString());
      prefs.setString('evaluation_add_show',
          responseJson['data']['evaluation_add_show'].toString());
      prefs.setString('evaluation_add_text',
          responseJson['data']['evaluation_add_text'].toString());
      prefs.setInt('omola', 1);
      return prefs;
    } else {
      //   print(responseJson['status']);
    }
  } else {
    //   print(response.statusCode);
  }
}
