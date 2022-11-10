// ignore_for_file: file_names

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_driver_app/Assistants/assistantMethods.dart';
import 'package:uber_driver_app/Models/drivers.dart';
import 'package:uber_driver_app/Notifications/pushNotificationService.dart';
import 'package:uber_driver_app/configMaps.dart';
import 'package:uber_driver_app/main.dart';
import 'package:uber_driver_app/screens/registrationScreen.dart';

class HomeTabPage extends StatefulWidget {
  static final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  GoogleMapController newGoogleMapController;

  var geoLocator = Geolocator();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCurrentDriverInfo();
  }

  void locatePosition() async {
    //get current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    currentPosition = position;

    //get latitude and longitude from that position
    LatLng latlngPosition = LatLng(position.latitude, position.longitude);

    //locating camera towards this position
    CameraPosition cameraPosition =
        new CameraPosition(target: latlngPosition, zoom: 14);

    //updating the camera position
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

//converting latlng to readable addresses
    //String address =
    //await AssistantMethods.searchCoordinateAddress(position, context);
  }

  getRideType() {
    driversRef
        .child(currentfirebaseUser.uid)
        .child("car_details")
        .child("type")
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        setState(() {
          rideType = snapshot.value.toString();
        });
      }
    });
  }

  void getCurrentDriverInfo() {
    currentfirebaseUser = FirebaseAuth.instance.currentUser;

    driversRef
        .child(currentfirebaseUser.uid)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        driversInformation = Drivers.fromSnapshot(dataSnapshot);
      }
    });

    PushNotificationService pushNotificationService = PushNotificationService();

    pushNotificationService.initialize(context);
    pushNotificationService.getToken();

    AssistantMethods.retrieveHistoryInfo(context);
    getRatings();
    getRideType();
  }

  getRatings() {
    //update ratings
    driversRef
        .child(currentfirebaseUser.uid)
        .child("ratings")
        .once()
        .then(((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        String ratings = dataSnapshot.value.toString();

        setState(() {
          starCounter = double.parse(ratings);
        });

        if (starCounter <= 1) {
          setState(() {
            title = "Very Bad";
          });
          return;
        }
        if (starCounter <= 2) {
          setState(() {
            title = "Bad";
          });
          return;
        }
        if (starCounter <= 3) {
          setState(() {
            title = "Good";
          });
          return;
        }
        if (starCounter <= 4) {
          setState(() {
            title = "Very Good";
          });
          return;
        }
        if (starCounter <= 5) {
          setState(() {
            title = "Excellent";
          });
          return;
        }
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          myLocationEnabled: true,
          initialCameraPosition: HomeTabPage._kGooglePlex,
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;

            locatePosition();
          },
        ),
        //online offline driver Container

        Container(
          height: 140.0,
          width: double.infinity,
          color: Colors.black54,
        ),

        Positioned(
          top: 60.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                // ignore: deprecated_member_use
                child: RaisedButton(
                  onPressed: () {
                    if (isDriverAvailable != true) {
                      makeDriverOnlineNow();
                      getLocationLiveUpdate();

                      setState(() {
                        driverStatusColor = Colors.green;
                        driverStatusText = 'Online Now';
                        isDriverAvailable = true;
                      });

                      displayToastMessage('You are Online Now.');
                    } else {
                      setState(() {
                        driverStatusColor = Colors.black;
                        driverStatusText = 'Offline Now - Go Online ';
                        isDriverAvailable = false;
                      });
                      makeDriverOfflineNow();
                    }
                  },
                  color: driverStatusColor,
                  child: Padding(
                    padding: const EdgeInsets.all(17.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          driverStatusText,
                          style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const Icon(
                          Icons.phone_android,
                          color: Colors.white,
                          size: 26.0,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void makeDriverOnlineNow() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    currentPosition = position;

    //Geo fire updates the location of the driver to realtime database every second
    Geofire.initialize(
        'availableDrivers'); // this string 'availableDrivers' must be the same as the one in the rules of firebase and this creates a node in firebase with this title
    Geofire.setLocation(currentfirebaseUser.uid, currentPosition.latitude,
        currentPosition.longitude);

    rideRequestRef.set('searching');

    rideRequestRef.onValue.listen((event) {});
  }

  void makeDriverOfflineNow() {
    Geofire.removeLocation(currentfirebaseUser.uid);
    //rideRequestRef.onDisconnect();
    rideRequestRef.remove();

    displayToastMessage('You are Offline Now.');
  }

  void getLocationLiveUpdate() {
    //"Geolocator" ::: Wraps CLLocationManager (on iOS) and FusedLocationProviderClient or LocationManager (on Android), providing support to retrieve position information of the device.
    //"getPositionStream()" ::: Fires whenever the location changes inside the bounds of the [desiredAccuracy]. This event starts all location sensors on the device and will keep them active until you cancel listening to the stream or when the application is killed
    homeTabPageStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;

      if (isDriverAvailable == true) {
        Geofire.setLocation(currentfirebaseUser.uid, currentPosition.latitude,
            currentPosition.longitude);
      }

      //move the camera to the new position
      LatLng latLng = LatLng(position.latitude, position.longitude);
      newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }
}
