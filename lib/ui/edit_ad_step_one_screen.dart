import 'package:flutter/material.dart';
import 'edite_ad_screen.dart';
import 'edit_images_screen.dart';
import 'edit_category_screen.dart';
import 'edit_location_screen.dart';

class EditAdStepOne extends StatefulWidget {
  int id;
  EditAdStepOne({Key key, this.id}) : super(key: key);
  @override
  _EditAdStepOneState createState() => _EditAdStepOneState();
}

class _EditAdStepOneState extends State<EditAdStepOne> {
  var langChoose;
  bool isLang = false;

  List categoreis = [
    {
      "id": 1,
      "section_name_ar": "تعديل نص الأعلان ووسيلة الأتصال",
      "section_name_en": "Edit title And phone",
      "route": "EditText"
    },
    {
      "id": 2,
      "section_name_ar": "تعديل الصور",
      "section_name_en": "Edit images",
      "route": "EditImages"
    },
    {
      "id": 3,
      "section_name_ar": "تعديل القسم",
      "section_name_en": "Edit section",
      "route": "EditCategory"
    },
    {
      "id": 4,
      "section_name_ar": "تعديل المكان",
      "section_name_en": "Edit Location",
      "route": "EditLocation"
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
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    const double itemHeight = 25;
    final double itemWidth = size.width / 3;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("تعديل الأعلان"),
        centerTitle: true,
        elevation: 0.4,
      ),
      body: Builder(
        builder: (_) {
          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 20, left: 20),
            child: GridView.builder(
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
                    if (categoreis[index]['route'] == 'EditText') {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditAdScreen(
                                    id: widget.id,
                                  )));
                    } else if (categoreis[index]['route'] == 'EditImages') {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditImagesScreen(
                                    id: widget.id,
                                  )));
                    } else if (categoreis[index]['route'] == 'EditCategory') {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditCategory(
                                    id: widget.id,
                                  )));
                    } else if (categoreis[index]['route'] == 'EditLocation') {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditLocation(
                                    id: widget.id,
                                  )));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 3.4,
                    margin: const EdgeInsets.only(bottom: 10),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Row(
                            children: <Widget>[
                              Text(
                                isLang
                                    ? categoreis[index]['section_name_ar']
                                    : '',
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
