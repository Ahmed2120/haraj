import 'dart:async';

import 'package:flutter/material.dart';
import 'package:harajsedirah/api/api.dart';
import 'package:harajsedirah/api/api_config.dart';

import 'package:harajsedirah/helper/helper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'edit_ad_step_one_screen.dart';

class EditImagesScreen extends StatefulWidget {
  int id;
  EditImagesScreen({this.id});
  @override
  _EditImagesScreenState createState() => _EditImagesScreenState();
}

class _EditImagesScreenState extends State<EditImagesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  File file;
  final List _imageList = [];
  File _image;
  List images = [];
  List ad_images = [];
  Future<File> _imageFile;
  bool isUpload = false;
  bool isUploadOuther = false;
  var picker = ImagePicker();
  void _chooseImage() async {
    var pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
    });

    if (_image != null) {
      setState(() {
        isUpload = true;
      });
      var data = {'image': _image, 'ad_id': widget.id};
      await Api().uploadImage(
          data, widget.id, ApiConfig.editAdPath, ApiConfig.imageCoverFieldName);

      Future initData() async {
        await Future.delayed(const Duration(seconds: 10));
      }

      initData().then((value) {
        setState(() {
          isUpload = false;
        });
        _getAdData();
      });
    }
  }

  void _chooseCamera() async {
    var pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile.path);
    });

    if (_image != null) {
      setState(() {
        isUpload = true;
      });
      var data = {'image': _image, 'ad_id': widget.id};
      await Api().uploadImage(
          data, widget.id, ApiConfig.editAdPath, ApiConfig.imageCoverFieldName);

      Future initData() async {
        await Future.delayed(const Duration(seconds: 10));
      }

      initData().then((value) {
        setState(() {
          isUpload = false;
        });

        _getAdData();
      });
    }
  }

  void _chooseImageOuther() async {
    var pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedImage.path);
    });
    if (_image != null) {
      setState(() {
        isUploadOuther = true;
      });
      var data = {'image': _image, 'ad_id': widget.id};
      await Api()
          .uploadImage(data, widget.id, ApiConfig.editAdPath, 'images[0]');
      Future initData() async {
        await Future.delayed(const Duration(seconds: 10));
      }

      initData().then((value) {
        images.clear();
        _getAdData();
        setState(() {
          isUploadOuther = false;
        });
      });
    }
  }

  void _chooseCameraOuther() async {
    var pickedImage = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedImage.path);
    });

    if (_image != null) {
      setState(() {
        isUploadOuther = true;
      });
      var data = {'image': _image, 'ad_id': widget.id};
      await Api()
          .uploadImage(data, widget.id, ApiConfig.editAdPath, 'images[0]');
      Future initData() async {
        await Future.delayed(const Duration(seconds: 10));
      }

      initData().then((value) {
        images.clear();
        _getAdData();
        setState(() {
          isUploadOuther = false;
        });
      });
    }
  }

  var ad_data;
  bool isAdData = false;
  _getAdData() async {
    var res = await Api().getData(
        '${ApiConfig.adPath}?${ApiConfig.adIdQueryParmKey}=${widget.id}');
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {}
    var body = json.decode(res.body);
    if (body['status']) {
      var dataAd = body['data'];
      setState(() {
        ad_data = dataAd;
        ad_images = dataAd['getimages'];
        isAdData = true;
      });

      for (var adImage in ad_images) {
        images.add(
          {'image_id': adImage['id'], 'image': apiUrlImage(adImage['image'])},
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getAdData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("تعديل الأعلان"),
        centerTitle: true,
        elevation: 0.4,
        actions: <Widget>[
          IconButton(
            icon: const Text(
              "حفظ",
              style: TextStyle(fontSize: 13),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    "تم تعديل الأعلان",
                    style: TextStyle(fontSize: 20, fontFamily: 'Cocan'),
                  ),
                  duration: const Duration(seconds: 1),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              );
              Future initData() async {
                await Future.delayed(const Duration(seconds: 1));
              }

              initData().then((value) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditAdStepOne(id: widget.id)));
              });
            },
          ),
        ],
      ),
      body: Builder(
        builder: (_) {
          return Container(
            margin: const EdgeInsets.all(20),
            child: ListView(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: const Text("الصورة الرئيسية",
                      style: TextStyle(fontSize: 18)),
                ),
                isAdData
                    ? Stack(
                        children: <Widget>[
                          Container(
                              height: MediaQuery.of(context).size.width / 2.5,
                              margin: const EdgeInsets.all(20),
                              width: MediaQuery.of(context).size.width / 1,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              child: Image.network(
                                  apiUrlImage(ad_data['image_cover']))),
                        ],
                      )
                    : Container(),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: const Text("تغيير الصورة الرئيسية",
                      style: TextStyle(fontSize: 18)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: isUpload ? null : _chooseImage,
                      child: Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width / 2.3,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(15.0),
                            topLeft: Radius.circular(15.0),
                          ),
                        ),
                        child: Center(
                            child: Text(
                          isUpload ? "جارى..." : "ألبوم الصور",
                          style: const TextStyle(
                              fontSize: 22, color: Colors.white),
                        )),
                      ),
                    ),
                    InkWell(
                      onTap: isUpload ? null : _chooseCamera,
                      child: Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width / 2.3,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(15.0),
                            topLeft: Radius.circular(15.0),
                          ),
                        ),
                        child: Center(
                            child: Text(
                          isUpload ? "جارى..." : "الكاميرا",
                          style: const TextStyle(
                              fontSize: 22, color: Colors.white),
                        )),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10, top: 10),
                  child: const Text("الصور الأضافية",
                      style: TextStyle(fontSize: 18)),
                ),
                Column(
                    children: images
                        .map((item) => Stack(
                              children: <Widget>[
                                Container(
                                  height: MediaQuery.of(context).size.width / 2,
                                  margin: const EdgeInsets.all(20),
                                  width: MediaQuery.of(context).size.width / 1,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  child: Image.network(item['image']),
                                ),
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
                                        _handleDelete(item['image_id']);
                                        setState(() {
                                          images.removeAt(
                                              images.lastIndexOf(item));
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
                            ))
                        .toList()),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child:
                      const Text("أضافة صورة", style: TextStyle(fontSize: 18)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: _chooseImageOuther,
                      child: Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width / 2.3,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(15.0),
                            topLeft: Radius.circular(15.0),
                          ),
                        ),
                        child: Center(
                            child: Text(
                          isUploadOuther ? "جارى..." : "ألبوم الصور",
                          style: const TextStyle(
                              fontSize: 22, color: Colors.white),
                        )),
                      ),
                    ),
                    InkWell(
                      onTap: _chooseCameraOuther,
                      child: Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width / 2.3,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(15.0),
                            topLeft: Radius.circular(15.0),
                          ),
                        ),
                        child: Center(
                            child: Text(
                          isUploadOuther ? "جارى..." : "الكاميرا",
                          style: const TextStyle(
                              fontSize: 22, color: Colors.white),
                        )),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleDelete(int imageId) async {
    var data = {
      'image_id': imageId,
      'ad_id': ad_data['id'],
    };

    var res = await Api().postAuthData(data, ApiConfig.deleteAdImagePath);
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
    }

    var body = json.decode(res.body);
    if (body['status'] == false) {
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
    }
  }
}
