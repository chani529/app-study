// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List todos = [];
  String input = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Study"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Text("Add Todolist"),
                    content: TextField(
                      onChanged: (String value) {
                        input = value;
                      },
                    ),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () {
                            addItem(title: input);
                            Navigator.of(context).pop(); // input 입력 후 창 닫히도록
                          },
                          child: Text("Add"))
                    ]);
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder(
          stream: readItems(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final _tasks = snapshot.data!.docs;
              print(snapshot.data.docs);
              return ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                        // 삭제 버튼 및 기능 추가
                        key: Key(_tasks[index]['title']),
                        child: Card(
                            elevation: 4,
                            margin: EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: ListTile(
                              title: Text(_tasks[index]['title']),
                              trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    deleteItem(docId: _tasks[index].id);
                                  }),
                            )));
                  });
            } else {
              return Text("ss");
            }
          }),
    );
  }

  static Stream<QuerySnapshot> readItems() {
    CollectionReference notesItemCollection =
        FirebaseFirestore.instance.collection('task_list');

    return notesItemCollection.snapshots();
  }

  Future<void> addItem({
    required String title,
  }) async {
    DocumentReference documentReferencer =
        FirebaseFirestore.instance.collection('task_list').doc();

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Notes item added to the database"))
        .catchError((e) => print(e));
  }

  Future<void> deleteItem({
    required String docId,
  }) async {
    DocumentReference documentReferencer =
        FirebaseFirestore.instance.collection('task_list').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }
}
