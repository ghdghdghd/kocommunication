import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapSample extends StatefulWidget {


  const MapSample({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MapSample> {
  // 애플리케이션에서 지도를 이동하기 위한 컨트롤러
  late GoogleMapController _controller;

  // 이 값은 지도가 시작될 때 첫 번째 위치입니다.
  final CameraPosition _initialPosition =
  CameraPosition(
      target: LatLng(37.520555375455, 127.11505129348),
      zoom: 15);

  // 지도 클릭 시 표시할 장소에 대한 마커 목록
  final List<Marker> markers = [];

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position;
  }

  addMarker(cordinate) {
    int id = Random().nextInt(100);

    setState(() {
      markers
          .add(Marker(position: cordinate, markerId: MarkerId(id.toString())));
    });
  }

  _locateMe() async {
    var gps = await getCurrentLocation();

    _controller.animateCamera(
      //CameraUpdate.newLatLng(LatLng(gps.latitude, gps.longitude)),
        CameraUpdate.newLatLngZoom(
            LatLng(gps.latitude, gps.longitude), 15)
    );
    print('여기 위도경도');
    print(gps.latitude);
    print(gps.latitude);
    setState(() {
      markers.add(Marker( //add first marker
        markerId: MarkerId('current'),
        position: LatLng(gps.latitude, gps.longitude), //position of marker

        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
    });

  }

  Set<Marker> getmarkers() { //markers to place on map


    setState(() {
      markers.add(Marker( //add first marker
        markerId: MarkerId('current'),
        position: LatLng(37.520555375455, 127.11505129348), //position of marker
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
        body: GoogleMap(
          initialCameraPosition: _initialPosition,
          mapType: MapType.normal,  //표시할 지도 유형(일반,위성,하이브리드)
          onMapCreated: (controller) {
            setState(() {
              _controller = controller;
            });
          },
          markers: Set.from(markers),
          //markers.toSet(),  

          // 클릭한 위치가 중앙에 표시
          // onTap: (cordinate) {
          //   _controller.animateCamera(CameraUpdate.newLatLng(cordinate));
          //   addMarker(cordinate);
          // },
        ),

        // floatingActionButton 클릭시 줌 아웃
      floatingActionButton: Stack(
        children: <Widget> [
          Align(
            alignment: Alignment(
                Alignment.bottomLeft.x + 0.2, Alignment.bottomLeft.y),
            child: FloatingActionButton(
              onPressed: () => _locateMe(),
              tooltip: '내위치',
              child: Icon(
                Icons.my_location,
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
            ),
          ),
          Align(
            alignment: Alignment(
                Alignment.bottomLeft.x + 0.2, Alignment.bottomLeft.y - 0.2),
            child: FloatingActionButton(
              onPressed: () => getmarkers(),
              tooltip: '회원위치공유',
              child: Icon(
                Icons.emoji_people,
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
            ),
          )
        ],
      ),




    );
  }
}