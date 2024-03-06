import 'dart:convert';
import 'package:flutter/material.dart';
import '../api/api.dart';
import '../api/api_config.dart';
import 'page_contents.dart';

class DiscountSystemScreen extends StatefulWidget {
  const DiscountSystemScreen({Key key}) : super(key: key);

  @override
  _DiscountSystemScreenState createState() => _DiscountSystemScreenState();
}

class _DiscountSystemScreenState extends State<DiscountSystemScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var page_data;
  bool isLoading = false;
  List contentsWidgets = <Widget>[];
  List contents = [];
  _getPageData() async {
    var res = await Api()
        .getData("${ApiConfig.pagePath}?${ApiConfig.pageIdQueryParmKey}=3");
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
        title: const Text("نظام الخصم"),
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
                        isLoading ? page_data['page_title'] : "نظام الخصم",
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
