import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:harajsedirah/api/api.dart';
import 'package:harajsedirah/api/api_config.dart';
import 'package:harajsedirah/helper/helper.dart';
import 'add_next_tow_screen.dart';

class AddAdScreen extends StatefulWidget {
  const AddAdScreen({Key key}) : super(key: key);

  @override
  _AddAdScreenState createState() => _AddAdScreenState();
}

class _AddAdScreenState extends State<AddAdScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  AnimationController controller;
  Animation animation;
  bool isData = false;
  _getSections() async {
    var res = await Api().getData(ApiConfig.sectionsPath);
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
    } else {
      var body = json.decode(res.body);
      if (body['status']) {
        var dataSections = body['data'];
        setState(() {
          categoreis = dataSections;
          isData = true;
        });
      }
    }
  }

  List categoreis = [
    {
      "id": 1,
      "section_name": "حراج السيارات",
      "image": "assets/sections/car2.png",
      "section_desc":
          "يمكنك أضافة في - سيارات للبيع - شاحنات للبيع - شاحنه للايجار - دباب للبيع - قطع وأكسسورات للسيارات",
    },
    {
      "id": 2,
      "section_name": "حراج العقارات",
      "image": "assets/sections/home1.png",
      "section_desc":
          "يمكنك أضافة في - سيارات للبيع - شاحنات للبيع - شاحنه للايجار - دباب للبيع - قطع وأكسسورات للسيارات",
    },
    {
      "id": 3,
      "section_name": "حراج الأجهزة",
      "image": "assets/sections/electronic2.png",
      "section_desc":
          "يمكنك أضافة في - سيارات للبيع - شاحنات للبيع - شاحنه للايجار - دباب للبيع - قطع وأكسسورات للسيارات",
    },
    {
      "id": 4,
      "section_name": "مواشي وحيوانات وطيور",
      "image": "assets/sections/animal1.png",
      "section_desc":
          "يمكنك أضافة في - سيارات للبيع - شاحنات للبيع - شاحنه للايجار - دباب للبيع - قطع وأكسسورات للسيارات",
    }
  ];
  List gradient = [
    {'begin': Alignment.topLeft, 'end': Alignment.bottomRight},
    {'begin': Alignment.topRight, 'end': Alignment.bottomLeft},
    {'begin': Alignment.topLeft, 'end': Alignment.bottomRight},
    {'begin': Alignment.topRight, 'end': Alignment.bottomLeft}
  ];

  @override
  void initState() {
    super.initState();
    _getSections();
    controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    animation = ColorTween(
      begin: Colors.transparent,
      end: Colors.red.withOpacity(0.9),
    ).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    const double itemHeight = 65;
    final double itemWidth = size.width / 3;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("أضافة إعلان"),
        centerTitle: true,
        elevation: 0.4,
      ),
      body: Builder(
        builder: (_) {
          return GridView.builder(
            addSemanticIndexes: true,
            addAutomaticKeepAlives: true,
            addRepaintBoundaries: true,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: (itemWidth / itemHeight),
            ),
            itemCount: categoreis.length,
            itemBuilder: (BuildContext context, index) {
              return InkWell(
                onTap: () {
                  var car = false;
                  log(categoreis[index]['id'].toString());
                  if (categoreis[index]['id'] == 1) {
                    car = true;
                    log(categoreis[index]['id'].toString());
                    log(car.toString());
                  } else {
                    log("False");
                  }
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddNextTowScreen(
                                categoryId: categoreis[index]['id'],
                                car: car,
                              )));
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 3.4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: index < 4
                          ? gradient[index]['begin']
                          : Alignment.topLeft,
                      end: index < 4
                          ? gradient[index]['end']
                          : Alignment.bottomRight,
                      stops: const [0.1, 0.5, 0.7, 0.9],
                      colors: [
                        Colors.grey[100],
                        Colors.grey[200],
                        Colors.grey[300],
                        Colors.grey[400],
                      ],
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        alignment: Alignment
                            .centerLeft, //'ar' == 'ar' ?  Alignment.centerLeft : Alignment.centerRight,
                        child: isData
                            ? Opacity(
                                opacity: controller.value,
                                child: Image.network(
                                  apiUrlImage(categoreis[index]['image']),
                                  width:
                                      MediaQuery.of(context).size.width / 1.6,
                                ))
                            : Opacity(
                                opacity: controller.value,
                                child: Container(),
                              ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        alignment: Alignment.center,
                        child: Text(
                          categoreis[index]['section_name'],
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height / 22,
                              //'ar' == 'en' ? MediaQuery.of(context).size.height / 24 : MediaQuery.of(context).size.height / 22 ,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        alignment: Alignment
                            .bottomRight, //'ar' == 'ar' ? Alignment.bottomRight: Alignment.bottomLeft,
                        child: Text(
                          isData ? categoreis[index]['section_addad_text'] : '',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  dispose() {
    controller.dispose(); // you need this
    super.dispose();
  }
}
