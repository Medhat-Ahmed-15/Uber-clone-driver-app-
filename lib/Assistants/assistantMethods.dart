// ignore_for_file: file_names

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uber_driver_app/Assistants/requestAssistant.dart';
import 'package:uber_driver_app/DataHandler/appData.dart';

import 'package:uber_driver_app/Models/directdetails.dart';
import 'package:uber_driver_app/Models/history.dart';
import 'package:uber_driver_app/configMaps.dart';
import 'package:uber_driver_app/main.dart';

class AssistantMethods {
  static Future<DirectionDetails> obtainPlaceDirectiondetails(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl =
        'https://maps.googleapis.com/maps/api/directions/json?&destination=${finalPosition.longitude},${finalPosition.latitude}&origin=${initialPosition.longitude},${initialPosition.latitude}&key=$mapKey';

    var res = await RequestAssistant.getRequest(directionUrl);

    if (res == 'failed') {
      return null;
    }

    DirectionDetails directiondetails = DirectionDetails();

    directiondetails.encodedPoints =
        res['routes'][0]['overview_polyline']['points'];

    directiondetails.distanceText =
        res['routes'][0]['legs'][0]['distance']['text'];

    directiondetails.distancevalue =
        res['routes'][0]['legs'][0]['distance']['value'];

    directiondetails.durationText =
        res['routes'][0]['legs'][0]['duration']['text'];

    directiondetails.durationValue =
        res['routes'][0]['legs'][0]['duration']['value'];

    return directiondetails;
  }

  static int calculateFares(DirectionDetails directionDetails) {
    //in terms USD
    double timeTravelFare = (directionDetails.durationValue / 60) * 0.20;
    double distanceTravelFare = (directionDetails.distancevalue / 1000) * 0.20;
    double totalFareAmount = timeTravelFare + distanceTravelFare;

    //local currency
    //1$=16EG
    double totalLocalAmount = totalFareAmount * 16;

    if (rideType == "uber-x") {
      double result = (totalLocalAmount.truncate()) * 2.0;
      return result.truncate();
    } else if (rideType == "uber-go") {
      return totalLocalAmount.truncate();
    } else if (rideType == "bike") {
      double result = (totalLocalAmount.truncate()) / 2.0;
      return result.truncate();
    } else {
      return totalLocalAmount.truncate();
    }
  }

  static void disablehomeTablivelocationUpdates() {
    homeTabPageStreamSubscription
        .pause(); //dah ba kol basata 3ashan a pause listneing lal current position bata3 el mobile el masko el current user (since 2n 'homeTabPageStreamSubscription' assigned 2n haya tageeb el position bata3 el current mobile el mamsook ya3nii ba2eet el users msh hayat2asaro)
    Geofire.removeLocation((currentfirebaseUser
        .uid)); //w dah brdo ba kol basta 3ashan a remove user mn 2n yakoon available driver since 2n howa delw2ty fa ride
  }

  static void enablehomeTablivelocationUpdates() {
    homeTabPageStreamSubscription.resume();
    Geofire.setLocation(currentfirebaseUser.uid, currentPosition.latitude,
        currentPosition.longitude);
  }

  static void retrieveHistoryInfo(context) {
    //retreive and display earnings
    driversRef
        .child(currentfirebaseUser.uid)
        .child("earnings")
        .once()
        .then(((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        String earnings = dataSnapshot.value.toString();
        Provider.of<AppData>(context, listen: false).updateEarnings(earnings);
      }
    }));

    //retreive and trip history
    driversRef
        .child(currentfirebaseUser.uid)
        .child("history")
        .once()
        .then(((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        //update total number of trip counts to Provider
        Map<dynamic, dynamic> keys = dataSnapshot.value;
        int tripCounter = keys.length;
        Provider.of<AppData>(context, listen: false)
            .updateTripCounter(tripCounter);

        //update trip keys to provider
        List<String> tripHistorykeys = [];
        keys.forEach((key, value) {
          tripHistorykeys.add(key);
        });

        Provider.of<AppData>(context, listen: false)
            .updateTripKeys(tripHistorykeys);

        obtainTripRequestHistoryData(context);
      }
    }));
  }

  static void obtainTripRequestHistoryData(context) {
    var keys = Provider.of<AppData>(context, listen: false).tripHistoryKeys;

    for (String key in keys) {
      newRequestRef.child(key).once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          var history = History.fromSnapshot(snapshot);
          Provider.of<AppData>(context, listen: false)
              .updateTripHistoryData(history);
        }
      });
    }
  }

  static String formatTripDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate =
        "${DateFormat.MMMd().format(dateTime)},${DateFormat.y().format(dateTime)}-${DateFormat.jm().format(dateTime)}";

    return formattedDate;
  }
}
