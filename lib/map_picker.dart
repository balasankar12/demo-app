import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPicker extends StatefulWidget {
  const MapPicker({Key? key}) : super(key: key);

  @override
  _MapPickerState createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  static const _initialCameraPosition =
  CameraPosition(target: LatLng(13.010651, 80.2331943), zoom: 17);
  late GoogleMapController _googleMapController;
  late Position? initPos = getPosition();
  late Position? markerPos;
  late Marker _userLocation = Marker(
    markerId: MarkerId("User's Home"),
    infoWindow: InfoWindow(title: 'Home'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    position: LatLng(initPos != null ? initPos?.latitude as double : 13.010651,
        initPos != null ? initPos?.longitude as double : 80.2331943),
  );

  Future<Position> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getPosition() {
    getUserLocation().then((value) {
      print('Map Co-ordinates');
      print(value);
      setState(() {
        initPos = value;
      });
      initPos = value;
      print('init Position');
      print(initPos);
    });
  }

  @override
  void initState() {
    super.initState();
    getPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: GoogleMap(
          initialCameraPosition: _initialCameraPosition,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          onMapCreated: (controller) => _googleMapController = controller,
          markers: {
            _userLocation,
          },
          onTap: (argument) {
            print('long pressed');
            print(argument);
            // _addMarker(argument);
          },
        ),
      ),
    );
  }
}
