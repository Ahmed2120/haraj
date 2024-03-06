import 'package:flutter/material.dart';

import 'register_fnish.dart';

class RegisterNext extends StatefulWidget {
  final code, state_key, phone;
  const RegisterNext({this.code, this.phone, this.state_key});
  @override
  _RegisterNextState createState() => _RegisterNextState();
}

class _RegisterNextState extends State<RegisterNext> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool isLoading = false;
  String _code;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('كود التفعيل'),
        centerTitle: true,
        elevation: 0.4,
      ),
      body: Builder(
        builder: (_) {
          return Container(
            margin:
                const EdgeInsets.only(top: 50, right: 10, left: 10, bottom: 20),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: ListView(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
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
                    height: 65,
                    child: TextFormField(
                      controller: codeController,
                      decoration: const InputDecoration(
                        fillColor: Colors.black,
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.phone,
                      validator: validateCode,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 30.0,
                      ),
                      onSaved: (String val) {
                        _code = val;
                      },
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
                        onTap: isLoading ? null : _handleLogin,
                        child: Align(
                          child: Text(
                            isLoading ? "جارى..." : 'تفعيل',
                            style: const TextStyle(
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

  void _handleLogin() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        isLoading = true;
      });

      var data = {
        'code': int.parse(codeController.text),
      };

      if (widget.code == data['code']) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => RegisterFnish(
              phone: widget.phone,
              state_key: widget.state_key,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'كود التفعيل خاطئ',
              style: TextStyle(fontSize: 20, fontFamily: 'Cocan'),
            ),
            duration: const Duration(seconds: 3),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
        isLoading = false;
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String validateCode(String value) {
    if (value.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'أدخل كود التفعيل كامل',
            style: TextStyle(fontSize: 20, fontFamily: 'Cocan'),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    }
    return null;
  }
}
