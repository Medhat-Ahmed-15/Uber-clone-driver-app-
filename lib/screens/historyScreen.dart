// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_driver_app/DataHandler/appData.dart';
import 'package:uber_driver_app/widgets/historyItem.dart';

class HistoryScreen extends StatefulWidget {
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trip History"),
        backgroundColor: Colors.yellow[700],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_arrow_left),
        ),
      ),
      body: Provider.of<AppData>(context, listen: false)
              .tripHistoryDataList
              .isEmpty
          ? Column(
              children: [
                Expanded(child: Container()),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset('assets/images/sad.png'),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('You haven\'t done any trips yet'),
                Expanded(child: Container()),
              ],
            )
          : ListView.separated(
              padding: const EdgeInsets.all(0),
              // ignore: missing_return
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                thickness: 3.0,
                height: 3.0,
              ),

              itemCount: Provider.of<AppData>(context, listen: false)
                  .tripHistoryDataList
                  .length,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return HistoryItem(Provider.of<AppData>(context, listen: false)
                    .tripHistoryDataList[index]);
              },
            ),
    );
  }
}
