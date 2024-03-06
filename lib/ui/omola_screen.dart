import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:harajsedirah/api/api.dart';
import 'package:harajsedirah/api/api_config.dart';
import 'package:harajsedirah/ui/page_contents.dart';
import 'package:http/http.dart';

class OmolaScreen extends StatefulWidget {
  @override
  _OmolaScreenState createState() => _OmolaScreenState();
}

class _OmolaScreenState extends State<OmolaScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _commision = TextEditingController();
  final _salary = TextEditingController();
  final _adId = TextEditingController();
  var _commissionSalary = 0.0;

  var page_data;
  bool isLoading = false;
  List<Widget> contentsWidgets = <Widget>[];
  List contents = [];
  _getPageData() async {
    Response res = await Api()
        .getData("${ApiConfig.pagePath}?${ApiConfig.pageIdQueryParmKey}=1");

    log("Omola page response " + res.body.toString());
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
        title: const Text('حساب العمولة'),
        centerTitle: true,
        elevation: 0.4,
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
                        isLoading ? page_data['page_title'] : 'حساب العمولة',
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

              // حساب العموله بالميه
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
                        'حساب العمولة',
                        style: TextStyle(fontSize: 22, color: Colors.white),
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
                      'حساب قيمة العمولة',
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
                              hintText: 'إذا تم بيع السلعة بسعر',
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
                                _commissionSalary = (1 / 100) * int.parse(val);
                                _commision.text = _commissionSalary.toString();
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "فأن المبلغ المستحق دفعة هو ",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).primaryColor),
                            ),
                            Text(
                              '$_commissionSalary',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            Text(
                              "  ريال  ",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, 'payomola');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'دفع العمولة',
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).primaryColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).colorScheme.secondary,
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
