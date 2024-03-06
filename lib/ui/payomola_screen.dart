import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:harajsedirah/api/api.dart';
import 'package:harajsedirah/api/api_config.dart';
import 'package:harajsedirah/ui/page_contents.dart';

class PayomolaScreen extends StatefulWidget {
  @override
  _PayomolaScreenState createState() => _PayomolaScreenState();
}

class _PayomolaScreenState extends State<PayomolaScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  _PayomolaScreenState({Key key});
  TextEditingController username,
      amount,
      transfer_full_name,
      phone,
      ad_id,
      notes = TextEditingController();
  String _username, _amount, _transfer_full_name, _phone, _ad_id, _notes;
  bool _autoValidate = false;
  bool isLoadingSend = false;
  //String lang;

  List transferText = [
    {"text_ar": 'اليوم', "text_en": 'Today'},
    {"text_ar": 'أمس', "text_en": 'yesterday'},
    {"text_ar": 'قبل أمس', "text_en": 'before yesterday'},
    {"text_ar": 'قبل ثلاثة أيام', "text_en": 'Three days ago'},
    {"text_ar": 'قبل أربع أيام', "text_en": 'Four days ago'},
    {"text_ar": 'قبل خمس أيام', "text_en": 'Five days ago'},
    {"text_ar": 'قبل ست أيام', "text_en": 'Six days ago'},
    {"text_ar": 'قبل أسبوع', "text_en": 'A week ago'},
    {"text_ar": 'قبل أكثر من أسبوع', "text_en": 'More than a week ago'},
  ];
  String _selectionTransferText;

  // banks
  bool isBanks = false;
  String _selectionBank;
  List banks = [];

  _getBanks() async {
    var res = await Api().getData(ApiConfig.banksPath);
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {}
    var body = json.decode(res.body);
    if (body['status']) {
      var data = body['data'];
      setState(() {
        banks = data;
        isBanks = true;
      });
    }
  }

  var page_data;
  bool isLoading = false;
  List contentsWidgets = <Widget>[];
  List contents = [];
  _getPageData() async {
    var res = await Api()
        .getData('${ApiConfig.pagePath}?${ApiConfig.pageIdQueryParmKey}=2');
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {}
    var body = json.decode(res.body);
    if (body['status']) {
      var data = body['data'];
      setState(() {
        page_data = data;
        contents = page_data['contents'];
        isLoading = true;
      });
      for (var content in contents) {
        contentsWidgets.add(PageContents(
            content_title: content['content_title'], id: content['id']));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getPageData();
    _getBanks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('دفع العمولة'),
        centerTitle: true,
        elevation: 0.4,
        actions: <Widget>[
          IconButton(
            icon: const Text(
              'أرسال',
              style: TextStyle(fontSize: 13),
            ),
            onPressed: () {
              _handleTransfers();
            },
          ),
        ],
      ),
      body: Builder(
        builder: (_) {
          return ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(15.0),
                      topLeft: Radius.circular(15.0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        isLoading ? page_data['page_title'] : 'دفع العمولة',
                        style:
                            const TextStyle(fontSize: 22, color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          isLoading ? page_data['page_desc'] : '',
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              isLoading
                  ? Column(
                      children: contentsWidgets,
                    )
                  : Column(
                      children: const [],
                    ),
              Padding(
                padding: const EdgeInsets.only(top: 5, right: 10, left: 10),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(15.0),
                      topLeft: Radius.circular(15.0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const <Widget>[
                      Text(
                        "بعد إرسال المبلغ،يجب مراسلتنا عبر النموذج التالي لأجل تسجيل العمولة بأسم عضويتك ثم الحصول على مميزات الموقع الخاصة بالعملاء:",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(right: 20, left: 20),
                    padding: const EdgeInsets.only(
                        right: 20, left: 20, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(15.0),
                        topLeft: Radius.circular(15.0),
                      ),
                    ),
                    child: const Text(
                      'نموذج تحويل العمولة',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 70,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height: 50,
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
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: Material(
                                    color: Colors.white,
                                    elevation: 0.1,
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: TextFormField(
                                      controller: username,
                                      maxLines: null,
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                          fillColor: Colors.black,
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              right: 19.0, top: 8.0),
                                          hintText: 'اسم المستخدم',
                                          hintStyle: TextStyle(
                                              color: Colors.black38,
                                              fontSize: 14.0,
                                              fontFamily: 'Cocan',
                                              fontWeight: FontWeight.bold)),
                                      validator: validateName,
                                      onSaved: (String val) {
                                        _username = val;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 70,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height: 50,
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
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: Material(
                                    color: Colors.white,
                                    elevation: 0.1,
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: TextFormField(
                                      controller: amount,
                                      maxLines: null,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                          fillColor: Colors.black,
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              right: 19.0, top: 8.0),
                                          hintText: 'مبلغ العمولة',
                                          hintStyle: TextStyle(
                                              color: Colors.black38,
                                              fontSize: 14.0,
                                              fontFamily: 'Cocan',
                                              fontWeight: FontWeight.bold)),
                                      validator: validateAmount,
                                      onSaved: (String val) {
                                        _amount = val;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        isBanks
                            ? Container(
                                height: 50,
                                margin: const EdgeInsets.only(bottom: 15),
                                padding:
                                    const EdgeInsets.only(right: 15, left: 15),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(25.0),
                                    topRight: Radius.circular(0.0),
                                    bottomLeft: Radius.circular(0.0),
                                    topLeft: Radius.circular(25.0),
                                  ),
                                ),
                                child: DropdownButton(
                                  elevation: 0,
                                  underline: Container(),
                                  value: _selectionBank,
                                  icon: const Icon(
                                    Icons.arrow_drop_down_circle,
                                    color: Colors.white,
                                  ),
                                  hint: const Text('أختر البنك'),
                                  isExpanded: true,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      _selectionBank = newValue;
                                    });
                                  },
                                  items: banks.map((item) {
                                    return DropdownMenuItem<String>(
                                      value: item["id"].toString(),
                                      child: Text(
                                        "${item["bank_name"]}",
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )
                            : Container(),
                        Container(
                          height: 50,
                          margin: const EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.only(right: 15, left: 15),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(25.0),
                              topRight: Radius.circular(0.0),
                              bottomLeft: Radius.circular(0.0),
                              topLeft: Radius.circular(25.0),
                            ),
                          ),
                          child: DropdownButton(
                            elevation: 0,
                            underline: Container(),
                            value: _selectionTransferText,
                            hint: const Text("متي تم التحويل؟"),
                            icon: const Icon(
                              Icons.arrow_drop_down_circle,
                              color: Colors.white,
                            ),
                            isExpanded: true,
                            onChanged: (string) =>
                                setState(() => _selectionTransferText = string),
                            items: transferText.map((item) {
                              return DropdownMenuItem<String>(
                                value: item["text_ar"].toString(),
                                child: Text(
                                  "${item["text_ar"]}",
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          height: 70,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height: 50,
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
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: Material(
                                    color: Colors.white,
                                    elevation: 0.1,
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: TextFormField(
                                      controller: transfer_full_name,
                                      maxLines: null,
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                          fillColor: Colors.black,
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              right: 19.0, top: 8.0),
                                          hintText: 'إسم المحول',
                                          hintStyle: TextStyle(
                                              color: Colors.black38,
                                              fontSize: 14.0,
                                              fontFamily: 'Cocan',
                                              fontWeight: FontWeight.bold)),
                                      validator: validatefullName,
                                      onSaved: (String val) {
                                        _transfer_full_name = val;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 70,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height: 50,
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
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: Material(
                                    color: Colors.white,
                                    elevation: 0.1,
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: TextFormField(
                                      controller: phone,
                                      maxLines: null,
                                      keyboardType: TextInputType.phone,
                                      decoration: const InputDecoration(
                                          fillColor: Colors.black,
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              right: 19.0, top: 8.0),
                                          hintText: 'أدخل رقم الجوال',
                                          hintStyle: TextStyle(
                                              color: Colors.black38,
                                              fontSize: 14.0,
                                              fontFamily: 'Cocan',
                                              fontWeight: FontWeight.bold)),
                                      validator: validateMobile,
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
                          height: 70,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height: 50,
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
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: Material(
                                    color: Colors.white,
                                    elevation: 0.1,
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: TextFormField(
                                      controller: ad_id,
                                      maxLines: null,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                          fillColor: Colors.black,
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              right: 19.0, top: 8.0),
                                          hintText: 'رقم الأعلان',
                                          hintStyle: TextStyle(
                                              color: Colors.black38,
                                              fontSize: 14.0,
                                              fontFamily: 'Cocan',
                                              fontWeight: FontWeight.bold)),
                                      validator: validateAdId,
                                      onSaved: (String val) {
                                        _ad_id = val;
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
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: Material(
                                    color: Colors.white,
                                    elevation: 0.1,
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: TextFormField(
                                      controller: notes,
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      decoration: const InputDecoration(
                                          fillColor: Colors.black,
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              right: 19.0, top: 8.0),
                                          hintText: 'ملاحظات',
                                          hintStyle: TextStyle(
                                              color: Colors.black38,
                                              fontSize: 14.0,
                                              fontFamily: 'Cocan',
                                              fontWeight: FontWeight.bold)),
                                      validator: validateNotes,
                                      onSaved: (String val) {
                                        _notes = val;
                                      },
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
                ),
              ),
              Container(
                  margin: const EdgeInsets.all(20),
                  child: const Text(
                      "# نرجو الحرص أن تكون معلومات التحويل صحيحة ودقيقة",
                      style: TextStyle(fontSize: 15))),
              const SizedBox(
                height: 30,
              ),
            ],
          );
        },
      ),
    );
  }

  void _handleTransfers() {
    _validateInputs();
  }

  void _validateInputs() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        isLoadingSend = true;
      });

      var data = {
        'username': _username,
        'amount': _amount,
        'bank_name': _selectionBank,
        'transfers_date': _selectionTransferText,
        'transfer_full_name': _transfer_full_name,
        'phone': 01095616771,
        'ad_id': 123522,
        'notes': _notes,
      };

      var res = await Api().postData(data, ApiConfig.transfersPath);
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

        setState(() {
          isLoadingSend = false;
        });
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
        setState(() {
          isLoadingSend = false;
        });
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
        setState(() {
          isLoadingSend = false;
        });

        // Future initData() async {
        //   await Future.delayed(Duration(seconds: 2));
        // }

        // initData().then((value) {
        //   Navigator.pushNamed(context, 'home');
        // });

      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String validateName(String value) {
    if (value.length < 8) {
      return "الرجاء أدحال اسم المستخدم";
    } else {
      return null;
    }
  }

  String validateAmount(String value) {
    if (value.isEmpty) {
      return "مبلغ العمولة مطلوب";
    } else {
      return null;
    }
  }

  String validatefullName(String value) {
    if (value.length < 8) {
      return "أسم المحول مطلوب";
    } else {
      return null;
    }
  }

  String validateMobile(String value) {
    if (value.length != 11) {
      return "رقم الهاتف مطلوب";
    } else {
      return null;
    }
  }

  String validateAdId(String value) {
    if (value.length < 5) {
      return "رقم الأعلان مطلوب";
    } else {
      return null;
    }
  }

  String validateNotes(String value) {
    if (value.length < 0) {
      return "مبلغ العمولة مطلوب";
    } else {
      return null;
    }
  }
}
