import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:harajsedirah/api/api.dart';
import 'package:harajsedirah/api/api_config.dart';

import 'dart:async';
import 'edit_ad_step_one_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class EditLocation extends StatefulWidget {
  final id;
  const EditLocation({Key key, this.id}) : super(key: key);
  @override
  _EditLocationState createState() => _EditLocationState();
}

class _EditLocationState extends State<EditLocation> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Completer<GoogleMapController> _controller = Completer();
  Position _currentPosition;
  bool isLatAndLong = false;
  var lat, long;
  _getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        lat = _currentPosition.latitude;
        long = _currentPosition.longitude;
        isLatAndLong = true;
      });
    }).catchError((e) {
      //  print(e);
    });
  }

  static const LatLng _center = LatLng(30.064223000000002, 31.466835500000002);
  final Set<Marker> _markers = {};
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(30.064223000000002, 31.466835500000002),
    zoom: 2.4746,
  );
  LatLng _lastMapPosition = _center;

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: const InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(30.064223000000002, 31.466835500000002),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

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
        isAdData = true;
        _selectionCountry = "${ad_data['country_id']}";
        _selectionAreas = "${ad_data['area_id']}";
        _selectionCities = "${ad_data['city_id']}";
        _selectionHays = "${ad_data['hay_id']}";
      });
      _getCountries(ad_data['country_id']);
    }
  }

  List country_data = [];
  String _selectionCountry;
  bool isCountry = false;
  _getCountries(countryId) async {
    var res = await Api().getData(ApiConfig.countriesPath);
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {}
    var body = json.decode(res.body);
    if (body['status']) {
      var data = body['data'];
      setState(() {
        country_data = data;
        if (country_data.isNotEmpty) {
          _selectionCountry = "$countryId";
          isCountry = true;
          _getAreas(countryId);
        }
      });
    }
  }

  List area_data = [];
  String _selectionAreas;
  bool isAreas = false;

  _getAreas(countryId) async {
    var res = await Api().getData(
        '${ApiConfig.areaWitjCountriesPath}?${ApiConfig.countryIdQueryParmKey}=$countryId');
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {}
    var body = json.decode(res.body);
    if (body['status']) {
      var data = body['data'];
      setState(() {
        area_data = data;
        if (area_data.isNotEmpty) {
          area_data.insert(0, {"id": '', "area_name": 'أختر المنطقة'});
          _selectionAreas = _selectionAreas != null &&
                  _selectionAreas != "0" &&
                  _selectionAreas != "null" &&
                  _selectionAreas != ''
              ? _selectionAreas
              : "${area_data[0]['id']}";
          isAreas = true;
          _getCities(_selectionAreas);
        } else {
          isAreas = false;
          isCities = false;
          isHays = false;
        }
      });
    } else {
      setState(() {
        isAreas = false;
        isCities = false;
        isHays = false;
      });
    }
  }

  List city_data = [];
  String _selectionCities;
  bool isCities = false;

  _getCities(areaId) async {
    var res = await Api().getData(
        '${ApiConfig.citiesWithAreaPath}?${ApiConfig.areaIdQueryParmKey}=$areaId');
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {}
    var body = json.decode(res.body);

    if (body['status']) {
      var data = body['data'];
      setState(() {
        city_data = data;
        if (city_data.isNotEmpty) {
          city_data.insert(0, {"id": '', "city_name": 'أختر المدينة'});
          _selectionCities = _selectionCities != null &&
                  _selectionCities != "0" &&
                  _selectionCities != "null" &&
                  _selectionCities != ''
              ? _selectionCities
              : "${city_data[0]['id']}";
          isCities = true;
          _getHays(ad_data['city_id']);
        } else {
          isCities = false;
          isHays = false;
        }
      });
    } else {
      setState(() {
        isCities = false;
        isHays = false;
      });
    }
  }

  List hay_data = [];
  String _selectionHays;
  bool isHays = false;

  _getHays(cityId) async {
    var res = await Api().getData(
        '${ApiConfig.haysWithCityPath}?${ApiConfig.cityIdQueryParmKey}=$cityId');
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {}
    var body = json.decode(res.body);

    if (body['status']) {
      var data = body['data'];
      setState(() {
        hay_data = data;
        if (hay_data.isNotEmpty) {
          hay_data.insert(0, {"id": '', "hay_name": 'أختر الحي'});
          _selectionHays = _selectionHays != null &&
                  _selectionHays != "0" &&
                  _selectionHays != "null" &&
                  _selectionHays != ''
              ? _selectionHays
              : "${hay_data[0]['id']}";
          isHays = true;
        } else {
          isHays = false;
        }
      });
    } else {
      setState(() {
        isHays = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _onAddMarkerButtonPressed();
    _getAdData();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('تعديل الأعلان'),
        centerTitle: true,
        elevation: 0.4,
        actions: <Widget>[
          IconButton(
            icon: const Text(
              "حفظ",
              style: TextStyle(fontSize: 13),
            ),
            onPressed: () {
              _handleEditAd();
            },
          ),
        ],
      ),

      body: Builder(
        builder: (_) {
          return Container(
            margin: const EdgeInsets.only(top: 20),
            child: ListView(
              children: <Widget>[
                isCountry
                    ? Container(
                        height: 50,
                        margin:
                            const EdgeInsets.only(top: 10, left: 20, right: 20),
                        padding: const EdgeInsets.only(right: 15, left: 15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: DropdownButton(
                          elevation: 0,
                          underline: Container(),
                          value: _selectionCountry,
                          icon: const Icon(
                            Icons.arrow_drop_down_circle,
                            color: Colors.white,
                          ),
                          isExpanded: true,
                          onChanged: (String newValue) {
                            setState(() {
                              _selectionCountry = newValue;
                              _selectionAreas = null;
                              _selectionCities = null;
                              _selectionHays = null;
                            });

                            _getAreas(_selectionCountry);
                          },
                          items: country_data.map((item) {
                            return DropdownMenuItem<String>(
                              value: item["id"].toString(),
                              child: Text(
                                "${item["country_name"]}",
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    : Container(),
                isAreas
                    ? Container(
                        height: 50,
                        margin:
                            const EdgeInsets.only(top: 10, left: 20, right: 20),
                        padding: const EdgeInsets.only(right: 15, left: 15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: DropdownButton(
                          elevation: 0,
                          underline: Container(),
                          value: _selectionAreas,
                          icon: const Icon(
                            Icons.arrow_drop_down_circle,
                            color: Colors.white,
                          ),
                          isExpanded: true,
                          onChanged: (String newValue) {
                            setState(() {
                              _selectionAreas = newValue;
                              _selectionCities = null;
                              _selectionHays = null;
                              _getCities(_selectionAreas);
                            });
                          },
                          items: area_data.map((item) {
                            return DropdownMenuItem<String>(
                              value: item["id"].toString(),
                              child: Text(
                                "${item["area_name"]}",
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    : Container(),
                isCities
                    ? Container(
                        height: 50,
                        margin:
                            const EdgeInsets.only(top: 10, left: 20, right: 20),
                        padding: const EdgeInsets.only(right: 15, left: 15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: DropdownButton(
                          elevation: 0,
                          underline: Container(),
                          value: _selectionCities,
                          icon: const Icon(
                            Icons.arrow_drop_down_circle,
                            color: Colors.white,
                          ),
                          isExpanded: true,
                          onChanged: (String newValue) {
                            setState(() {
                              _selectionCities = newValue;
                              _selectionHays = null;
                            });
                            _getHays(_selectionCities);
                          },
                          items: city_data.map((item) {
                            return DropdownMenuItem<String>(
                              value: item["id"].toString(),
                              child: Text(
                                "${item["city_name"]}",
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    : Container(),
                isHays
                    ? Container(
                        height: 50,
                        margin:
                            const EdgeInsets.only(top: 10, left: 20, right: 20),
                        padding: const EdgeInsets.only(right: 15, left: 15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: DropdownButton(
                          elevation: 0,
                          underline: Container(),
                          value: _selectionHays,
                          icon: const Icon(
                            Icons.arrow_drop_down_circle,
                            color: Colors.white,
                          ),
                          isExpanded: true,
                          onChanged: (String newValue) {
                            setState(() {
                              _selectionHays = newValue;
                            });
                          },
                          items: hay_data.map((item) {
                            return DropdownMenuItem<String>(
                              value: item["id"].toString(),
                              child: Text(
                                "${item["hay_name"]}",
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    : Container(),
                Container(
                  height: 250,
                  margin: const EdgeInsets.all(20),
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: const CameraPosition(
                      target: _center,
                      zoom: 15.0,
                    ),
                    mapType: MapType.normal,
                    markers: _markers,
                    onCameraMove: _onCameraMove,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('To the lake!'),
      //   icon: Icon(Icons.directions_boat),
      // ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  void _handleEditAd() async {
    var data = {
      'ad_id': widget.id,
      'country_id': _selectionCountry != "0" && _selectionCountry != ''
          ? _selectionCountry
          : null,
      'area_id': _selectionAreas != "0" && _selectionAreas != ''
          ? _selectionAreas
          : null,
      'city_id': _selectionCities != "0" && _selectionCities != ''
          ? _selectionCities
          : null,
      'hay_id':
          _selectionHays != "0" && _selectionHays != '' ? _selectionHays : null,
    };

    var res = await Api().postAuthData(data, ApiConfig.editAdPath);
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

      Future initData() async {
        await Future.delayed(const Duration(seconds: 2));
      }

      initData().then((value) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => EditAdStepOne(id: widget.id)));
      });
    }
  }
}
