// ignore_for_file: file_names

import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideDetails {
  String pickup_address;
  String dropOff_address;
  LatLng pickup;
  LatLng dropOff;
  String ride_request_id;
  String payment_method;
  String rider_name;
  String rider_phone;

  RideDetails(
      {this.dropOff,
      this.dropOff_address,
      this.payment_method,
      this.pickup,
      this.pickup_address,
      this.ride_request_id,
      this.rider_name,
      this.rider_phone});
}
