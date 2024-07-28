import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:popover/popover.dart';
import 'package:the_end/parts/bar_data.dart';
import 'package:the_end/parts/menu_items.dart';
import 'package:the_end/parts/my_button.dart';
import 'package:the_end/parts/my_button_colour.dart';
import 'package:the_end/parts/my_textfield.dart';
import 'package:the_end/screens/reports.dart';
import 'dart:async';

import 'package:the_end/screens/submission.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;

  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection('/users');
  final reviewController = TextEditingController();

  String usernameBRUH = '';
  String cafeID = '';
  double ratingCon = 0;

  Color bgColor = Colors.white;
  IconData bgIcon = Icons.sentiment_very_satisfied;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  Stream collectionStream =
      FirebaseFirestore.instance.collection('/markers').snapshots();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  @override
  void initState() {
    addCustomIcon();
    getMarker();
    super.initState();
  }

  void initMarker(specify, specifyId) async {
    print('initwerk ');
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position:
          LatLng(specify['location'].latitude, specify['location'].longitude),
      infoWindow: InfoWindow(title: specify['name']),
      icon: markerIcon,
      onTap: () {
        double crowdcount = 0;
        double subcount = 0;
        getCrowd(specify, specifyId, crowdcount, subcount);
      },
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(), "lib/images/mapicons/cafe.png")
        .then(
      (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }

  getMarker() async {
    final mark = await FirebaseFirestore.instance.collection('/markers').get();
    {
      for (var marker in mark.docs) {
        initMarker(marker.data(), marker.id);
        print('recentwerk' + marker.data().toString());
      }
    }
  }

  getCrowd(specify, specifyId, crowdcount, subcount) async {
    final mark = await FirebaseFirestore.instance
        .collection('/markers')
        .doc(specifyId)
        .collection('/crowd')
        .get();
    {
      for (var marker in mark.docs) {
        //print('does this work?');
        final splitted = marker.id.toString().split(', ');
        final timesplit = splitted[3].toString().split(':');
        /*print(DateFormat.EEEE().format(DateTime.now()) +
            splitted[0].toString() +
            ' ' +
            timesplit[0].toString() +
            ' ' +
            DateFormat.H().format(DateTime.now()));*/
        if (splitted[0] == DateFormat.EEEE().format(DateTime.now()) &&
            int.parse(timesplit[0]) ==
                int.parse(DateFormat.H().format(DateTime.now()))) {
          crowdcount += int.parse(marker.data()['people']);
          subcount += 1;
          print(
              'this works' + crowdcount.toString() + ' ' + subcount.toString());
        }
      }
    }
    sheetPop(specify, specifyId, crowdcount, subcount);
    cafeID = specifyId;
  }

  Future addReview() async {
    print(cafeID + ' i printed' + ' ' + currentUser.email.toString().trim());
    await FirebaseFirestore.instance
        .collection('/markers')
        .doc(cafeID)
        .collection('/reviews')
        .doc(currentUser.email.toString().trim())
        .set({
      'review': reviewController.text,
      'rating': ratingCon,
      'username': 'admin', //this is broken change later
    });
    addLog();
  }

  Future addLog() async {
    await FirebaseFirestore.instance
        .collection('/users')
        .doc(currentUser.email)
        .collection('/logs')
        .add({
      'log': currentUser.email.toString() + ' has submitted a review',
      'notif': 'Thank you for submitting a review and helping our community.',
      'date': DateFormat.yMMMMEEEEd().format(DateTime.now()) +
          ', ' +
          DateFormat.Hms().format(DateTime.now()),
    });
  }

  sheetPop(specify, specifyId, crowdcount, subcount) {
    print(specifyId.toString() + ' yes yes ' + specify.toString());
    String output = '0';
    String stat = '';
    if (subcount >= 1) {
      output = (crowdcount / subcount).round().toString();
    } else {
      output = '0';
    }

    switch (int.parse(output)) {
      case 0:
        bgColor = Colors.grey;
        bgIcon = Icons.add_circle_outline_rounded;
        stat = 'No Data';
        break;
      case 1:
        bgColor = Colors.lightGreen;
        bgIcon = Icons.sentiment_very_satisfied;
        stat = 'Empty';
        break;
      case 2:
        bgColor = Colors.yellow;
        bgIcon = Icons.sentiment_satisfied;
        stat = 'Barely Empty';
        break;
      case 3:
        bgColor = Colors.amber;
        bgIcon = Icons.sentiment_neutral;
        stat = 'Barely Crowded';
        break;
      case 4:
        bgColor = Colors.orange;
        bgIcon = Icons.sentiment_dissatisfied;
        stat = 'Crowded';
        break;
      case 5:
        bgColor = Colors.red;
        bgIcon = Icons.sentiment_very_dissatisfied;
        stat = 'Full';
        break;
    }
    showModalBottomSheet<dynamic>(
        backgroundColor: bgColor,
        context: context,
        isScrollControlled: true,
        //BarData myBarData = BarData(amount0: 0, amount1: 0, amount2: 0, amount3: 0, amount4: 0, amount5: 0, amount6: 0, amount7: 0, amount8: 0, amount9: 0, amount10: 0, amount11: 0, amount12: 0, amount13: 0, amount14: 0, amount15: 0, amount16: 0, amount17: 0, amount18: 0, amount19: 0, amount20: 0, amount21: 0, amount22: 0, amount23: 0),
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
              expand: false,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Scaffold(
                  backgroundColor: Colors.white,
                  body: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(bgIcon, size: 50, color: bgColor),
                        SizedBox(height: 40),
                        MyButtonColor(
                          text: stat,
                          btColor: bgColor,
                          onTap: () => showPopover(
                            context: context,
                            bodyBuilder: (context) => MenuItems(
                              cafId: specifyId,
                            ),
                            width: 250,
                            height: 250,
                            backgroundColor: Colors.red,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text('Reviews'),
                        SizedBox(height: 20),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('/markers')
                              .doc(specifyId.trim().toString())
                              .collection('/reviews')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              final snap = snapshot.data!.docs;
                              return ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                itemCount: snap.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: 70,
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(2, 2),
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 20),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            snap[index]['review'],
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 20),
                                          alignment: Alignment.bottomRight,
                                          child: Text(
                                            "${snap[index]['username']}",
                                            style: TextStyle(
                                              color:
                                                  Colors.grey.withOpacity(0.7),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        RatingBar(
                                          wrapAlignment: WrapAlignment.center,
                                          itemSize: 15,
                                          ignoreGestures: true,
                                          initialRating: double.parse(
                                              "${snap[index]['rating']}"),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                          ratingWidget: RatingWidget(
                                              full: Icon(Icons.star_rounded,
                                                  color:
                                                      const Color(0XFF5D7352)),
                                              half: Icon(Icons.star_rounded,
                                                  color:
                                                      const Color(0XFF5D7352)),
                                              empty: Icon(Icons.star_rounded,
                                                  color: Colors.white)),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                        MyTextField(
                          controller: reviewController,
                          hintText: 'Type in your review...',
                          obscureText: false,
                        ),
                        MyButton(
                          onTap: addReview,
                          text: 'Confirm Review',
                        ),
                        RatingBar(
                          wrapAlignment: WrapAlignment.center,
                          itemSize: 30,
                          ignoreGestures: false,
                          initialRating: 0,
                          onRatingUpdate: (rating) {
                            ratingCon = rating;
                          },
                          ratingWidget: RatingWidget(
                              full: Icon(Icons.star_rounded,
                                  color: const Color(0XFF5D7352)),
                              half: Icon(Icons.star_rounded,
                                  color: const Color(0XFF5D7352)),
                              empty:
                                  Icon(Icons.star_rounded, color: Colors.grey)),
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> getMarker() {
      return <Marker>[
        Marker(
          markerId: MarkerId('Something'),
          position: LatLng(14.455372191994792, 120.99455215378282),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: 'Shop'),
        )
      ].toSet();
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0XFF5D7352),
          centerTitle: true,
          title: Text('',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white)),
          elevation: 5,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Submit();
                    },
                  ),
                );
              },
              icon: Icon(
                Icons.help,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
        body: GoogleMap(
          markers: Set<Marker>.of(markers.values),
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(14.455372191994792, 120.99455215378282),
            zoom: 15,
          ),
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
        ));
  }
}
