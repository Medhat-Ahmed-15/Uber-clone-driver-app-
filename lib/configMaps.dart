// ignore_for_file: file_names

import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uber_driver_app/Models/allUsers.dart';

import 'Models/drivers.dart';

String mapKey = 'AIzaSyA0LLNiEnjHKM5kgKqb79-_UsBHyki3RHE';

User firebaseUser;

Users userCurrentInfo;

User currentfirebaseUser;
bool isDriverAvailable = false;
String driverStatusText = 'Offline Now - Go Online ';

Color driverStatusColor = Colors.black;

StreamSubscription<Position> homeTabPageStreamSubscription;

StreamSubscription<Position>
    rideStreamSubscription; //regarding animating the car icon so I need to get live updates for the location

final assetsAudioPlayer = AssetsAudioPlayer();

Drivers driversInformation;

String title = "";
String rideType = "";
double starCounter = 0.0;

Position currentPosition;
