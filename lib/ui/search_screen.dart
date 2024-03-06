import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:harajsedirah/api/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api.dart';
import 'search_ad_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static const List<String> shortItems = [
    'أختر ماركة السيارة',
    'حراج السيارات',
    'حراج العقارات',
    'حراج الأجهزة',
    'كل الحراج',
  ];

  static const List<String> shortItems2 = [
    'أختر النوع',
    'حراج السيارات',
    'حراج العقارات',
    'حراج الأجهزة',
    'كل الحراج',
  ];

  static const List<String> shortItems3 = [
    'أختر الموديل',
    'حراج السيارات',
    'حراج العقارات',
    'حراج الأجهزة',
    'كل الحراج',
  ];

  String shortSpinnerValue = shortItems[0];
  String shortSpinnerValue2 = shortItems2[0];
  String shortSpinnerValue3 = shortItems3[0];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("البحث فى حراج السديرة"),
        centerTitle: true,
        elevation: 0.4,
      ),
      body: Builder(builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.only(top: 20),
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 100,
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 90,
                      margin: const EdgeInsets.only(right: 10, left: 10),
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
                        padding: const EdgeInsets.only(left: 20),
                        child: Material(
                          color: Colors.white,
                          elevation: 0.1,
                          borderRadius: BorderRadius.circular(30.0),
                          child: TextFormField(
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            controller: searchController,
                            decoration: const InputDecoration(
                                fillColor: Colors.black,
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.only(right: 19.0, top: 8.0),
                                hintText: "أبحث عن سلعة",
                                hintStyle: TextStyle(
                                    color: Colors.black38,
                                    fontSize: 14.0,
                                    fontFamily: 'Cocan',
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Align(
                        alignment: Alignment
                            .bottomLeft, //'ar' == 'ar' ? Alignment.bottomLeft : Alignment.bottomRight,
                        child: InkWell(
                          onTap: () {
                            searchController.text != ''
                                ? _handleSearch()
                                : ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        "يرجي أدخال عن ماذا تبحث",
                                        style: TextStyle(
                                            fontSize: 20, fontFamily: 'Cocan'),
                                      ),
                                      duration: const Duration(seconds: 3),
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  );
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.7),
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(15.0),
                                topLeft: Radius.circular(15.0),
                              ),
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            child: const Icon(Icons.search,
                                color: Colors.white, size: 25),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Container(
              //   margin: EdgeInsets.only(top: 40,right: 10,left: 10),
              //   height: 1,
              //   color: Theme.of(context).colorScheme.secondary,
              // ),

              // Container(
              //   margin: EdgeInsets.only(top: 40,left: 20,right: 20),
              //   child: Text('بحث السيارات',
              //     style : TextStyle(
              //       color: Theme.of(context).primaryColor,
              //       fontSize: 15.0,
              //     )
              //   ),
              // ),

              // Container(
              //   height: 50,
              //   margin: EdgeInsets.only(top: 20,left: 20,right: 20),
              //   padding: EdgeInsets.only(right: 15,left: 15),
              //   decoration: BoxDecoration(
              //     color: Theme.of(context).colorScheme.secondary,
              //     borderRadius: BorderRadius.circular(10.0),
              //   ),
              //   child: DropdownButton(
              //     elevation: 0,
              //     underline: Container(),
              //     value: shortSpinnerValue,
              //     icon: Icon(Icons.arrow_drop_down_circle,color: Colors.white,),
              //     isExpanded: true,
              //     onChanged: (string) => setState(() => shortSpinnerValue = string),
              //     items: shortItems.map((string) {
              //       return  DropdownMenuItem(
              //         child: Text(string),
              //         value: string,
              //       );
              //     }).toList(),
              //   ),
              // ),
              // Container(
              //   height: 50,
              //   margin: EdgeInsets.only(top: 20,left: 20,right: 20),
              //   padding: EdgeInsets.only(right: 15,left: 15),
              //   decoration: BoxDecoration(
              //     color: Theme.of(context).colorScheme.secondary,
              //     borderRadius: BorderRadius.circular(10.0),
              //   ),
              //   child: DropdownButton(
              //     elevation: 0,
              //     underline: Container(),
              //     value: shortSpinnerValue2,
              //     icon: Icon(Icons.arrow_drop_down_circle,color: Colors.white,),
              //     isExpanded: true,
              //     onChanged: (string) => setState(() => shortSpinnerValue2 = string),
              //     items: shortItems2.map((string) {
              //       return  DropdownMenuItem(
              //         child: Text(string),
              //         value: string,
              //       );
              //     }).toList(),
              //   ),
              // ),
              // Container(
              //   height: 50,
              //   margin: EdgeInsets.only(top: 20,left: 20,right: 20),
              //   padding: EdgeInsets.only(right: 15,left: 15),
              //   decoration: BoxDecoration(
              //     color: Theme.of(context).colorScheme.secondary,
              //     borderRadius: BorderRadius.circular(10.0),
              //   ),
              //   child: DropdownButton(
              //     elevation: 0,
              //     underline: Container(),
              //     value: shortSpinnerValue3,
              //     icon: Icon(Icons.arrow_drop_down_circle,color: Colors.white,),
              //     isExpanded: true,
              //     onChanged: (string) => setState(() => shortSpinnerValue3 = string),
              //     items: shortItems3.map((string) {
              //       return  DropdownMenuItem(
              //         child: Text(string),
              //         value: string,
              //       );
              //     }).toList(),
              //   ),
              // ),

              // Align(
              //   alignment: FractionalOffset.bottomCenter,
              //   child: Container(
              //     height: 50,
              //     margin: EdgeInsets.only(top: 50,left: 5,right: 5),
              //     padding: EdgeInsets.only(right: 15,left: 15),
              //     width: double.infinity,
              //     child:  RaisedButton(
              //       elevation: 0.5,
              //       child: Text("بحث",style: TextStyle(color: Colors.white,fontSize: 20),),
              //       color:Theme.of(context).primaryColor,
              //       onPressed: (){
              //         // Navigator.pushReplacementNamed(context, 'login');
              //       },
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      }),
    );
  }

  void _handleSearch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = {
      'keywords': searchController.text,
      'country_id': prefs.get('country_id')
    };
    var res = await Api().postData(data, ApiConfig.adsFilterPath);
    final int statusCode = res.statusCode;
    //print(statusCode);

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
    }

    var body = json.decode(res.body);
    //  print(body);
    if (body['status'] == false) {
      //   print(body['status']);
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
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SearchAdScreen(
                    keyword: data['keywords'],
                  )));
    }
  }
}
