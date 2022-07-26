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
    print("도시정보여기");
    print(placemarks[0].administrativeArea.toString());
   // var locateMeCity = placemarks[0].administrativeArea.toString();

    _controller.animateCamera(
      //CameraUpdate.newLatLng(LatLng(gps.latitude, gps.longitude)),
        CameraUpdate.newLatLngZoom(
            LatLng(gps.latitude, gps.longitude), 15)
    );

    print('여기 위도경도');
    print(gps.latitude);
    print(gps.latitude);
    // setState(() {
    //   markers.add(Marker( //add first marker
    //     markerId: MarkerId('current'),
    //     position: LatLng(gps.latitude, gps.longitude), //position of marker
    //
    //     //icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    //   ));
    // });

  }

  Future<List<Marker>> getmarkers() async { //markers to place on map

    List latLogi = List.generate(50, (i) => List.filled(2, null, growable: false));
    latLogi = [[37.510555, 127.1150512],[37.510555, 127.1080512],[37.513555, 127.1000],[39.9035, 116.388],[35.68288, 139.76991],[37.404704734328, 127.10535530866]];



      var gps = await getCurrentLocation();
      List<Placemark> mCityInfo = await placemarkFromCoordinates(gps.latitude, gps.longitude);
      var mCityArea = mCityInfo[0].administrativeArea.toString();




      // List<Placemark> oneCityInfo = await placemarkFromCoordinates(37.510555, 127.1150512);
      // var oneCityArea = oneCityInfo[0].administrativeArea.toString();
      //
      //
      // List<Placemark> secondCityInfo = await placemarkFromCoordinates(37.510555, 127.1080512);
      // var secondCityArea = secondCityInfo[0].administrativeArea.toString();
      //
      // List<Placemark> thirdCityInfo = await placemarkFromCoordinates(37.513555, 127.1000);
      // var thirdCityArea = thirdCityInfo[0].administrativeArea.toString();
      //
      // List<Placemark> fourthCityInfo = await placemarkFromCoordinates(39.9035, 116.388);
      // var fourthCityArea = fourthCityInfo[0].administrativeArea.toString();
      //
      // List<Placemark> fifthCityInfo = await placemarkFromCoordinates(35.68288, 139.76991);
      // var fifthCityArea = fifthCityInfo[0].administrativeArea.toString();
      //
      // List<Placemark> sixthCityInfo = await placemarkFromCoordinates(37.404704734328, 127.10535530866);
      // var sixthCityArea = sixthCityInfo[0].administrativeArea.toString();



    List latlogiArea = [];

    for(int y=0; y<latLogi.length; y++){

      List<Placemark> info = await placemarkFromCoordinates(latLogi[y][0], latLogi[y][1]);
      var CityArea = info[0].administrativeArea.toString();
      if(mCityArea == CityArea){
        latlogiArea.add([latLogi[y][0], latLogi[y][1]]);
      }

    };
    print('여기다지역거른거');
    print(latlogiArea);

    //List markerId = ['who1', 'who2', 'who3', 'who4','who5','who5','who7'];
    //List markeList = ["oneMarker", "secondMarker", "thirdMarker", "fourthMarker", "fifthMarker", "sixthMarker"];
    if( latlogiArea != null) {
      markers.addAll([
        for(int a = 0; a < latlogiArea.length; a++)
          Marker(
            markerId: MarkerId('who${a}'),
            position: LatLng(latlogiArea[a][0], latlogiArea[a][1]),
            infoWindow: InfoWindow(
              title: '회원${a + 1}',
              snippet: '부제',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRose),

          )


      ]);
    }

    setState(() {
      markers;
    });





      //    Marker oneMarker =  Marker( //add first marker
      //   markerId: MarkerId('who1'),
      //   position: LatLng(37.510555, 127.1150512), //position of marker
      //   infoWindow: InfoWindow( //popup info
      //     title: 'Marker Title First ',
      //     snippet: 'My Custom Subtitle',
      //   ),
      //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose), //Icon for Marker
      // );
      //
      //
      //    Marker secondMarker = Marker( //add second marker
      //   markerId: MarkerId('who2'),
      //   position: LatLng(37.510555, 127.1080512), //position of marker
      //   infoWindow: InfoWindow( //popup info
      //     title: 'Marker Title Second ',
      //     snippet: 'My Custom Subtitle',
      //   ),
      //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose), //Icon for Marker
      // );
      //
      //
      // Marker thirdMarker = Marker( //add third marker
      //   markerId: MarkerId('who3'),
      //   position: LatLng(37.513555, 127.1000), //position of marker
      //   infoWindow: InfoWindow( //popup info
      //     title: 'Marker Title Third ',
      //     snippet: 'My Custom Subtitle',
      //   ),
      //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose), //Icon for Marker
      // );
      //
      //    Marker fourthMarker = Marker( //add third marker
      //      markerId: MarkerId('who4'),
      //      position: LatLng(39.9035, 116.388), //position of marker
      //      infoWindow: InfoWindow( //popup info
      //        title: 'Marker Title four ',
      //        snippet: 'My Custom Subtitle',
      //      ),
      //      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose), //Icon for Marker
      //    );
      //
      //    Marker fifthMarker = Marker( //add third marker
      //      markerId: MarkerId('who5'),
      //      position: LatLng(35.68288, 139.76991), //position of marker
      //      infoWindow: InfoWindow( //popup info
      //        title: 'Marker Title five ',
      //        snippet: 'My Custom Subtitle',
      //      ),
      //      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose), //Icon for Marker
      //    );
      //
      // Marker sixthMarker = Marker( //add third marker
      //   markerId: MarkerId('who6'),
      //   position: LatLng(37.404704734328, 127.10535530866), //position of marker
      //   infoWindow: InfoWindow( //popup info
      //     title: 'Marker Title six ',
      //     snippet: 'My Custom Subtitle',
      //   ),
      //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose), //Icon for Marker
      // );

              //마커간 거리측정
        // double oneDistance = Geolocator.distanceBetween(gps.latitude, gps.longitude, oneLat, onelogi);
        // print("여기다여기");
        // print(oneDistance);

          //지역거르고 마커찍기
      // List cityList = [oneCityArea, secondCityArea, thirdCityArea ,fourthCityArea, fifthCityArea, sixthCityArea];
      // List markeList = [oneMarker, secondMarker, thirdMarker, fourthMarker, fifthMarker, sixthMarker];
      //
      // for(int i=0; i<cityList.length; i++){
      //     if(mCityArea == cityList[i]) {
      //
      //       for(int x=0; x<markeList.length; x++) {
      //         if (i == x) {
      //           setState(() {
      //             markers.add(markeList[x]);
      //           });
      //         }
      //       }
      //     }
      // };

     // if(mCityArea == oneCityArea){
     //   setState(() {
     //     markers.add(oneMarker);
     //   });
     // }
     //
     // if(mCityArea == secondCityArea){
     //   setState(() {
     //     markers.add(secondMarker);
     //   });
     // }
     // if(mCityArea == thirdCityArea){
     //   setState(() {
     //     markers.add(thirdMarker);
     //   });
     // }
     // if(mCityArea == fourthCityArea){
     //   setState(() {
     //     markers.add(fourthMarker);
     //   });
     // }
     // if(mCityArea == fifthCityArea){
     //   setState(() {
     //     markers.add(fifthMarker);
     //   });
     // }
     //  if(mCityArea == sixthCityArea){
     //    setState(() {
     //      markers.add(sixthMarker);
     //    });
     //  }


    return markers;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("google map")
      ),

        body: GoogleMap(
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
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