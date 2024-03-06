import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:harajsedirah/api/api.dart';
import 'package:harajsedirah/api/api_config.dart';

class PageContents extends StatefulWidget {
  var content_title, id;
  PageContents({this.content_title, this.id});
  @override
  _PageContentsState createState() => _PageContentsState();
}

class _PageContentsState extends State<PageContents> {
  List pagedesc = [];
  bool isLoading = false;
  List page_desc = <Widget>[];
  _getPageDescData() async {
    var res = await Api().getData(
        '${ApiConfig.pageContentPath}?${ApiConfig.pageContentIdQueryParmKey}=${widget.id}');
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {}
    var body = json.decode(res.body);
    if (body['status']) {
      var data = body['data'];
      setState(() {
        pagedesc = data;
      });
      for (var pagd in pagedesc) {
        page_desc.add(Text('- ${pagd['page_desc']}'));
      }

      setState(() {
        isLoading = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getPageDescData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 20, left: 20),
          padding:
              const EdgeInsets.only(right: 20, left: 20, top: 5, bottom: 5),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(15.0),
              topLeft: Radius.circular(15.0),
            ),
          ),
          child: Text(
            "${widget.content_title}",
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(15.0),
                topLeft: Radius.circular(15.0),
              ),
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary,
                width: 1,
              ),
            ),
            child: isLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: page_desc)
                : Column(),
          ),
        ),
      ],
    );
  }
}
