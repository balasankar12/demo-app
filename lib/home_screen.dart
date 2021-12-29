import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/database.dart';
import 'package:demo/map_picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<Position> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getPosition() async {
    await getUserLocation().then((value) async {
      Position initPos = value;
      List<Placemark> placemarks =
          await placemarkFromCoordinates(initPos.latitude, initPos.longitude);

      String _address = placemarks[0].name! +
          ' ,' +
          placemarks[0].street! +
          ' ,' +
          placemarks[0].thoroughfare! +
          ' ,' +
          placemarks[0].subLocality! +
          ' ,' +
          placemarks[0].locality! +
          '-' +
          placemarks[0].postalCode! +
          ' ,' +
          placemarks[0].isoCountryCode!;
      Map<String, dynamic> info = {
        'location': _address,
        'latitude': initPos.latitude,
        'longitude': initPos.longitude,
      };
      DatabaseMethods().insertToDB(info);
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _location = TextEditingController();
    TextEditingController _lat = TextEditingController();
    TextEditingController _lon = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD OPERATTION'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => MapPicker()));
            },
            icon: Icon(Icons.map),
          ),
          IconButton(
            onPressed: () {
              getPosition();
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: DatabaseMethods().getFromDB(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return ListView(
              children: (snapshot.data)!.docs.map((e) {
                return Card(
                  child: Column(
                    children: [
                      Text(e['location']),
                      Text(e['latitude'].toString()),
                      Text(e['longitude'].toString()),
                    ],
                  ),
                );
              }).toList(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: Text('Add Location'),
                    content: Column(
                      children: [
                        TextField(
                          controller: _location,
                          decoration: InputDecoration(
                            label: Text('Location'),
                          ),
                        ),
                        TextField(
                          controller: _lat,
                          decoration: InputDecoration(
                            label: Text('Latitude'),
                          ),
                        ),
                        TextField(
                          controller: _lon,
                          decoration: InputDecoration(
                            label: Text('Longitude'),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Map<String, dynamic> info = {
                                'location': _location.text,
                                'latitude': double.parse(_lat.text),
                                'longitude': double.parse(_lon.text)
                              };
                              DatabaseMethods().insertToDB(info);
                              Navigator.pop(context);
                            },
                            child: Text('Submit'))
                      ],
                    ),
                  ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
