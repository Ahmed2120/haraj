import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:harajsedirah/api/api.dart';

class RestPasswordScreen extends StatefulWidget {
  final String phone;
  final String otp;

  const RestPasswordScreen({Key key, this.phone, this.otp}) : super(key: key);
  static const routeName = "restPassword";
  @override
  State<RestPasswordScreen> createState() => _RestPasswordScreenState();
}

class _RestPasswordScreenState extends State<RestPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("تغيير كلمة المرور"),
        centerTitle: true,
        elevation: 0.4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(children: [
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: _passwordController,
              // inputFormatters: [
              //   FilteringTextInputFormatter.allow(
              //     RegExp("[0-9.]"),
              //   ),
              // ],
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2)),
                  fillColor: Colors.black,
                  contentPadding: const EdgeInsets.only(
                    right: 19.0,
                  ),
                  hintText: 'كلمة المرور الجديدة',
                  hintStyle: const TextStyle(
                      color: Colors.black38,
                      fontSize: 16.0,
                      fontFamily: 'Cocan',
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: _confirmPasswordController,
              // inputFormatters: [
              //   FilteringTextInputFormatter.allow(
              //     RegExp("[0-9.]"),
              //   ),
              // ],
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2)),
                  fillColor: Colors.black,
                  contentPadding: const EdgeInsets.only(
                    right: 19.0,
                  ),
                  hintText: ' تاكيد كلمة المرور الجديدة',
                  hintStyle: const TextStyle(
                      color: Colors.black38,
                      fontSize: 16.0,
                      fontFamily: 'Cocan',
                      fontWeight: FontWeight.bold)),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                  onPressed: validate,
                  child: const Text("حفظ"),
                  style: ElevatedButton.styleFrom(
                      // backgroundColor: Theme.of(context).primaryColor
                      )),
            ),
            const SizedBox(
              height: 50,
            )
          ]),
        ),
      ),
    );
  }

  bool validate() {
    if (_confirmPasswordController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "برجاء ادخال كلمة المرور",
            style: TextStyle(fontSize: 20, fontFamily: 'Cocan'),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    } else if (_confirmPasswordController.text.length <= 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'يجب أن تكون كلمة المرور أكثر من 8 أرقام أو أحرف',
            style: TextStyle(fontSize: 20, fontFamily: 'Cocan'),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    } else if (_confirmPasswordController.text != _passwordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'كلمتا المرور غير متطابقتان',
            style: TextStyle(fontSize: 20, fontFamily: 'Cocan'),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    } else {
      _changePasswird();
    }
  }

  void _changePasswird() async {
    setState(() {
      _isLoading = true;
    });

    var data = <String, dynamic>{
      'otp': widget.otp,
      'phone': widget.phone,
      "password": _passwordController.text,
      "password_confirmation": _confirmPasswordController.text
    };

    var res = await Api().postData(data, "/haraj1_newPass");

    final int statusCode = res.statusCode;
    log("Status Codeee" + statusCode.toString());
    log("Status Codeee" + res.body.toString());
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

      setState(() {
        _isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "تم تغير كلمة المرور بنجاح",
            style: TextStyle(fontSize: 20, fontFamily: 'Cocan'),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
      Navigator.of(context).pushReplacementNamed("login");
    }

    var body = json.decode(res.body);
    log(body.toString());
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
      setState(() {
        _isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "تم تغير كلمة المرور بنجاح",
            style: TextStyle(fontSize: 20, fontFamily: 'Cocan'),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
      Navigator.of(context).pushReplacementNamed("login");
    }

    //    If all data are not valid then start auto validation.
  }
}
