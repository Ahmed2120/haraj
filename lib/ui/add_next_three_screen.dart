import 'dart:convert';
import 'dart:developer';

import 'package:harajsedirah/api/api.dart';
import 'package:harajsedirah/api/api_config.dart';

import 'package:harajsedirah/ui/error_screen.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'add_next_four_screen.dart';

class AddNextThreeScreen extends StatefulWidget {
  final int categoryId;
  final bool car;
  const AddNextThreeScreen({Key key, this.categoryId, this.car})
      : super(key: key);
  @override
  _AddNextThreeScreenState createState() => _AddNextThreeScreenState();
}

class _AddNextThreeScreenState extends State<AddNextThreeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  File file;
  bool isUpload = false;
  var picker = ImagePicker();
  void _chooseImage() async {
    var pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        file = File(pickedFile.path);
      });
    }
  }

  void _chooseCamera() async {
    var pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        file = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("أضافة إعلان"),
        centerTitle: true,
        elevation: 0.4,
        actions: <Widget>[
          IconButton(
            icon: FittedBox(
              child: Text(
                isUpload ? "جارى..." : "التالي",
                style: const TextStyle(fontSize: 13),
              ),
            ),
            onPressed: () {
              if (!isUpload) {
                if (file != null) {
                  isUpload ? null : _handleAddAd(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        "أضف الصورة الرئيسية",
                        style: TextStyle(fontSize: 20, fontFamily: 'Cocan'),
                      ),
                      duration: const Duration(seconds: 5),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: Builder(
        builder: (_) {
          return ListView(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: _chooseImage,
                      child: Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width / 2.2,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(15.0),
                            topLeft: Radius.circular(15.0),
                          ),
                        ),
                        child: const Center(
                            child: Text(
                          "ألبوم الصور",
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        )),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _chooseCamera();
                      },
                      child: Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width / 2.2,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(15.0),
                            topLeft: Radius.circular(15.0),
                          ),
                        ),
                        child: const Center(
                            child: Text(
                          "الكاميرا",
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                children: <Widget>[
                  file != null
                      ? Container(
                          height: MediaQuery.of(context).size.width / 2,
                          margin: const EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width / 1,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          child: file == null
                              ? const Text('لم يتم اختيار صورة')
                              : Image.file(
                                  file,
                                  fit: BoxFit.cover,
                                ),
                        )
                      : Container(),
                  Positioned(
                    right: 10,
                    child: Container(
                      width: 40,
                      height: 40,
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          width: 1,
                          color: Colors.red,
                        ),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 10,
                        minHeight: 10,
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            file = null;
                          });
                        },
                        child: const Center(
                          child: Icon(
                            Icons.delete,
                            size: 30,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _handleAddAd(BuildContext context) async {
    try {
      if (file == null || isUpload) return;
      setState(() {
        isUpload = true;
      });

      String base64Image = base64Encode(file.readAsBytesSync());
      String fileName = file.path.split("/").last;
      final Response res = await Api().postData(
          {"image": base64Image, "name": fileName, "folder": 'ads'},
          ApiConfig.uploudAdImagePath);
      if (res.statusCode != 200) {
        throw Exception("Server Error");
      }
      //   print(res.statusCode);
      //   print(res.body);
      log("response" + res.body.toString());
      isUpload = false;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AddNextFourScreen(
                categoryId: widget.categoryId,
                car: widget.car,
                imageCover: json.decode(res.body)['data']),
          ));
      setState(() {
        isUpload = false;
      });
    } catch (e) {
      MaterialPageRoute(builder: (context) => ErrorScreen(e.toString()));
    }
  }
}
