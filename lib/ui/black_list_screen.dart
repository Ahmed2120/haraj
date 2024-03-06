import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:harajsedirah/api/api.dart';
import 'package:harajsedirah/api/api_config.dart';
import 'package:harajsedirah/ui/page_contents.dart';

class BlackListScreen extends StatefulWidget {
  const BlackListScreen({Key key}) : super(key: key);

  @override
  _BlackListScreenState createState() => _BlackListScreenState();
}

class _BlackListScreenState extends State<BlackListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _commision = TextEditingController();
  var _salary = TextEditingController();
  var _commissionSalary;

  var page_data;
  bool isLoading = false;
  List contentsWidgets = <Widget>[];
  List contents = [];
  _getPageData() async {
    var res = await Api()
        .getData("${ApiConfig.pagePath}?${ApiConfig.pageIdQueryParmKey}=5");
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("القائمة السوداء"),
        centerTitle: true,
        elevation: 0.4,
      ),
      body: Builder(
        builder: (_) {
          return ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, right: 10, left: 10, bottom: 10),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 10, right: 10),
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
                        isLoading ? page_data['page_title'] : "القائمة السوداء",
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
                      "البحث في القائمة السوداء",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 10, left: 10, top: 20, bottom: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 45.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        child: Material(
                          elevation: 0.1,
                          borderRadius: BorderRadius.circular(30.0),
                          child: TextField(
                            controller: _salary,
                            decoration: InputDecoration(
                              fillColor:
                                  Theme.of(context).colorScheme.secondary,
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.only(right: 19.0, top: 7.0),
                              hintText: "أدخل رقم الحساب أو رقم الجوال هنا",
                              hintStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 16.0,
                                  fontFamily: 'Cocan',
                                  fontWeight: FontWeight.bold),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              setState(() {
                                _commissionSalary = val;
                                _commision.text = _commissionSalary.toString();
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '$_commissionSalary',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                      Text(
                        ' رقم الحساب او الجوال غير موجود في القائمة السوداء ',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          );
        },
      ),
    );
  }
}
