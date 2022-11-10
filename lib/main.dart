import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_driver_app/configMaps.dart';
import 'package:uber_driver_app/screens/carInfoScreen.dart';
import 'package:uber_driver_app/screens/loginScreen.dart';
import 'package:uber_driver_app/screens/mainscreen.dart';
import 'package:uber_driver_app/screens/registrationScreen.dart';
import 'package:uber_driver_app/screens/splashScreen.dart';

import 'DataHandler/appData.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase
      .initializeApp(); //I have to initialize the firebase app otherwise i am gonna get error

  currentfirebaseUser = FirebaseAuth.instance.currentUser;
  runApp(MyApp());
}

DatabaseReference userRef = FirebaseDatabase.instance.reference().child(
    'users'); //the reason for you can say, defining or initializing the database reference here on demand or dot file outside the glass is now whenever we need to choose a reference. OK, we will just call it anywhere, I mean at any page when we need it.

DatabaseReference driversRef =
    FirebaseDatabase.instance.reference().child('drivers');

DatabaseReference newRequestRef =
    FirebaseDatabase.instance.reference().child('Ride Requests');

DatabaseReference rideRequestRef = FirebaseDatabase.instance
    .reference()
    .child('drivers')
    .child(currentfirebaseUser.uid)
    .child('newRide');

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Taxi Driver App',
        theme: ThemeData(
          primaryColor: Colors.yellow[700],
        ),
        home: SplashScreen(),
        debugShowCheckedModeBanner:
            false, //if i make true it will display that this application is in debug model plus hathot el debug banner el bayb2 fal top right corner of the screen ,false hatsheel el debug banner
        routes: {
          LoginScreen.routeName: (ctx) => LoginScreen(),
          RegistrationScreen.routeName: (ctx) => RegistrationScreen(),
          MainScreen.routeName: (ctx) => MainScreen(),
          CarInfoScreen.routeName: (ctx) => CarInfoScreen(),
        },
      ),
    );
  }
}
