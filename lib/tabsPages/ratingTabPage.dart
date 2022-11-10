// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../configMaps.dart';

class RatingTabPage extends StatefulWidget {
  @override
  State<RatingTabPage> createState() => _RatingTabPageState();
}

class _RatingTabPageState extends State<RatingTabPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        backgroundColor: Colors.transparent,
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
              const SizedBox(
                height: 22.0,
              ),
              const Text(
                'Your Rating',
                style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: "Brand-semibold",
                    color: Colors.black54),
              ),
              const SizedBox(
                height: 22.0,
              ),
              const Divider(),
              const SizedBox(
                height: 16.0,
              ),
              SmoothStarRating(
                isReadOnly: true,
                allowHalfRating: true,
                starCount: 5,
                rating: starCounter,
                size: 45.0,
                color: Colors.yellow[700],
              ),
              const SizedBox(
                height: 14.0,
              ),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 55.0,
                    fontFamily: "Signatra",
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 16.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
