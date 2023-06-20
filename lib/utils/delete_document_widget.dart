import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteDocumentWidget extends StatelessWidget {
  final String collectionName;
  final String documentId;

  const DeleteDocumentWidget({
    required this.collectionName,
    required this.documentId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: IconButton(
        icon: Icon(Icons.delete,color: Colors.red,),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Confirmation'),
                content: Text('Are you sure you want to delete this partner demand ?'),
                actions: [
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Delete'),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection(collectionName)
                          .doc(documentId)
                          .delete()
                          .then((value) {
                        print('Document deleted successfully.');
                        Navigator.of(context).pop();
                      }).catchError((error) {
                        print('Error deleting document: $error');
                      });
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}