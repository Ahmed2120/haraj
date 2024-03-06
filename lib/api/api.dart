import 'dart:convert';
import 'dart:developer';
import 'package:harajsedirah/api/api_config.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/helper.dart';

class Api {
  postData(data, path) async {
    var fullUrl = ApiConfig.baseUrl + path;
    log("postdata url  " + fullUrl);
    log("postdata data  " + data.toString());
    return await http
        .post(Uri.parse(fullUrl), body: jsonEncode(data), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "harajToken": ApiConfig.harajToken,
      "Accept-Language": 'ar'
    });
  }

  getData(path) async {
    var fullUrl = ApiConfig.baseUrl + path;
    log("getData " + fullUrl);
    return await http.get(Uri.parse(fullUrl), headers: {
      "Content-Type": "application/json",
      "Accept-Language": 'ar',
      "Accept": "application/json",
      "harajToken": ApiConfig.harajToken,
      // != null ? 'ar': 'ar'
    });
  }

  postAuthData(data, path) async {
    // data.remove('image_cover');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var fullUrl = ApiConfig.baseUrl + path;
    final token = prefs.get('token');
    log("http://" + token);
    log("postAuth :" + fullUrl + "Token :" + token);

    final resonse = await http.post(
      Uri.parse(fullUrl),
      body: jsonEncode(data),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "harajToken": ApiConfig.harajToken,
        "Accept-Language": 'ar',
        "auth": token,
      },
    );
    return resonse;
  }

  uploadImage(data, id, apiUrl, fieldName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var fullUrl = ApiConfig.baseUrl + apiUrl;
    var uri = Uri.parse(fullUrl);

    log(
      "Uploud image path:$apiUrl data :$data id:$id filedName:$fieldName ",
    );
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "harajToken": harajToken(),
      "Accept-Language": 'ar',
      "auth": prefs.get('token'),
    };
    var stream = http.ByteStream(data['image'].openRead());
    stream.cast();
    var length = await data['image'].length();

    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(headers);
    request.fields['ad_id'] = id.toString();

    var multipartFile = http.MultipartFile(fieldName, stream, length,
        filename: basename(data['image'].path));

    request.files.add(multipartFile);
    // var response = await request.send();

    request.send().then((response) async {
      return response.statusCode;
    });
    // request.send().then((response) {
    //   if (response.statusCode == 200) print("Uploaded!");
    // });
    // response.stream.transform(utf8.decoder).listen((value) {
    //   var res =  json.decode(value);
    //   print(res);
    // });
  }

  getAuthData(path) async {
    var fullUrl = ApiConfig.baseUrl + path;
    return await http.get(Uri.parse(fullUrl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "harajToken": ApiConfig.harajToken,
      "Accept-Language": 'ar'
    });
  }
}
