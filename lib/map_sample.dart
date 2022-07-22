import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapSample extends StatefulWidget {
  late final String title;

  @override
  _MapSampleState createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {
  // 애플리케이션에서 지도를 이동하기 위한 컨트롤러
  late GoogleMapController _controller;

  // 이 값은 지도가 시작될 때 첫 번째 위치입니다.
  final CameraPosition _initialPosition =
  CameraPosition(target: LatLng(41.017901, 28.847953));

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
          markers: markers.toSet(),

          // 클릭한 위치가 중앙에 표시
          onTap: (cordinate) {
            _controller.animateCamera(CameraUpdate.newLatLng(cordinate));
            addMarker(cordinate);
          },
        ),

        // floatingActionButton 클릭시 줌 아웃
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var gps = await getCurrentLocation();

            _controller.animateCamera(
                CameraUpdate.newLatLng(LatLng(gps.latitude, gps.longitude)));

          },
          child: Icon(
            Icons.my_location,
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
        )
    );
  }
}