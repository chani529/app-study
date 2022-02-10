// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirstRoute(title: 'First Route'),
    );
  }
}

class FirstRoute extends StatefulWidget {
  final String title;

  const FirstRoute({Key? key, required this.title}) : super(key: key);

  @override
  _FirstRouteState createState() => _FirstRouteState();
}

class _FirstRouteState extends State<FirstRoute> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("test"),
        ),
        body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection("task_list").snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            print("xxx");
            print(snapshot);
            if (snapshot.connectionState == ConnectionState.done) {
              print(snapshot.data);
              return Column(
                children: [
                  SizedBox(
                    height: 27,
                    child: Text(
                      "title: ${snapshot.data!}",
                      overflow: TextOverflow.fade,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.none) {
              return Text("No data");
            }
            return CircularProgressIndicator();
          },
        ));
  }

  // Stream<DocumentSnapshot> getData() async {
  //   await Firebase.initializeApp();
  //   return await FirebaseFirestore.instance
  //       .collection("task_list")
  //       .snapshots();
  // }
}
