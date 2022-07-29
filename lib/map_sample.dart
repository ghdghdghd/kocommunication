import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

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
    List<Placemark> placemarks = await placemarkFromCoordinates(gps.latitude, gps.longitude);
    print(placemarks[0].administrativeArea.toString());


    _controller.animateCamera(
      CameraUpdate.newLatLngZoom(
          LatLng(gps.latitude, gps.longitude), 15)
    );

    print('여기 위도경도');
    print(gps.latitude);
    print(gps.latitude);

  }

  Future<List<Marker>> getmarkers() async { //markers to place on map

    List latLogi = List.generate(50, (i) => List.filled(2, null, growable: false));
    latLogi = [[37.510555, 127.1150512],[37.510555, 127.1080512],[37.513555, 127.1000],[39.9035, 116.388],
                                        [35.68288, 139.76991],[35.684879, 139.508178],[35.720863, 139.293221],[35.00088, 138.99991],[35.436081, 139.103529],[37.404704734328, 127.10535530866]];



      var gps = await getCurrentLocation();
      List<Placemark> mCityInfo = await placemarkFromCoordinates(gps.latitude, gps.longitude); //좌표값으로 도시정보 가져오기
      var mCityArea = mCityInfo[0].administrativeArea.toString();                              //도시정보주에 administrativeArea값만 가져오기

      List latlogiArea = [];

     for(int y=0; y<latLogi.length; y++){
       List<Placemark> info = await placemarkFromCoordinates(latLogi[y][0], latLogi[y][1]);
       var CityArea = info[0].administrativeArea.toString();
       if(mCityArea == CityArea){
         latlogiArea.add([latLogi[y][0], latLogi[y][1]]);
       }
    };
    // print('여기다지역거른거');
    // print(latlogiArea);


    if( latlogiArea != null) {   //현재 같은 도시에 있는 회원이 있다면  마커추가 폼을 반복문을 실행 한다
      markers.addAll([
        for(int a = 0; a < latlogiArea.length; a++)
          Marker(
            markerId: MarkerId('who${a}'),                           //마커 아이디
            position: LatLng(latlogiArea[a][0], latlogiArea[a][1]),  //마커의 위도경도
            infoWindow: InfoWindow(
              title: '회원${a + 1}',                                  //마커 정보
              snippet: '부제',                                        //마커 정보 부제
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(             //마커 아이콘 색지정
                BitmapDescriptor.hueRose),

          )


      ]);
    }

    setState(() {
      markers;
    });

    return markers;
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("google map")
      ),

        body: GoogleMap(
          myLocationEnabled: true,  //내위치 지도에 표시
          myLocationButtonEnabled: false,   //내위치 찾기 버튼
          initialCameraPosition: _initialPosition,  //지도 시작시 처음 보여지는 화면 값
          mapType: MapType.normal,  //표시할 지도 유형(일반,위성,하이브리드)
          onMapCreated: (controller) {    //맵생성
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

        // floatingActionButton
      floatingActionButton: Stack(
        children: <Widget> [
          Align(
            alignment: Alignment(
                Alignment.bottomLeft.x + 0.2, Alignment.bottomLeft.y),  //버튼 위치 지정
            child: FloatingActionButton(
              onPressed: () => _locateMe(),    //버튼 눌렀을때 동작 함수
              tooltip: '내위치',                //버튼동작 설명 툴팁
              child: Icon(
                Icons.my_location,             //버튼 아이콘 지정
                color: Colors.black,           //버튼 아이콘색 지정
              ),
              backgroundColor: Colors.white,   //버튼 배경색 지정
            ),
          ),
          Align(
            alignment: Alignment(
                Alignment.bottomLeft.x + 0.2, Alignment.bottomLeft.y - 0.2), //보튼 위치 지정
            child: FloatingActionButton(
              onPressed: () => getmarkers(),    //버튼 눌렀을때 동작 함수
              tooltip: '회원위치공유',            //버튼동작 설명 툴팁
              child: Icon(
                Icons.emoji_people,             //버튼 아이콘 지정
                color: Colors.black,            //버튼 아이콘색 지정
              ),
              backgroundColor: Colors.white,    //버튼 배경색 지정
            ),
          )
        ],
      ),


    );
  }
}