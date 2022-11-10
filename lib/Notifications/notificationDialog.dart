// ignore_for_file: file_names

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uber_driver_app/Assistants/assistantMethods.dart';
import 'package:uber_driver_app/Models/rideDetails.dart';
import 'package:uber_driver_app/main.dart';
import 'package:uber_driver_app/screens/newRideScreen.dart';
import 'package:uber_driver_app/screens/registrationScreen.dart';

import '../configMaps.dart';

class NotificationDialog extends StatelessWidget {
  final RideDetails rideDetails;

  NotificationDialog({this.rideDetails});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.transparent,
      elevation: 1.0,
      child: Container(
        margin: const EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30.0),
            Image.asset(
              'assets/images/taxi.png',
              width: 120.0,
            ),
            const SizedBox(height: 18.0),
            const Text(
              'New Ride Request',
              style: TextStyle(
                fontFamily: 'Brand-semibold',
                fontSize: 18.0,
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/pickicon.png',
                        height: 16.0,
                        width: 16.0,
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            rideDetails.pickup_address,
                            style: const TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/desticon.png',
                        height: 16.0,
                        width: 16.0,
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            rideDetails.dropOff_address,
                            style: const TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15.0,
                  )
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            const Divider(
              height: 2.0,
              color: Colors.black,
              thickness: 2.0,
            ),
            const SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: Colors.red)),
                    color: Colors.white,
                    textColor: Colors.red,
                    padding: const EdgeInsets.all(8.0),
                    onPressed: () async {
                      cancel(context);
                      await assetsAudioPlayer.stop();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel'.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 25.0),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(
                          color: Colors.yellow[700],
                        )),
                    onPressed: () async {
                      await assetsAudioPlayer.stop();
                      checkAvailability(context);
                    },
                    color: Colors.yellow[700],
                    textColor: Colors.white,
                    child: Text('Accept'.toUpperCase(),
                        style: const TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            )
          ],
        ),
      ),
    );
  }

  void checkAvailability(BuildContext context) {
    rideRequestRef.once().then((DataSnapshot dataSnapshot) {
      String theRideId = '';
      if (dataSnapshot.value != null) {
        theRideId = dataSnapshot.value.toString();
      } else {
        displayToastMessage('Ride not exists');
      }

      if (theRideId == rideDetails.ride_request_id) {
        rideRequestRef.set('accepted');
        AssistantMethods.disablehomeTablivelocationUpdates();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewRideScreen(rideDetails: rideDetails)));
      } else if (theRideId == 'cancelled') {
        displayToastMessage('Ride has been Cancelled');
      } else if (theRideId == 'timeout') {
        displayToastMessage('Ride had time out');
      } else {
        displayToastMessage('Ride not exists');
      }
    });
  }

  void cancel(BuildContext context) {
    rideRequestRef.once().then((DataSnapshot dataSnapshot) {
      String theRideId = '';
      if (dataSnapshot.value != null) {
        theRideId = dataSnapshot.value.toString();
      } else {
        displayToastMessage('Ride not exists');
      }

      if (theRideId == rideDetails.ride_request_id) {
        rideRequestRef.set('cancelled');
        newRequestRef.child(theRideId).child("status").set("cancelled");
      }
    });
  }
}
