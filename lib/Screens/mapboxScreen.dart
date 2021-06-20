import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:foodz_owner/Database/RestaurantDB.dart';
import 'package:foodz_owner/Screens/MainScreen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:user_location/user_location.dart';
//import 'package:user_location/user_location.dart';

User _loggedInUser;
final _auth = FirebaseAuth.instance;
RestaurantDB _restDB = RestaurantDB();

class EditAddressScreen extends StatefulWidget {
  static String tag = '/EditAddressScreen';

  @override
  _EditAddressScreen createState() => _EditAddressScreen();
}

class _EditAddressScreen extends State<EditAddressScreen> {
  MapController mapController = MapController();
  UserLocationOptions userLocationOptions;
  List<Marker> markers = [];

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        _loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Position _mypos = ModalRoute.of(context).settings.arguments;

    /*userLocationOptions = UserLocationOptions(
      context: context,
      mapController: mapController,
      zoomToCurrentLocationOnLoad: false,
      updateMapLocationOnPositionChange: false,
      showMoveToCurrentLocationFloatingActionButton: false,
      markers: markers,
    );*/

    return Scaffold(
        appBar: AppBar(
          title: Text("Edit your address"),
        ),
        body: FlutterMap(
          options: MapOptions(
            onLongPress: addPin,
            //center: LatLng(51.5074, 0.1278),
            center: LatLng(_mypos.latitude, _mypos.longitude), // London
            zoom: 16.0,
            minZoom: 10,
            plugins: [
              UserLocationPlugin(),
            ],
          ),
          layers: [
            new TileLayerOptions(
              urlTemplate:
                  'https://api.mapbox.com/styles/v1/novanova/ckocjl7kd05vq17odjfwcufk3/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoibm92YW5vdmEiLCJhIjoiY2tjeGh3N2ZwMDA3ZDJ3bXJwYmJ6eXQyZCJ9.ru-z3kSHckZ0JBrtbip-Rg',
              additionalOptions: {
                'accessToken':
                    'pk.eyJ1Ijoibm92YW5vdmEiLCJhIjoiY2tjeGh3N2ZwMDA3ZDJ3bXJwYmJ6eXQyZCJ9.ru-z3kSHckZ0JBrtbip-Rg',
              },
            ),
            MarkerLayerOptions(
              markers: markers,
            ),
            //userLocationOptions,
          ],
          mapController: mapController,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.green,
            heroTag: "BtnSubmitAdd",
            icon: Icon(Icons.location_on),
            label: Text("Choose location"),
            onPressed: () {
              if (markers.length != 0) {
                _restDB
                    .editAddressField(
                        id: _loggedInUser.uid,
                        newLat: markers[0].point.latitude,
                        newLong: markers[0].point.longitude,
                        context: context)
                    .whenComplete(() => Navigator.pop(context));
              } else {
                Flushbar(
                  flushbarPosition: FlushbarPosition.TOP,
                  title: "Error",
                  message: "Choose a location !",
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 3),
                )..show(context);
              }
              //print(markers[0].point.latitude);
            }));
  }

  addPin(LatLng latlng) {
    //print("Marked " + latlng.toString());
    setState(() {
      print(latlng.toString());
      markers.clear();
      markers.add(Marker(
        width: 40.0,
        height: 40.0,
        point: latlng,
        builder: (ctx) => Container(
          child: Image.asset('images/offline/placeholder.png'),
        ),
      ));
    });
  }
}
