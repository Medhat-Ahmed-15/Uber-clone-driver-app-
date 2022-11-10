// ignore_for_file: file_names

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_driver_app/Assistants/assistantMethods.dart';
import 'package:uber_driver_app/Assistants/mapKitAssistant.dart';
import 'package:uber_driver_app/Models/rideDetails.dart';
import 'package:uber_driver_app/configMaps.dart';
import 'package:uber_driver_app/main.dart';
import 'package:uber_driver_app/widgets/collectFareDialog.dart';
import 'package:uber_driver_app/widgets/progressDialog.dart';

class NewRideScreen extends StatefulWidget {
  RideDetails rideDetails;

  NewRideScreen({this.rideDetails});

  static final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  State<NewRideScreen> createState() => _NewRideScreenState();
}

class _NewRideScreenState extends State<NewRideScreen> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  Set<Marker> markerSet = Set<Marker>();
  Set<Circle> circleSet = Set<Circle>();
  Set<Polyline> polylineSet = Set<Polyline>();
  List<LatLng> polylineCorOrdinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  GoogleMapController newRideGoogleMapController;

  var geoLocator = Geolocator();
  var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.bestForNavigation);

  BitmapDescriptor animatingMarkerIcon;

  Position myPosition;

  String status = "accepted";
  String durationRide = "";

  bool isRequestingDirection = false;

  String btnTitle = "Arrived";
  Color btnColor = Colors.yellow[700];

  Timer timer;
  int durationCounter = 0;
  @override
  @override
  void initState() {
    super.initState();
    acceptRiderequest();
  }

  void createIconMarker() {
    if (animatingMarkerIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(2, 2));

      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/images/car_android.png')
          .then((value) {
        animatingMarkerIcon = value;
      });
    }
  }

  void getRideLiveLocationUpdates() {
    LatLng oldPos = LatLng(0, 0);

    rideStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      myPosition = position;
      LatLng mPosition = LatLng(position.latitude, position.longitude);

      var rot = MapKitAssistant.getMarkerRotation(
          oldPos.latitude,
          oldPos.longitude,
          mPosition.latitude,
          mPosition
              .longitude); //tayb hna ana bageeb el rotation mabeon el point 0 w el point el ana feeha delw2ty haln..w bama 2n ana gowa straem fana ba get updated kol snia lw fee rotation hasl 2w la2

      Marker animatingMarker = Marker(
          markerId: MarkerId('animating'),
          position: mPosition,
          icon: animatingMarkerIcon,
          rotation: rot,
          infoWindow: InfoWindow(title: 'Cureent Location'));

      setState(() {
        CameraPosition cameraPosition =
            CameraPosition(target: mPosition, zoom: 17);
        newRideGoogleMapController
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

        markerSet.removeWhere((marker) => marker.markerId.value == 'animating');
        markerSet.add(animatingMarker);
      });

      oldPos = mPosition;

      updateRideDetails();
      Map locMap = {
        "latitude": currentPosition.latitude.toString(),
        "longitude": currentPosition.longitude.toString(),
      };
      String rideRequestId = widget.rideDetails.ride_request_id;

      newRequestRef.child(rideRequestId).child('driver_location').set(locMap);
    });
  }

  Widget build(BuildContext context) {
    createIconMarker();
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: const EdgeInsets.only(bottom: 265.0),
            circles: circleSet,
            markers: markerSet,
            polylines: polylineSet,
            myLocationEnabled: true,
            initialCameraPosition: NewRideScreen._kGooglePlex,
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            onMapCreated: (GoogleMapController controller) async {
              _controllerGoogleMap.complete(controller);
              newRideGoogleMapController = controller;

              var currentLatLng =
                  LatLng(currentPosition.latitude, currentPosition.longitude);

              var pickUpLatLng = widget.rideDetails.pickup;

              await getPlaceDirection(currentLatLng, pickUpLatLng);
              getRideLiveLocationUpdates();
            },
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 16.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              height: 270.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 18.0),
                child: Column(
                  children: [
                    Text(
                      durationRide,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Brand-semibold',
                          color: Colors.yellow[700]),
                    ),
                    const SizedBox(
                      height: 6.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.rideDetails.rider_name,
                          style: const TextStyle(
                              fontFamily: 'Brand-semibold', fontSize: 24.0),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Icon(Icons.phone_android),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 26.0,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/pickicon.png',
                          height: 16.0,
                          width: 16.0,
                        ),
                        const SizedBox(
                          width: 18.0,
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              widget.rideDetails.pickup_address,
                              style: const TextStyle(fontSize: 18.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/desticon.png',
                          height: 16.0,
                          width: 16.0,
                        ),
                        const SizedBox(
                          width: 18.0,
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              widget.rideDetails.dropOff_address,
                              style: TextStyle(fontSize: 18.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 26.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: RaisedButton(
                        onPressed: () async {
                          if (status == "accepted") {
                            String rideRequestId =
                                widget.rideDetails.ride_request_id;

                            status = "arrived";
                            newRequestRef
                                .child(rideRequestId)
                                .child("status")
                                .set(status);

                            setState(() {
                              btnTitle = 'Start Trip';
                              btnColor = Colors.yellow[700];
                            });

                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) =>
                                    ProgressDialog(
                                      message: 'Please wait...',
                                    ));

                            await getPlaceDirection(widget.rideDetails.pickup,
                                widget.rideDetails.dropOff);

                            Navigator.pop(context);
                          } else if (status == "arrived") {
                            String rideRequestId =
                                widget.rideDetails.ride_request_id;

                            status = "onride";
                            newRequestRef
                                .child(rideRequestId)
                                .child("status")
                                .set(status);

                            setState(() {
                              btnTitle = 'End Trip';
                              btnColor = Colors.yellow[700];
                            });

                            initTimer();
                          } else if (status == 'onride') {
                            endTrip();
                          }
                        },
                        color: btnColor,
                        child: Padding(
                          padding: const EdgeInsets.all(17.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                btnTitle,
                                style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const Icon(
                                Icons.directions_car,
                                color: Colors.white,
                                size: 26.0,
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> getPlaceDirection(
      LatLng pickUpLatLng, LatLng dropOffLatLng) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              message: 'Please wait...',
            ));

    var details = await AssistantMethods.obtainPlaceDirectiondetails(
        pickUpLatLng, dropOffLatLng);

    Navigator.pop(context);

    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        mapKey,
        PointLatLng(pickUpLatLng.latitude, pickUpLatLng.longitude),
        PointLatLng(dropOffLatLng.latitude, dropOffLatLng.longitude));

    polylineCorOrdinates.clear();

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng pointLatLng) {
        polylineCorOrdinates
            //So basically, we have done here that now we have a list of latitude and longitude which will allow us to draw a line on map.
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polylineSet.clear();

    setState(() {
//Now we have to create an instance of the fully line and we have to pass the required parameters to it in order to redraw the polyline.

      Polyline polyline = Polyline(
          color: Colors.pink,
          polylineId: PolylineId('PolylineID'),
          jointType: JointType.round,
          points: polylineCorOrdinates,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true);

//but before we add a new one we have to make it clear that polyline is empty when ever we add a polyline to polyline set that why I cleared the set and aslo the list
      polylineSet.add(polyline);
    });

//showayt tazbeetat for animating the camera when drawing the line
    LatLngBounds latLngBounds;
    if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
        pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
          northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
    } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
          northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }

    newRideGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpMArker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        position: pickUpLatLng,
        markerId: MarkerId('pickUpId'));

    Marker dropOffLocMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: dropOffLatLng,
        markerId: MarkerId('dropOffId'));

    setState(() {
      markerSet.add(pickUpMArker);
      markerSet.add(dropOffLocMarker);
    });

    Circle pickUpCircle = Circle(
        fillColor: Colors.blueAccent,
        center: pickUpLatLng,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.yellowAccent,
        circleId: CircleId('pickUpId'));

    Circle dropOffCircle = Circle(
        fillColor: Colors.purple,
        center: dropOffLatLng,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.yellowAccent,
        circleId: CircleId('dropOffId'));

    setState(() {
      circleSet.add(pickUpCircle);
      circleSet.add(dropOffCircle);
    });
  }

  void acceptRiderequest() {
    String rideRequestId = widget.rideDetails.ride_request_id;
    newRequestRef.child(rideRequestId).child('status').set('accepted');
    newRequestRef
        .child(rideRequestId)
        .child('driver_name')
        .set(driversInformation.name);
    newRequestRef
        .child(rideRequestId)
        .child('driver_phone')
        .set(driversInformation.phone);
    newRequestRef
        .child(rideRequestId)
        .child('driver_id')
        .set(driversInformation.id);
    newRequestRef.child(rideRequestId).child('car_details').set(
        '${driversInformation.car_color}-${driversInformation.car_model}-${driversInformation.car_number}');

    Map locMap = {
      "latitude": currentPosition.latitude.toString(),
      "longitude": currentPosition.longitude.toString(),
    };

    newRequestRef.child(rideRequestId).child('driver_location').set(locMap);

    driversRef
        .child(currentfirebaseUser.uid)
        .child("history")
        .child(rideRequestId)
        .set(true);
  }

  void updateRideDetails() async {
    //el bool dah 'isRequestingDirection' 3ashan el function dee mayat3amalahasg call 3amal 3ala batal keda since 2n el function dee ha3mlha call gowa el stream position fa hayat3amalha call kol ma yahsl update fal position howa el kalam dah msh mantke balnasbalee bs ya3nii howa dah el 2alo
    if (isRequestingDirection == false) {
      isRequestingDirection = true;
      // 'myPosition' dah el variable el ba store feeh el updated live location el gah mn el function 'getRideLiveLocationUpdates'
      if (myPosition == null) {
        return;
      }

      var posLatLng = LatLng(myPosition.latitude, myPosition.longitude);
      LatLng destinationLatLng;

      if (status == 'accepted') {
        destinationLatLng = widget.rideDetails.pickup;
      } else {
        destinationLatLng = widget.rideDetails.dropOff;
      }

      var directionDetails = await AssistantMethods.obtainPlaceDirectiondetails(
          posLatLng, destinationLatLng);

      if (directionDetails != null) {
        setState(() {
          durationRide = directionDetails.durationText;
        });
      }
      isRequestingDirection = false;
    }
  }

  void initTimer() {
    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (timer) {
      durationCounter = durationCounter + 1;
    });
  }

  void endTrip() async {
    timer.cancel();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ProgressDialog(
              message: 'Please wait...',
            ));

    var currentLatLng = LatLng(myPosition.latitude, myPosition.longitude);

    var directionDetails = await AssistantMethods.obtainPlaceDirectiondetails(
        widget.rideDetails.pickup, currentLatLng);

    Navigator.pop(context);

    int fareAmount = AssistantMethods.calculateFares(directionDetails);

    String rideRequestId = widget.rideDetails.ride_request_id;

    newRequestRef
        .child(rideRequestId)
        .child('fares')
        .set(fareAmount.toString());

    newRequestRef.child(rideRequestId).child('status').set('ended');

    rideStreamSubscription.cancel();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CollectFareDialog(
              paymentMethod: widget.rideDetails.payment_method,
              fareAmount: fareAmount,
            ));

    saveEarnings(fareAmount);
  }

  void saveEarnings(int fareAmount) {
    driversRef
        .child(currentfirebaseUser.uid)
        .child('earnings')
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        double oldEarnings = double.parse(dataSnapshot.value.toString());

        double totalEarnings = fareAmount + oldEarnings;
        driversRef
            .child(currentfirebaseUser.uid)
            .child('earnings')
            .set(totalEarnings.toStringAsFixed(2));
      } else {
        double totalEarnings = fareAmount.toDouble();
        driversRef
            .child(currentfirebaseUser.uid)
            .child('earnings')
            .set(totalEarnings.toStringAsFixed(2));
      }
    });
  }
}
