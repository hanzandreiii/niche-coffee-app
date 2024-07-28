import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'package:the_end/geopoint.dart';
import 'package:the_end/consts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as a;
import 'package:the_end/nearby.dart' as b;
import 'package:the_end/nearby_location_api.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location locController = Location();

  List<b.Nearby> nearbyLocations = <b.Nearby>[];
  /*int _index = 2;
  final _screens = [
    const Profile(),
    const Shop(),
    const Settings(),
    const Notifs(),
  ];*/

  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  final Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  late BitmapDescriptor myIcon;
  static const LatLng startPoint =
      LatLng(YOURLATLNG);
  static const LatLng endPoint = LatLng(YOURLATLNG);
  LatLng? currentPos;

  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    getLocationUpdates().then(
      (_) => {
        getPoly().then((coordinates) => {
              generatePoly(coordinates),
            }),
      },
    );
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(48, 48)),
            'lib/images/Tracker Logo.png')
        .then((onValue) {
      myIcon = onValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: const Color(0XFF5D7352),
        color: const Color(0XFF5D7352),
        animationDuration: const Duration(milliseconds: 300),
        index: _index,
        onTap: (value) {
          setState(() {
            _index = value;
          });
        },
        items: const <Widget>[
          Icon(Icons.shop, size: 26, color: Color(0XFFFFF2E3)),
          Icon(Icons.notifications, size: 26, color: Color(0XFFFFF2E3)),
          Icon(Icons.home, size: 26, color: Color(0XFFFFF2E3)),
          Icon(Icons.person_2_rounded, size: 26, color: Color(0XFFFFF2E3)),
          Icon(Icons.settings, size: 26, color: Color(0XFFFFF2E3)),
        ],
      ),*/
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: const Color(0XFF5D7352),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
        foregroundColor: const Color(0XFFFFF2E3),
      ),
      body: currentPos == null
          ? Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                ElevatedButton(
                  onPressed: null,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: nearbyLocations.length,
                        itemBuilder: (_, index) => Padding(
                          padding: const EdgeInsets.only(left: 8.0, bottom: 8),
                          child: SizedBox(
                            width: 200,
                            child: Card(
                              elevation: 2,
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(4),
                                            topRight: Radius.circular(4)),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                '${nearbyLocations[index].icon}'))),
                                  )),
                                  Expanded(
                                      child: Container(
                                    padding: const EdgeInsets.all(4),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('${nearbyLocations[index].name}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500)),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Star(nearbyLocations[index]
                                                    .rating
                                                    ?.toInt() ??
                                                0),
                                            Text(
                                                ' ${nearbyLocations[index].userRatingsTotal}')
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Expanded(
                                          child: Text(
                                              '${nearbyLocations[index].vicinity}',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey)),
                                        ),
                                      ],
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            )
          : GoogleMap(
              mapToolbarEnabled: true,
              mapType: MapType.normal,
              onMapCreated: ((GoogleMapController controller) =>
                  mapController.complete(controller)),
              initialCameraPosition: CameraPosition(
                target: currentPos!,
                zoom: 16,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId("_currentLocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: currentPos!,
                ),
                const Marker(
                  markerId: MarkerId("startLocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: startPoint,
                ),
                const Marker(
                  markerId: MarkerId("endLocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: endPoint,
                ),
              },
              polylines: Set<Polyline>.of(polylines.values),
            ),
    );
  }

  Future<void> camPos(LatLng pos) async {
    final GoogleMapController controller = await mapController.future;
    CameraPosition newCamPos = CameraPosition(
      target: pos,
      zoom: 16,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(newCamPos),
    );
  }

  Future<void> getLocationUpdates() async {
    bool locEnabled;
    PermissionStatus permGranted;

    locEnabled = await locController.serviceEnabled();
    if (locEnabled) {
      locEnabled = await locController.requestService();
    } else {
      return;
    }

    permGranted = await locController.hasPermission();
    if (permGranted == PermissionStatus.denied) {
      permGranted = await locController.requestPermission();
      if (permGranted != PermissionStatus.granted) {
        return;
      }
    }

    locController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentPos =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          camPos(currentPos!);
        });
      }
    });

    List<a.Placemark> placeMarks = await a.placemarkFromCoordinates(
        startPoint.latitude, startPoint.longitude);
    await _addMarkerToMap(
      markerPosition: GeoPoint(startPoint.latitude, startPoint.longitude),
      placeName: 'sVille',
    );
  }

  Future<List<LatLng>> getPoly() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_MAPS_API_KEY,
      PointLatLng(startPoint.latitude, startPoint.longitude),
      PointLatLng(endPoint.latitude, endPoint.longitude),
      travelMode: TravelMode.walking,
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  void generatePoly(List<LatLng> polylineCoords) async {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.black, points: polylineCoords, width: 8);
    setState(() {
      polylines[id] = polyline;
    });
  }

  Future<void> _addMarkerToMap(
      {required GeoPoint markerPosition, required String placeName}) async {
    try {
      List<a.Placemark> placeMarks = await a.placemarkFromCoordinates(
          markerPosition.latitude, markerPosition.longitude);
      a.Placemark marks = placeMarks[0];
      var points = LatLng(markerPosition.latitude, markerPosition.longitude);
      _markers.add(Marker(
          markerId: MarkerId(placeName),
          position: points,
          onTap: () async {
            final List<b.Nearby> result =
                await NearbyLocationApi.instance.getNearby(
                    userLocation:
                        // markerPosition,
                        GeoPoint(YOURLATLNG),
                    radius: 1000,
                    type: 'restaurants',
                    keyword: '');
            nearbyLocations = result;
          },
          infoWindow: InfoWindow(
            title: placeName,
            snippet:
                "${marks.name},${marks.locality}, ${marks.administrativeArea}",
          ),
          icon: BitmapDescriptor.defaultMarker));
    } catch (e) {
      print(e);
    }
  }
}

class Star extends StatelessWidget {
  final int count;
  const Star(
    this.count, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Row(
              children: List.generate(
                  5,
                  (index) => Icon(
                        Icons.star,
                        color: Colors.grey[300],
                        size: 15,
                      ))),
          Row(
              children: List.generate(
                  count,
                  (index) => Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 15,
                      ))),
        ],
      ),
    );
  }
}
