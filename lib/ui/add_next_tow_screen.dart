import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:harajsedirah/api/api.dart';
import 'package:harajsedirah/api/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_next_three_screen.dart';

class AddNextTowScreen extends StatefulWidget {
  final int categoryId;
  final bool car;
  const AddNextTowScreen({Key key, this.categoryId, this.car})
      : super(key: key);
  @override
  _AddNextTowScreenState createState() => _AddNextTowScreenState();
}

class _AddNextTowScreenState extends State<AddNextTowScreen> {
  bool isData = false;
  List pledgesWidgets = [];
  bool evaluation_add_show = false;
  String evaluation_add_text;
  _getPledges() async {
    var res = await Api().getData(ApiConfig.pledgesPath);
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
    } else {
      var body = json.decode(res.body);
      if (body['status']) {
        var dataSections = body['data'];
        setState(() {
          pledges = dataSections;
          isData = true;
        });

        for (var pledge in pledges) {
          pledgesWidgets.add(
              {"id": pledge['id'], "desc": pledge['desc'], 'active': false});
        }
        setState(() {
          isData = true;
        });
      }
    }
  }

  _checkEvaluationAddText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('evaluation_rating_text') != null) {
      setState(() {
        evaluation_add_text = prefs.get('evaluation_add_text');
        evaluation_add_show = true;
      });
    }
  }

  List pledges = [];
  var _pledge = false;
  int activeCount = 0;

  @override
  void initState() {
    super.initState();
    _checkEvaluationAddText();
    _getPledges();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    const double itemHeight = 40;
    final double itemWidth = size.width / 3;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("أضافة إعلان"),
        centerTitle: true,
        elevation: 0.4,
        actions: <Widget>[
          IconButton(
            icon: const FittedBox(
                child: Text("التالي", style: TextStyle(fontSize: 13))),
            onPressed: () {
              isData ? nextStep() : null;
            },
          ),
        ],
      ),
      body: Builder(
        builder: (_) {
          return ListView(
            children: <Widget>[
              evaluation_add_show
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.9),
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(15.0),
                            topLeft: Radius.circular(15.0),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // Text('بسم الله الرحمن الرحيم ',style: TextStyle(fontSize: 18,color: Colors.white),),
                            // Text('قال الله تعالي',style: TextStyle(fontSize: 18,color: Colors.white),),
                            // Padding(
                            //   padding: const EdgeInsets.all(20),
                            //   child: Text(
                            //     'وَأَوْفُواْ بِعَهْدِ اللهِ إِذَا عَاهَدتُّمْ وَلاَ تَنقُضُواْ الأَيْمَانَ بَعْدَ تَوْكِيدِهَا وَقَدْ جَعَلْتُمُ اللهَ عَلَيْكُمْ كَفِيلاً',
                            //     style: TextStyle(fontSize: 18,color: Colors.white),
                            //   ),
                            // ),
                            // Text('صدق الله العظيم',style: TextStyle(fontSize: 18,color: Colors.white),),
                            Text(
                              evaluation_add_text,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(15.0),
                    topLeft: Radius.circular(15.0),
                  ),
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                child: GridView.builder(
                  addSemanticIndexes: true,
                  addAutomaticKeepAlives: true,
                  addRepaintBoundaries: true,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: (itemWidth / itemHeight),
                  ),
                  itemCount: pledgesWidgets.length,
                  itemBuilder: (BuildContext context, index) {
                    return Container(
                      margin: const EdgeInsets.all(10),
                      child: CheckboxListTile(
                        value: pledgesWidgets[index]['active'],
                        onChanged: (val) {
                          setState(() {
                            pledgesWidgets[index]['active'] = val;
                            if (val) {
                              activeCount = activeCount + 1;
                            } else {
                              activeCount = activeCount - 1;
                            }
                          });
                          if (activeCount == 3) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddNextThreeScreen(
                                      categoryId: widget.categoryId,
                                      car: widget.car),
                                ));
                          }
                        },
                        activeColor: Theme.of(context).primaryColor,
                        title: const Text("التعهد"),
                        subtitle: Text(
                          '${pledgesWidgets[index]['desc']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        controlAffinity: ListTileControlAffinity.trailing,
                        selected: pledgesWidgets[index]['active'],
                        // key: ,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void nextStep() {
    if (activeCount == pledgesWidgets.length) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AddNextThreeScreen(
                categoryId: widget.categoryId, car: widget.car),
          ));
    }
  }
}
