import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;

class TestScreen extends StatefulWidget {
  static String tag = '/testScreen';

  @override
  _TestScreen createState() => _TestScreen();
}

class _TestScreen extends State<TestScreen> {
  //List<LatLng> latlngList = List<LatLng>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map"),
      ),
      body: Center(
        child: FlutterMap(
          options: MapOptions(
            center: latLng.LatLng(31.050478, -7.931633),
            zoom: 12.0,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: "mapbox://styles/novanova/ckocjl7kd05vq17odjfwcufk3",
              additionalOptions: {
                'accessToken':
                    'pk.eyJ1Ijoibm92YW5vdmEiLCJhIjoiY2tjeGh3N2ZwMDA3ZDJ3bXJwYmJ6eXQyZCJ9.ru-z3kSHckZ0JBrtbip-Rg',
                'id': 'mapbox.streets',
              },
            ),
            MarkerLayerOptions(
              markers: [
                Marker(
                  width: 50.0,
                  height: 50.0,
                  point: latLng.LatLng(31.050478, -7.931633),
                  builder: (ctx) => Container(
                    child: Image.asset(
                      "images/offline/success.png",
                    ),
                  ),
                )
              ],
            ),
            // PolylineLayerOptions(polylines: [
            //   Polyline(
            //     points: latlngList,
            //     // isDotted: true,
            //     color: Color(0xFF669DF6),
            //     strokeWidth: 3.0,
            //     borderColor: Color(0xFF1967D2),
            //     borderStrokeWidth: 0.1,
            //   )
            // ])
          ],
        ),
      ),
    );
  }
}
