import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  String _username = "";
  String _phone = "";
  String _stateKey = "";
  String _email = "";
  String _image = "";
  String _token = "";
  String _id = "";
  bool _isLoading = true;
  void readUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //  print(prefs.get('id'));

    _username = prefs.get('username');

    _email = prefs.get('email');

    _image = prefs.get('img');
    _phone = prefs.get('phone');
    _stateKey = prefs.get('state_key');
    _id = prefs.get('id');
    _token = prefs.get('token');
    _isLoading = false;
    notifyListeners();
  }

  String get email => _email;
  String get phone => _phone;
  String get stateKey => _stateKey;
  String get username => _username;
  String get id => _id;
  String get token => _token;
  String get image => _image;
  bool get isLoading => _isLoading;
}
