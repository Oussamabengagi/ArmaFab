import 'package:arma/getData/get_door.dart';
import 'package:arma/screens/signin_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

readData() async {
  DocumentReference documentReference =
      FirebaseFirestore.instance.collection('Door').doc("JsNEEGZHBFnIP04XBcrV");

  documentReference.get().then((dataSnapshot) {
    var Strr = dataSnapshot.data().toString();

    print(Strr);
    var result = Strr.substring(7, 8);
    print("----------");
    print(result);
    return result;
  });
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  List<String> docIDs = [];

  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('Door')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              print(document.reference);
              docIDs.add(document.reference.id);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          user.email!,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => SignInScreen()));
            },
            child: Icon(Icons.logout_sharp),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: FutureBuilder(
              future: getDocId(),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: docIDs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: getDoor(documentId: docIDs[index]),
                    );
                  },
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
