// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_driver_app/DataHandler/appData.dart';
import 'package:uber_driver_app/screens/historyScreen.dart';

class EarningTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.yellow[700],
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 70),
            child: Column(
              children: [
                const Text(
                  "Total Earnings",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "\$${Provider.of<AppData>(context, listen: false).earnings}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontFamily: "Brand-semibold"),
                )
              ],
            ),
          ),
        ),
        FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: () {
            print("go to history page");
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HistoryScreen()));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Image.asset(
                  "assets/images/uberx.png",
                  width: 70,
                ),
                const SizedBox(
                  width: 16,
                ),
                const Text(
                  "Total Trips",
                  style: TextStyle(fontSize: 16),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      Provider.of<AppData>(context, listen: false)
                          .countTrips
                          .toString(),
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 18, color: Colors.yellow[700]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(
          height: 2.0,
          thickness: 2.0,
        )
      ],
    );
  }
}
