import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AcceptButton extends StatefulWidget {
  final String id;
  final List<String> array;
  final String? current_uid;
  const AcceptButton({required this.id, required this.array, this.current_uid });

  @override
  _AcceptButtonState createState() => _AcceptButtonState();
}

class _AcceptButtonState extends State<AcceptButton> {

  bool isAccepted=false;
  late String id;
  late String current_uid;
  late List<String> array;
  void initState() {
    super.initState();
    id = widget.id;
    array=widget.array;
    current_uid=widget.current_uid!;
    if(array.contains(id)){
      isAccepted=true;
    }
  }
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        void showAlertDialog1(
            BuildContext context) {
          // Définit les boutons de la boîte de dialogue
          Widget cancelButton = TextButton(
            child: Text("No"),
            onPressed: () {
              setState(() {
                isAccepted = false;
              });

              Navigator.pop(context);
            },
          );
          Widget continueButton = TextButton(
            child: Text("Yes"),
            onPressed: () {

              setState(() {
                isAccepted = true;
                addToFirestoreArray(current_uid,id);
              });

              Navigator.pop(context);
            },
          );

          // Construit la boîte de dialogue
          AlertDialog alert = AlertDialog(
            content: Text("Are you sure to accept the partner ?"),
            actions: [
              cancelButton,
              continueButton,
            ],
          );

          // Affiche la boîte de dialogue
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            },
          );
        }
        void showAlertDialog2(
            BuildContext context) {
          // Définit les boutons de la boîte de dialogue
          Widget cancelButton = TextButton(
            child: Text("No"),
            onPressed: () {
              setState(() {
                isAccepted = true;

              });

              Navigator.pop(context);
            },
          );
          Widget continueButton = TextButton(
            child: Text("Yes"),
            onPressed: () {

              setState(() {
                isAccepted = false;
                removeAtFirestoreArray(current_uid,id);
              });

              Navigator.pop(context);
            },
          );

          // Construit la boîte de dialogue
          AlertDialog alert = AlertDialog(
            content: Text("Are you sure to reject the partner ?"),
            actions: [
              cancelButton,
              continueButton,
            ],
          );

          // Affiche la boîte de dialogue
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            },
          );
        }
        if(isAccepted==false)
          showAlertDialog1(context);
        else
          showAlertDialog2(context);
      },
      icon: AnimatedSwitcher(
        duration: Duration(milliseconds: 1),
        child: Icon(
          isAccepted ? Icons.check : Icons.access_time,
          color: Colors.white,
          key: ValueKey<bool>(isAccepted),
        ),
      ),
      label: Text(
        isAccepted ? 'Accepted' : 'Waiting',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        primary: isAccepted ? Colors.green : Colors.yellow[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 2.0,
      ),
    );
  }
  void addToFirestoreArray(String documentUid, String? idToAdd) {
    CollectionReference partnerDemandsCollection =
    FirebaseFirestore.instance.collection('partnerDemands');

    partnerDemandsCollection
        .doc(documentUid)
        .set({
      'acceptedPartners': FieldValue.arrayUnion([idToAdd]),
    }, SetOptions(merge: true))
        .then((_) {
      CollectionReference partnerDemandsCollection =
      FirebaseFirestore.instance.collection('users');

      partnerDemandsCollection
          .doc(idToAdd)
          .set({
        'messages': FieldValue.arrayUnion(["Your request to participate in the sport has been accepted."]),
      }, SetOptions(merge: true))
          .then((_) {
        print('Mise à jour du tableau réussie !');
      })
          .catchError((error) {
        print('Erreur lors de la mise à jour du tableau : $error');
      });
    })
        .catchError((error) {
      print('Erreur lors de la mise à jour du tableau : $error');
    });
  }
  void removeAtFirestoreArray(String documentUid, String? idToRemove) {
    final docRef = FirebaseFirestore.instance.collection('partnerDemands').doc(documentUid);
    docRef.update({
      'acceptedPartners': FieldValue.arrayRemove([idToRemove]),
    }).then((value) {
      // La suppression a réussi
    }).catchError((error) {
      // Une erreur s'est produite lors de la suppression
    });











  }
}