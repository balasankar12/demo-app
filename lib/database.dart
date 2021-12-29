import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  insertToDB(Map<String, dynamic> info) {
    FirebaseFirestore.instance.collection('locations').add(info);
  }
  getFromDB() {
    return FirebaseFirestore.instance.collection('locations').snapshots();
  }
}