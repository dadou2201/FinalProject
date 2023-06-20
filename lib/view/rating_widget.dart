import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RatingWidget extends StatefulWidget {
  final String id;
  final List<String> array;
  final String? current_uid;
  RatingWidget({required this.id, required this.array, required this.current_uid}); // Constructeur avec la variable obligatoire

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}
class _RatingWidgetState extends State<RatingWidget> {
  int selectedStars = 0;
  late String id;
  late String current_uid;
  late List<String> array;
  final CollectionReference<Map<String, dynamic>> collectionReference =
  FirebaseFirestore.instance.collection('users');
  @override
  void initState() {
    super.initState();
    id = widget.id;
    array=widget.array;
    current_uid=widget.current_uid!;
  }
  @override
  Widget build(BuildContext context) {
    return Row(
        children: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                selectedStars = 1;
                ChangeDataBase(selectedStars,collectionReference);

              });
            },
            icon: Icon(
              selectedStars >= 1 ? Icons.star : Icons.star_border,
              size: 40,color: selectedStars >= 1 ? Colors.orange :Colors.grey[300] ,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                selectedStars = 2;
                ChangeDataBase(selectedStars,collectionReference);

              });
            },
            icon: Icon(
              selectedStars >= 2 ? Icons.star : Icons.star_border,
              size: 40,color: selectedStars >= 2 ? Colors.orange :Colors.grey[300] ,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                selectedStars = 3;
                ChangeDataBase(selectedStars,collectionReference);
              });
            },
            icon: Icon(
              selectedStars >= 3 ? Icons.star : Icons.star_border,
              size: 40,color: selectedStars >= 3 ? Colors.orange :Colors.grey[300] ,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                selectedStars = 4;
                ChangeDataBase(selectedStars,collectionReference);
              });
            },
            icon: Icon(
              selectedStars >= 4 ? Icons.star : Icons.star_border,
              size: 40,color: selectedStars >= 4 ? Colors.orange :Colors.grey[300] ,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                selectedStars = 5;
                ChangeDataBase(selectedStars,collectionReference);
              });
            },
            icon: Icon(
              selectedStars >= 5 ? Icons.star : Icons.star_border,
              size: 40,color: selectedStars >= 5
                ? Colors.orange :Colors.grey[300] ,
            ),
          ),

        ]
    );
  }

  Future<void> ChangeDataBase(int num,CollectionReference<Map<String, dynamic>> collectionReference) async {
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await collectionReference.doc('${id}').get();
    if (documentSnapshot.exists) {
      final data = documentSnapshot.data();
      int numberRatings = data?['numberRatings']+1;
      collectionReference.doc('${id}')
          .update({'numberRatings': numberRatings});

      List<dynamic> theList = data?['ratings_stars'];

      if (theList[0]==10) {
        // La liste n'existe pas, créez une nouvelle liste avec une valeur initiale
        theList[0]=num;
        collectionReference.doc('${id}')
            .update(({'ratings_stars': theList}));
        collectionReference.doc('${id}')
            .update(({'stars': num}));
        try {
          DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('partnerDemands').doc(current_uid).get();

          if (documentSnapshot.exists) {
            // Retrieve the list field from the document
            List<String> list = List<String>.from(documentSnapshot.get('partners'));

            // Remove the desired element from the list
            list.remove(id);

            // Update the document in Firestore with the modified list
            await FirebaseFirestore.instance.collection('partnerDemands').doc(current_uid).update({ 'partners': list });

            print('Element removed successfully');
          } else {
            print('Document does not exist');
          }
        } catch (e) {
          print('Error removing element: $e');
        }

      }
      else {
        theList.add(num);
        collectionReference.doc('${id}')
            .update(({'ratings_stars': theList}));

        double num_stars=0;
        for(int i=0;i<theList.length;i++){
          num_stars+=theList.elementAt(i).toDouble();
        }
        num_stars/=numberRatings.toDouble();
        collectionReference.doc('${id}')
            .update(({'stars': num_stars}));
        try {
          DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('partnerDemands').doc(current_uid).get();

          if (documentSnapshot.exists) {
            // Retrieve the list field from the document
            List<String> list = List<String>.from(documentSnapshot.get('partners'));

            // Remove the desired element from the list
            list.remove(id);

            // Update the document in Firestore with the modified list
            await FirebaseFirestore.instance.collection('partnerDemands').doc(current_uid).update({ 'partners': list });

            print('Element removed successfully');
          } else {
            print('Document does not exist');
          }
        } catch (e) {
          print('Error removing element: $e');
        }
      }


    }
  }
}