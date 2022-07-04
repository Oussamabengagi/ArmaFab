import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class getDoor extends StatelessWidget {
  final String documentId;

  getDoor({required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference door = FirebaseFirestore.instance.collection('Door');

    return FutureBuilder<DocumentSnapshot>(
      future: door.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          if ("${data['door']}" == "1") {
            return const Image(
              image: AssetImage('assets/images/open.png'),
              height: 60,
              width: 30,
              fit: BoxFit.fitHeight,
              alignment: Alignment.centerLeft,
            );
          } else if ("${data['door']}" == "0") {
            return Image(
              image: AssetImage('assets/images/closed.png'),
              height: 60,
              width: 30,
              fit: BoxFit.fitHeight,
              alignment: Alignment.centerLeft,
            );
          }
        }
        return Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
              new Text("Data is loading please wait !!"),
            ],
          ),
        );
      }),
    );
  }
}
