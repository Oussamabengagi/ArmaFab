import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FireStoreDataBase {
  List studentsList = [];
  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection("Students");

  Future getData() async {
    try {
      //to get data from a single/particular document alone.
      var temp = await collectionRef.doc("Door").get();

      // to get data from all documents sequentially

      studentsList.add(temp.data());

      return studentsList;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }
}
