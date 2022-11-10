import 'package:firebase_database/firebase_database.dart';

class Drivers {
  String name;
  String email;
  String phone;
  String id;
  String car_color;
  String car_model;
  String car_number;

  Drivers({
    this.car_color,
    this.car_model,
    this.car_number,
    this.email,
    this.id,
    this.name,
    this.phone,
  });

  Drivers.fromSnapshot(DataSnapshot dataSnapshot) {
    id = dataSnapshot.key;
    name = dataSnapshot.value['name'];
    email = dataSnapshot.value['email'];
    phone = dataSnapshot.value['phone'];
    car_color = dataSnapshot.value['car_details']['car_color'];
    car_model = dataSnapshot.value['car_details']['car_model'];
    car_number = dataSnapshot.value['car_details']['car_number'];
  }
}
