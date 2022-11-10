// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:uber_driver_app/configMaps.dart';
import 'package:uber_driver_app/main.dart';
import 'package:uber_driver_app/screens/loginScreen.dart';

class ProfileTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              driversInformation.name,
              style: const TextStyle(
                fontSize: 65.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: "Signatra",
              ),
            ),
            Text(
              title + " driver",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.blueGrey[200],
                fontWeight: FontWeight.bold,
                fontFamily: "Brand-semibold",
              ),
            ),
            const SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            InfoCard(
              text: driversInformation.email,
              icon: Icons.email,
              onPressed: () async {
                print("this is email");
              },
            ),
            InfoCard(
              text: driversInformation.car_color +
                  " " +
                  driversInformation.car_model +
                  " " +
                  driversInformation.car_number,
              icon: Icons.car_repair,
              onPressed: () async {
                print("this is car info");
              },
            ),
            GestureDetector(
              onTap: () {
                Geofire.removeLocation(currentfirebaseUser.uid);
                rideRequestRef.onDisconnect();
                rideRequestRef.remove();
                rideRequestRef = null;

                FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, LoginScreen.routeName, (route) => false);
              },
              child: const Card(
                color: Colors.red,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 115.0),
                child: ListTile(
                  trailing: Icon(
                    Icons.follow_the_signs_outlined,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Sign out",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: "Brand-semibold"),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

class InfoCard extends StatelessWidget {
  final String text;
  final IconData icon;
  Function onPressed;

  InfoCard({this.text, this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.black87,
          ),
          title: Text(
            text,
            style: const TextStyle(
                color: Colors.black87,
                fontSize: 16.0,
                fontFamily: "Brand-semibold"),
          ),
        ),
      ),
    );
  }
}
