import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(const MapSample4());


class MapSample4 extends StatefulWidget {
  const MapSample4({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MapSample4> {
  double _lat = 37.574187;
  double _lng = 126.976882;
  Completer<GoogleMapController> _controller = Completer();
  Location location = new Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late CameraPosition _currentPosition;

  final Set<Marker> markers = new Set(); //markers
  static const LatLng showLocation = const LatLng(37.520555375455, 127.11505129348); //location to show in map

  @override
  initState() {
    super.initState();
    _currentPosition = CameraPosition(
      target: LatLng(_lat, _lng),
      zoom: 15,
    );
  }

  _locateMe() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    await location.getLocation().then((res) async {
      final GoogleMapController controller = await _controller.future;
      final _position = CameraPosition(
        target: LatLng(res.latitude!, res.longitude!),
        zoom: 15,
      );
      controller.animateCamera(CameraUpdate.newCameraPosition(_position));
      setState(() {
        _lat = res.latitude!;
        _lng = res.longitude!;
        print("여기위도경도");
        print(_lat);
        print(_lng);
      });
    });
  }

  Set<Marker> getmarkers() { //markers to place on map


    setState(() {
      markers.add(Marker( //add first marker
        markerId: MarkerId('current'),
        position: showLocation, //position of marker
        infoWindow: InfoWindow( //popup info
          title: 'Marker Title First ',
          snippet: 'My Custom Subtitle',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker( //add second marker
        markerId: MarkerId('current'),
        position: LatLng(37.52055537545, 127.1150512934), //position of marker
        infoWindow: InfoWindow( //popup info
          title: 'Marker Title Second ',
          snippet: 'My Custom Subtitle',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker( //add third marker
        markerId: MarkerId('current'),
        position: LatLng(37.5205553754, 127.115051293), //position of marker
        infoWindow: InfoWindow( //popup info
          title: 'Marker Title Third ',
          snippet: 'My Custom Subtitle',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      //add more markers here
    });

    return markers;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Maps"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: GoogleMap(
          initialCameraPosition: _currentPosition,
          markers: {
            Marker(
              markerId: MarkerId('current'),
              position: LatLng(_lat, _lng),


            ),
          },


          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
      floatingActionButton: Stack(
        children: <Widget> [
          Align(
            alignment: Alignment(
              Alignment.bottomLeft.x + 0.2, Alignment.bottomLeft.y),
          child: FloatingActionButton(
              onPressed: () => _locateMe(),
              tooltip: '내위치',
              child: Icon(Icons.location_searching),
            ),
          ),
          Align(
            alignment: Alignment(
                Alignment.bottomLeft.x + 0.2, Alignment.bottomLeft.y - 0.2),
            child: FloatingActionButton(
              onPressed: () => getmarkers(),
              tooltip: '회원위치공유',
              child: Icon(Icons.emoji_people),
            ),
          )
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.location_searching),
      //   onPressed: () => _locateMe(),
      // ),
    );
  }
}
