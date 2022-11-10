// ignore_for_file: file_names
import 'package:maps_toolkit/maps_toolkit.dart';

class MapKitAssistant {
  static double getMarkerRotation(sLat, sLng, dLat, dLng) {
    var rot = SphericalUtil.computeHeading(
        LatLng(sLat, sLng),
        LatLng(dLat,
            dLng)); //from the source location to the drop off location we can get the rotation of the whole root, that is how rotations are there

    return rot;
  }
}
