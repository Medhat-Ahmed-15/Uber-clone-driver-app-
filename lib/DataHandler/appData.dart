// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:uber_driver_app/Models/address.dart';
import 'package:uber_driver_app/Models/address.dart';
import 'package:uber_driver_app/Models/history.dart';

class AppData extends ChangeNotifier {
  String earnings = "0";
  int countTrips = 0;
  List<String> tripHistoryKeys = [];
  List<History> tripHistoryDataList = [];
  void updateEarnings(String updatedEarnings) {
    earnings = updatedEarnings;
    notifyListeners();
  }

  void updateTripCounter(int tripCount) {
    countTrips = tripCount;
    notifyListeners();
  }

  void updateTripKeys(List<String> newKeys) {
    tripHistoryKeys = newKeys;
    notifyListeners();
  }

  void updateTripHistoryData(History eachHistory) {
    tripHistoryDataList.add(eachHistory);
    notifyListeners();
  }
}
