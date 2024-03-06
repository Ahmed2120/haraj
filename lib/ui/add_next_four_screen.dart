import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:harajsedirah/api/api.dart';
import 'package:harajsedirah/util/Themes.dart';
import 'dart:io';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import '../api/api_config.dart';
import 'add_next_finish_screen.dart';

class AddNextFourScreen extends StatefulWidget {
  final int categoryId;
  final String imageCover;
  final bool car;
  const AddNextFourScreen({Key key, this.categoryId, this.imageCover, this.car})
      : super(key: key);
  @override
  _AddNextFourScreenState createState() => _AddNextFourScreenState();
}

class _AddNextFourScreenState extends State<AddNextFourScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  TextEditingController adTitle = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController description = TextEditingController();
  String _adTitle, _phone, _description;
  bool _autoValidate = false;
  bool isLoading = false;

  File file;
  final List _imageList = [];
  final List _imageListString = [];
  File _image;

  bool isUpload = false;
  var picker = ImagePicker();

  List<String> carModelsNames = [];
  List<int> carModelsIds = [];
  List years = [];
  String selectedYear = '';
  int selectedModel;
  @override
  void initState() {
    loadCarModels();
    _getYears();
    super.initState();
  }

  void _chooseImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        _image = File(image.path);
        _imageList.add(_image);
        isLoading = true;
      }
    });

    _image != null ? _handleUpload() : null;
  }

  void _chooseCamera() async {
    var image = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (image != null) {
        _image = File(image.path);
        _imageList.add(_image);
        isLoading = true;
      }
    });
    _image != null ? _handleUpload() : null;
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
                isLoading ? "جارى..." : "التالي",
                style: const TextStyle(fontSize: 13),
              ),
            ),
            onPressed: () {
              isLoading ? null : _handleAdd(context);
            },
          ),
        ],
      ),
      body: Builder(
        builder: (_) {
          return Container(
            margin: const EdgeInsets.only(top: 20),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 90,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 70,
                          margin: const EdgeInsets.only(right: 20, left: 20),
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
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Material(
                              color: Colors.white,
                              elevation: 0.1,
                              borderRadius: BorderRadius.circular(30.0),
                              child: TextFormField(
                                  maxLines: null,
                                  keyboardType: TextInputType.text,
                                  controller: adTitle,
                                  decoration: const InputDecoration(
                                      fillColor: Colors.black,
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                          right: 19.0, top: 8.0),
                                      hintText: "أدخل عنوان الأعلان",
                                      hintStyle: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 14.0,
                                          fontFamily: 'Cocan',
                                          fontWeight: FontWeight.bold)),
                                  validator: (value) => value.isEmpty
                                      ? "عنوان الأعلان مطلوب"
                                      : null,
                                  onSaved: (String val) {
                                    _adTitle = val;
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 90,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 70,
                          margin: const EdgeInsets.only(right: 20, left: 20),
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
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Material(
                              color: Colors.white,
                              elevation: 0.1,
                              borderRadius: BorderRadius.circular(30.0),
                              child: TextFormField(
                                maxLines: null,
                                keyboardType: TextInputType.phone,
                                controller: phone,
                                decoration: const InputDecoration(
                                    fillColor: Colors.black,
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.only(right: 19.0, top: 8.0),
                                    hintText: "أدخل رقم الجوال",
                                    hintStyle: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 14.0,
                                        fontFamily: 'Cocan',
                                        fontWeight: FontWeight.bold)),
                                onSaved: (String val) {
                                  _phone = val;
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 150,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 130,
                          margin: const EdgeInsets.only(right: 20, left: 20),
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
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Material(
                              color: Colors.white,
                              elevation: 0.1,
                              borderRadius: BorderRadius.circular(30.0),
                              child: TextFormField(
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                controller: description,
                                decoration: const InputDecoration(
                                    fillColor: Colors.black,
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.only(right: 19.0, top: 8.0),
                                    hintText: "أدخل نص الأعلان",
                                    hintStyle: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 14.0,
                                        fontFamily: 'Cocan',
                                        fontWeight: FontWeight.bold)),
                                validator: (value) =>
                                    value.isEmpty ? "نص الأعلان مطلوب" : null,
                                onSaved: (String val) {
                                  _description = val;
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Car Model Dropdown
                  widget.car == true
                      ? Container(
                          margin: const EdgeInsets.only(right: 20, left: 20),
                          child: renderCarModel(context))
                      : Container(),
                  const SizedBox(
                    height: 20,
                  ),
                  widget.car == true
                      ? Container(
                          margin: const EdgeInsets.only(right: 20, left: 20),
                          child: renderYears(context))
                      : Container(),
                  //
                  Container(
                    margin: const EdgeInsets.only(right: 25, left: 25),
                    child: const Text("الصور الأضافية",
                        style: TextStyle(fontSize: 18)),
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: _chooseImage,
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
                            child: const Center(
                                child: Text(
                              "ألبوم الصور",
                              style:
                                  TextStyle(fontSize: 22, color: Colors.white),
                            )),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            FocusScope.of(context).unfocus(
                                disposition:
                                    UnfocusDisposition.previouslyFocusedChild);
                            _chooseCamera();
                          },
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
                            child: const Center(
                                child: Text(
                              "الكاميرا",
                              style:
                                  TextStyle(fontSize: 22, color: Colors.white),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                      children: _imageList
                          .map((item) => Stack(
                                children: <Widget>[
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.width / 2,
                                    margin: const EdgeInsets.all(20),
                                    width:
                                        MediaQuery.of(context).size.width / 1,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    child: Image.file(
                                      item,
                                      fit: BoxFit.cover,
                                    ),
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
                                          setState(() {
                                            _imageList.removeAt(
                                                _imageList.lastIndexOf(item));
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
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(20),
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).colorScheme.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            elevation: 0.5),
                        child: const Text(
                          "أرسال",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          isLoading ? null : _handleAdd(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Ui
  Widget renderCarModel(context) {
    return DropdownButtonFormField<String>(
      focusColor: Colors.white,
      //dropdownColor: ColorResources.PRIMARY_COLOR, // Items back ground

      //value: choosenCategory, // Initial Value
      //elevation: 5,
      style: const TextStyle(color: Colors.white),
      iconEnabledColor: Colors.black,
      // m4 3ar bt3ml eh

      // Selected Item decoration
      selectedItemBuilder: (BuildContext context) {
        return carModelsNames.map((String value) {
          return Text(
            value,
            style: const TextStyle(
                color: Colors.black38,
                fontSize: 14.0,
                fontFamily: 'Cocan',
                fontWeight: FontWeight.bold),
          );
        }).toList();
      },
      // Items decoration
      items: carModelsNames.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      hint: const Text(
        "ماركت السيارة",
        style: TextStyle(
            color: Colors.black38,
            fontSize: 14.0,
            fontFamily: 'Cocan',
            fontWeight: FontWeight.bold),
      ),
      // The used one
      decoration: InputDecoration(
          hintText: "ماركت السيارة",
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          // Floating label
          // No Error
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: Theme.of(context).primaryColor, width: (1))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: Theme.of(context).primaryColor, width: (1))),

          // Disabled
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: Theme.of(context).primaryColor, width: (1))),

          //Error
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: Theme.of(context).primaryColor, width: (1))),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: Theme.of(context).primaryColor, width: (1)))),
      // The hint here not used
      onChanged: (String value) {
        setState(() {
          int index = carModelsNames.indexOf(value);
          selectedModel = carModelsIds[index];
        });
      },
    );
  }

  Widget renderYears(context) {
    return DropdownButtonFormField<dynamic>(
      focusColor: Colors.white,
      //dropdownColor: ColorResources.PRIMARY_COLOR, // Items back ground

      //value: choosenCategory, // Initial Value
      //elevation: 5,
      style: const TextStyle(color: Colors.white),
      iconEnabledColor: Colors.black,
      // m4 3ar bt3ml eh

      // Selected Item decoration
      selectedItemBuilder: (BuildContext context) {
        return years.map((value) {
          return Text(
            value["year_num"],
            style: const TextStyle(
                color: Colors.black38,
                fontSize: 14.0,
                fontFamily: 'Cocan',
                fontWeight: FontWeight.bold),
          );
        }).toList();
      },
      // Items decoration
      items: years.map<DropdownMenuItem>((value) {
        return DropdownMenuItem(
          value: value["year_num"],
          child: Text(
            value["year_num"],
            style: const TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      hint: const Text(
        "موديل السيارة",
        style: TextStyle(
            color: Colors.black38,
            fontSize: 14.0,
            fontFamily: 'Cocan',
            fontWeight: FontWeight.bold),
      ),
      // The used one
      decoration: InputDecoration(
          hintText: "موديل السيارة",
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          // Floating label
          // No Error
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: Theme.of(context).primaryColor, width: (1))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: Theme.of(context).primaryColor, width: (1))),

          // Disabled
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: Theme.of(context).primaryColor, width: (1))),

          //Error
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: Theme.of(context).primaryColor, width: (1))),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: Theme.of(context).primaryColor, width: (1)))),
      // The hint here not used
      onChanged: (value) {
        setState(() {
          selectedYear = value;
        });
      },
    );
  }
  // Functions

  void _handleAdd(BuildContext context) {
    _validateInputs(context);
  }

  void _validateInputs(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        isLoading = true;
      });

      var data = {
        "user_id": userId.toString(),
        "ad_title": adTitle.text,
        "phone": phone.text,
        "description": description.text,
        "image_cover": widget.imageCover,
        "images": _imageListString,
        "section_id": widget.categoryId,
      };
      if (widget.car == true) {
        data.addAll(
            {"car_model": selectedModel.toString(), "year": selectedYear});
      }

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AddNextFnishScreen(data: data),
          ));
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _handleUpload() async {
    setState(() {
      isUpload = true;
    });

    String base64Image = base64Encode(_image.readAsBytesSync());
    String fileName = _image.path.split("/").last;

    try {
      final Response res = await Api().postData(
          {"image": base64Image, "name": fileName, "folder": 'ads'},
          ApiConfig.uploudAdImagePath);
      if (res.statusCode != 200) {
        throw Exception("Server Error");
      }
      _imageListString.add(json.decode(res.body)['data']);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> loadCarModels() async {
    var res = await Api().getData(
        '${ApiConfig.subSectionsPath}?${ApiConfig.sectionIdQueryParmKey}=${widget.categoryId}');
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
    } else {
      var body = json.decode(res.body);
      if (body['status']) {
        var dataSubSection = body['data'];
        dataSubSection.forEach((value) {
          carModelsNames.add(value['sub_name']);
          carModelsIds.add(value['id']);
        });
        setState(() {
          // carModelsNames = dataSubSection['sub_name'];
          // carModelsIds = dataSubSection['id'];
        });
      }
    }
  }

  _getYears() async {
    Response res = await Api().getData('/haraj1_get-years');

    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
    } else {
      log("yyyyyeeeears " + res.body.toString());
      var body = json.decode(res.body);
      if (body['status']) {
        var dataSubSection = body['data'];
        setState(() {
          years = dataSubSection;

          dataSubSection.insert(0, {"id": null, "year_num": "الكل"});
          log("yyyyyeeeears " + years.length.toString());
        });
      }
    }
  }
}
