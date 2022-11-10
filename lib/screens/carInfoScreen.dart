// ignore_for_file: file_names

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:uber_driver_app/configMaps.dart';
import 'package:uber_driver_app/main.dart';
import 'package:uber_driver_app/screens/mainscreen.dart';
import 'package:uber_driver_app/screens/registrationScreen.dart';

class CarInfoScreen extends StatefulWidget {
  static const String routeName = 'carinfo';

  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  TextEditingController carNumberTextEditingController =
      TextEditingController();

  TextEditingController carColorTextEditingController = TextEditingController();

  TextEditingController carModelTextEditingController = TextEditingController();

  String selectedCarType = 'uber-x';

  FocusNode carModelFocusNode = FocusNode();

  FocusNode carNumberFocusNode = FocusNode();

  FocusNode carColorFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 22.0,
            ),
            Image.asset(
              'assets/images/logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(
              height: 12.0,
            ),
            const Text(
              'Enter Car Details',
              style: TextStyle(fontFamily: 'Brand-semibold', fontSize: 24.0),
            ),
            const SizedBox(
              height: 26.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 32,
                right: 32,
              ),
              child: TextField(
                keyboardType: TextInputType.text,
                onTap: () {
                  setState(() {});
                },
                controller: carModelTextEditingController,
                focusNode: carModelFocusNode,
                style: const TextStyle(color: Colors.black),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.local_taxi_outlined,
                    color: carModelFocusNode.hasFocus
                        ? Theme.of(context).primaryColor
                        : Colors.grey[700],
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[700]),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  labelText: 'Car Model',
                  labelStyle: TextStyle(
                    color: carModelFocusNode.hasFocus
                        ? Theme.of(context).primaryColor
                        : Colors.grey[700],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 32,
                right: 32,
              ),
              child: TextField(
                keyboardType: TextInputType.text,
                onTap: () {
                  setState(() {});
                },
                controller: carNumberTextEditingController,
                focusNode: carNumberFocusNode,
                style: const TextStyle(color: Colors.black),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.confirmation_number_outlined,
                    color: carNumberFocusNode.hasFocus
                        ? Theme.of(context).primaryColor
                        : Colors.grey[700],
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[700]),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  labelText: 'Car Number',
                  labelStyle: TextStyle(
                    color: carNumberFocusNode.hasFocus
                        ? Theme.of(context).primaryColor
                        : Colors.grey[700],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 32,
                right: 32,
              ),
              child: TextField(
                keyboardType: TextInputType.text,
                onTap: () {
                  setState(() {});
                },
                controller: carColorTextEditingController,
                focusNode: carColorFocusNode,
                style: const TextStyle(color: Colors.black),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.color_lens_outlined,
                    color: carColorFocusNode.hasFocus
                        ? Theme.of(context).primaryColor
                        : Colors.grey[700],
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[700]),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  labelText: 'Car Color',
                  labelStyle: TextStyle(
                    color: carColorFocusNode.hasFocus
                        ? Theme.of(context).primaryColor
                        : Colors.grey[700],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 26.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 32,
                right: 32,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon(Icons.golf_course_rounded,
                  //     size: 18, color: Colors.grey[700]),
                  Text(
                    'Please choose car type:',
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  DropdownButton<String>(
                    dropdownColor: Theme.of(context).cardColor,
                    iconEnabledColor: Theme.of(context).primaryColor,
                    value: selectedCarType,
                    underline: Container(
                      height: 0,
                    ),
                    icon: const Icon(Icons.arrow_downward_sharp),
                    iconSize: 15,
                    elevation: 16,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                    onChanged: (newValue) {
                      setState(() {
                        selectedCarType = newValue;
                      });

                      displayToastMessage(selectedCarType);
                    },
                    items: [
                      DropdownMenuItem(
                        child: SizedBox(
                          width: 100,
                          height: 50,
                          child: Row(
                            children: [
                              Expanded(
                                  child:
                                      Image.asset('assets/images/uberx.png')),
                              const Expanded(
                                child: Text(
                                  'Uber-X',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        value: 'uber-x',
                      ),
                      DropdownMenuItem(
                        child: SizedBox(
                          width: 120,
                          height: 50,
                          child: Row(
                            children: [
                              Expanded(
                                  child:
                                      Image.asset('assets/images/ubergo.png')),
                              const Expanded(
                                child: Text(
                                  'Uber-Go',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        value: 'uber-go',
                      ),
                      DropdownMenuItem(
                        child: SizedBox(
                          width: 100,
                          height: 50,
                          child: Row(
                            children: [
                              Expanded(
                                  child: Image.asset('assets/images/bike.png')),
                              const Expanded(
                                child: Text(
                                  'Bike',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        value: 'bike',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 42.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 32,
                right: 32,
              ),
              child: RaisedButton(
                textColor: Colors.black,
                color: Colors.yellow[700],
                onPressed: () {
                  //Save car info to database

                  if (carModelTextEditingController.text.isEmpty) {
                    displayToastMessage('please write car Model.');
                  } else if (carNumberTextEditingController.text.isEmpty) {
                    displayToastMessage('please write car Number.');
                  } else if (carColorTextEditingController.text.isEmpty) {
                    displayToastMessage('please write car Color.');
                  } else if (selectedCarType == null) {
                    displayToastMessage('please select car type.');
                  } else {
                    saveDriverCarInfo(context);
                  }
                },
                child: Container(
                  height: 50.0,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Next',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 26.0,
                        ),
                      ],
                    ),
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0)),
              ),
            )
          ],
        ),
      )),
    );
  }

  void saveDriverCarInfo(context) {
    String userId = currentfirebaseUser.uid;

    Map carInfoMap = {
      'car_color': carColorTextEditingController.text,
      'car_number': carNumberTextEditingController.text,
      'car_model': carModelTextEditingController.text,
      'type': selectedCarType,
    };

    driversRef.child(userId).child('car_details').set(carInfoMap);
    Navigator.pushNamedAndRemoveUntil(
        context, MainScreen.routeName, (route) => false);
  }
}
