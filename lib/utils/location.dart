import 'package:location/location.dart';

Future<bool> checkPermission() async {
  Location location = Location();
  PermissionStatus status = await location.hasPermission();
  if (status == PermissionStatus.denied ||
      status == PermissionStatus.deniedForever) {
    return false;
  }
  return true;
}

Future<LocationData> getLocation() async {
  Location location = Location();
  bool serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      throw Exception();
    }
  }

  PermissionStatus status = await location.hasPermission();
  if (status == PermissionStatus.denied) {
    status = await location.requestPermission();
    if (status != PermissionStatus.granted) {
      throw Exception();
    }
  }
  return await location.getLocation();
}
