// ignore_for_file: file_names

import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_driver_app/Models/rideDetails.dart';
import 'package:uber_driver_app/configMaps.dart';
import 'package:uber_driver_app/main.dart';

import 'notificationDialog.dart';

class PushNotificationService {
  //first we have to initialize the firebase messaging after that we have to get firebase messaging registering token using which we can recognise single application

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

//Now what i wrote here inside this method is for basically receiving a notification
  Future initialize(context) async {
    //  'firebaseMessaging.configure' ==> Sets up [MessageHandler] for incoming messages.
    firebaseMessaging.configure(
      //this works when the driver app is open, when the driver opens the app and waiting for riders at this time when a notificaton is received then this onMessage will be triggered
      onMessage: (Map<String, dynamic> message) async {
        print("on message $message");
        retrieveRideRequestInfo(getRideRequestId(message), context);
      },

      //when the driver clicks on the notification this onLaunch will be called
      onLaunch: (Map<String, dynamic> message) async {
        print("on message $message");
        retrieveRideRequestInfo(getRideRequestId(message), context);
      },

      //this will be triggerd if the driver's app is in the background state, for example he is minimizing the driver app and using another application
      onResume: (Map<String, dynamic> message) async {
        print("on message $message");
        retrieveRideRequestInfo(getRideRequestId(message), context);
      },
    );
  }

  Future<String> getToken() async {
    String token = await firebaseMessaging.getToken();

    print(
        'This is token:   $token'); // el token dah bahoto fal body fal 'to:' 3ashan 2ab3t lal user dah specifically el notification
    driversRef.child(currentfirebaseUser.uid).child('token').set(token);

    firebaseMessaging.subscribeToTopic('alldrivers');
    firebaseMessaging.subscribeToTopic('allusers');
  }

  String getRideRequestId(Map<String, dynamic> message) {
    String rideRequestId = null;

    //receving notification differs from android to ios, for ios you must have Apple developer account, which cost ninety nine dollars per year in order for the push notifications to work
    if (Platform.isAndroid) {
      rideRequestId = message['data']['ride_request_id'];
    } else {
      rideRequestId = message['ride_request_id'];
    }

    return rideRequestId;
  }

  void retrieveRideRequestInfo(String rideRequestId, BuildContext context) {
    newRequestRef
        .child(rideRequestId)
        .once()
        .then((DataSnapshot dataSnapshot) async {
      if (dataSnapshot.value != null) {
        await assetsAudioPlayer.open(Audio('assets/sounds/alert.mp3'));
        await assetsAudioPlayer.play();

        double pickUpLocationLat =
            double.parse(dataSnapshot.value['pickUp']['latitude'].toString());

        double pickUpLocationLng =
            double.parse(dataSnapshot.value['pickUp']['longitude'].toString());

        String pickUpAdress = dataSnapshot.value['pickup_address'].toString();

        double dropOffLocationLat =
            double.parse(dataSnapshot.value['dropOff']['latitude'].toString());

        double dropOffLocationLng =
            double.parse(dataSnapshot.value['dropOff']['longitude'].toString());

        String dropOffAdress = dataSnapshot.value['dropOff_address'].toString();

        String paymentMethod = dataSnapshot.value['payment_method'].toString();

        String riderName = dataSnapshot.value['rider_name'].toString();

        int riderPhone =
            int.parse(dataSnapshot.value['rider_phone'].toString());

        RideDetails rideDetails = RideDetails();
        rideDetails.ride_request_id = rideRequestId;
        rideDetails.pickup_address = pickUpAdress;
        rideDetails.dropOff_address = dropOffAdress;
        rideDetails.pickup = LatLng(pickUpLocationLat, pickUpLocationLng);
        rideDetails.dropOff = LatLng(dropOffLocationLat, dropOffLocationLng);
        rideDetails.payment_method = paymentMethod;
        rideDetails.rider_name = riderName;
        rideDetails.rider_phone = riderPhone.toString();

        print('Information::');
        print('Information ride_request_id:: + ${rideDetails.ride_request_id}');
        print('Information pickup_address:: + ${rideDetails.pickup_address}');
        print('Information dropOff_address:: + ${rideDetails.dropOff_address}');
        print('Information pickup:: + ${rideDetails.pickup}');
        print('Information dropOff:: + ${rideDetails.dropOff}');
        print('Information payment_method:: + ${rideDetails.payment_method}');

        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => NotificationDialog(
                  rideDetails: rideDetails,
                ));
      }
    });
  }
}
