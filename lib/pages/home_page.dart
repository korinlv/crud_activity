import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_activity/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Call the Firestore classes here
  final FirestoreService firestoreService = FirestoreService();
  //Text Controller
  final TextEditingController textController = TextEditingController();
  //function to open a dialog box to add subject
  void openSubjectBox({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          // functions to save
          ElevatedButton(
            onPressed: () {
              // Add new subject here
              if (docID == null) {
                firestoreService.addSubject(textController.text);
              }

              // update an existing subject
              else {
                firestoreService.updateSubject(
                  docID, textController.text);
              }

              // Clear the text field fter the save function
              textController.clear();

              // Close dialog box function
              Navigator.pop(context);
            },
            child: Text('Add Subject'),
            )
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Subject')),
      floatingActionButton: FloatingActionButton(
        onPressed: openSubjectBox,
        child: const Icon(Icons.add),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: firestoreService.getSubjectStream(),
          builder: (context, snapshot) {
            //if the database has data get all the subjects
            if (snapshot.hasData) {
              List subjectList = snapshot.data!.docs;

              return ListView.builder(
                itemCount: subjectList.length,
                itemBuilder: (context, index) {
                  //get the document
                  DocumentSnapshot document = subjectList[index];
                  String docID = document.id;

                  //get subject form each document
                  Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                  String subjectText = data ['subject'];

                  //display subject as a list card
                  return ListTile(
                    title: Text(subjectText),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //update button
                        IconButton(onPressed: () => openSubjectBox(docID: docID),
                        icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () => firestoreService.deleteSubject(docID),
                          icon: const Icon(Icons.delete)
                        )
                      ],
                    ),
                  );
                },
            );
          }

          //if there is no subject in the database return nothing
          else {
            return const Text("No subject");
          }
        },
      )
    );
  }
}
