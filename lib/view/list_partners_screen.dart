import 'dart:async';

import 'package:app_sportner2/components/accepbutton.dart';
import 'package:app_sportner2/screens/rating_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/user_model.dart';
import '../utils/global_colors.dart';
final database2 = FirebaseFirestore.instance;
List<DocumentSnapshot> ?documents_2;
List<String> principale_liste=[];
List<String> accepted_partners=[];
String sport="";
String day="";
String start="";
String end="";
String address="";
String? own_uid="";
DateTime start1= DateTime(2023, 5, 23, 13, 0);
DateTime end1 = DateTime(2023, 5, 23, 14, 0);

class ListPartners extends StatefulWidget {
  const ListPartners({Key? key}) : super(key: key);

  @override
  _ListPartnersState createState() => _ListPartnersState();
}

class _ListPartnersState extends State<ListPartners> {
  User? user = FirebaseAuth.instance.currentUser;

  Future<QuerySnapshot> years2 = database2.collection('users').get();
  UserModel loggedInuser = UserModel();
  @override
  void dispose() {
    super.dispose();
  }
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromFirestore();
       FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value){
      loggedInuser = UserModel.fromMap(value.data());
      setState(() {

      });

    });

  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Responses from potential partners"),
        backgroundColor: GlobalColors.mainColor,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          own_uid==loggedInuser.uid
          ?Expanded(
              child :FutureBuilder<QuerySnapshot>(
                  future: years2,
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      documents_2 = snapshot.data!.docs;

                      return Container(
                        width: double.infinity,

                        child: ListView(
                          children: documents_2
                              !.map((doc) =>principale_liste.contains(doc.get('uid')) && doc.get('uid')!=own_uid ? Card(
                            child: ListTile(

                              title: Column(
                                children: [
                                  Text("${doc.get('firstName')} ${doc.get('lastname')}"),
                                  Text('${calculateAge(doc.get('dateBirth'))} years',style: TextStyle(fontSize: 16,fontStyle: FontStyle.italic),),
                                  SizedBox(height: 5,),
                                  double.parse(doc.get('stars').toString())==0 ||    double.parse(doc.get('stars').toString())<0.5?Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.star_border,size: 20,color: Colors.grey[300],),
                                      Icon(Icons.star_border,size: 20,color: Colors.grey[300],),
                                      Icon(Icons.star_border,size: 20,color: Colors.grey[300],),
                                      Icon(Icons.star_border,size: 20,color: Colors.grey[300],),
                                      Icon(Icons.star_border,size: 20,color: Colors.grey[300],),



                                    ],
                                  ) :
                                  double.parse(doc.get('stars').toString())>=0.5 && double.parse(doc.get('stars').toString())<1  ?Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.star_half,size: 20,color: Colors.orange,),
                                      Icon(Icons.star_border,size: 20,color: Colors.grey[300],),
                                      Icon(Icons.star_border,size: 20,color: Colors.grey[300],),
                                      Icon(Icons.star_border,size: 20,color: Colors.grey[300],),
                                      Icon(Icons.star_border,size: 20,color: Colors.grey[300],),
                                    ],
                                  ) :  double.parse(doc.get('stars').toString())>=1   && double.parse(doc.get('stars').toString())<1.5  ?Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.star_purple500_outlined,size: 20,color: Colors.orange),
                                      Icon(Icons.star_border,size: 20,color: Colors.grey[300],),
                                      Icon(Icons.star_border,size: 20,color: Colors.grey[300],),
                                      Icon(Icons.star_border,size: 20,color: Colors.grey[300],),
                                      Icon(Icons.star_border,size: 20,color: Colors.grey[300],),


                                    ],
                                  ): double.parse(doc.get('stars').toString())>=1.5 && double.parse(doc.get('stars').toString())<2  ?Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.star_purple500_outlined,size: 20,color: Colors.orange,),
                                      Icon(Icons.star_half,size: 20,color: Colors.orange,),
                                      Icon(Icons.star_border,size: 20,color: Colors.grey[300],),
                                      Icon(Icons.star_border,size: 20,color: Colors.grey[300],),
                                      Icon(Icons.star_border,size: 20,color: Colors.grey[300],),


                                    ],
                                  ): double.parse(doc.get('stars').toString())>=2 && double.parse(doc.get('stars').toString())<2.5  ?Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.star_purple500_outlined,size: 20,color:Colors.orange,),
                                      Icon(Icons.star_purple500_outlined,size: 20,color: Colors.orange,),
                                      Icon(Icons.star_border,size: 20,color: Colors.grey[300],),
                                      Icon(Icons.star_border,size: 20,color: Colors.grey[300],),
                                      Icon(Icons.star_border,size: 20,color: Colors.grey[300],),
                                    ],
                                  ): double.parse(doc.get('stars').toString())>=2.5 && double.parse(doc.get('stars').toString())<3  ?Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.star_purple500_outlined,size: 20,color: Colors.orange,),
                                      Icon(Icons.star_purple500_outlined,size: 20,color: Colors.orange,),
                                      Icon(Icons.star_half,size: 20,color: Colors.orange,),
                                      Icon(Icons.star_border,size: 20,color: Colors.grey[300],),
                                      Icon(Icons.star_border,size: 20,color: Colors.grey[300],),
                                    ],
                                  ): double.parse(doc.get('stars').toString())>=3 && double.parse(doc.get('stars').toString())<3.5  ?Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.star_purple500_outlined,size: 20,color: Colors.orange,),
                                      Icon(Icons.star_purple500_outlined,size: 20,color: Colors.orange,),
                                      Icon(Icons.star_purple500_outlined,size: 20,color: Colors.orange,),
                                      Icon(Icons.star_border,size: 20,color: Colors.grey[300],),
                                      Icon(Icons.star_border,size: 20,color: Colors.grey[300],),
                                    ],
                                  ): double.parse(doc.get('stars').toString())>=3.5 && double.parse(doc.get('stars').toString())<4  ?Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.star_purple500_outlined,size: 20,color: Colors.orange,),
                                      Icon(Icons.star_purple500_outlined,size: 20,color: Colors.orange,),
                                      Icon(Icons.star_purple500_outlined,size: 20,color: Colors.orange,),
                                      Icon(Icons.star_half,size: 20,color: Colors.orange,),
                                      Icon(Icons.star_border,size: 20,color: Colors.grey[300],),
                                    ],
                                  ): double.parse(doc.get('stars').toString())>=4 && double.parse(doc.get('stars').toString())<4.5  ?Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.star_purple500_outlined,size: 20,color: Colors.orange,),
                                      Icon(Icons.star_purple500_outlined,size: 20,color: Colors.orange,),
                                      Icon(Icons.star_purple500_outlined,size: 20,color: Colors.orange,),
                                      Icon(Icons.star_purple500_outlined,size: 20,color: Colors.orange,),
                                      Icon(Icons.star_border,size: 20,color: Colors.grey[300],),
                                    ],
                                  ): double.parse(doc.get('stars').toString())>=4.5 && double.parse(doc.get('stars').toString())<5  ?Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.star_purple500_outlined,size: 20,color: Colors.orange,),
                                      Icon(Icons.star_purple500_outlined,size: 20,color: Colors.orange,),
                                      Icon(Icons.star_purple500_outlined,size: 20,color: Colors.orange,),
                                      Icon(Icons.star_purple500_outlined,size: 20,color: Colors.orange,),
                                      Icon(Icons.star_half,size: 20,color: Colors.orange,),
                                    ],
                                  ):Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:  [
                                      Icon(Icons.star_purple500_outlined,size: 20,color: Colors.orange,),
                                      Icon(Icons.star_purple500_outlined,size: 20,color: Colors.orange,),
                                      Icon(Icons.star_purple500_outlined,size: 20,color: Colors.orange,),
                                      Icon(Icons.star_purple500_outlined,size: 20,color: Colors.orange,),
                                      Icon(Icons.star_purple500_outlined,size: 20,color: Colors.orange,),
                                    ],
                                  ),
                                  accepted_partners.contains( doc.get('uid'))?TextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Confirmation"),
                                            content: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text("Are you sure you want to rate this user?"),
                                                Text(
                                                  "Note: Rating this user will remove them from your partner list.",
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                child: Text("Cancel"),
                                                onPressed: () {
                                                  Navigator.of(context).pop(); // Close the dialog
                                                },
                                              ),
                                              TextButton(
                                                child: Text("Rate"),
                                                onPressed: () {
                                                  Navigator.of(context).pop(); // Close the dialog
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        content: RatingWidget(id: doc.get('uid'),array: principale_liste,current_uid: loggedInuser.uid,),
                                                      );

                                                    },
                                                  );
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text("Rate your partner"),
                                  ):Text(""),
                                  // Text(
                                  //   'Time remaining to rate:',
                                  //   style: TextStyle(fontSize: 14.0),
                                  // ),
                                  // Text(
                                  //   '${_duration.inHours}:${_duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(_duration.inSeconds.remainder(60)).toString().padLeft(2, '0')}',
                                  //   style: TextStyle(fontSize: 16.0),
                                  // ),
                                  // SizedBox(height: 40.0),
                                  // ElevatedButton(
                                  //   onPressed: _timer.isActive ? stopTimer : startTimer,
                                  //   child: Text(_timer.isActive ? 'Arrêter' : 'Démarrer'),
                                  // ),



                                ],
                              ),
                               trailing: SizedBox(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AcceptButton(current_uid: loggedInuser.uid, id: doc.get('uid'),array: accepted_partners,),
                                   //  // IconButton(
                                   //  //   icon: Icon(Icons.close,color: Colors.red,),
                                   //  //   onPressed: () {
                                   //  //     ScaffoldMessenger.of(context).showSnackBar(
                                   //  //         SnackBar(content: Text('Rejected ${doc.get('firstName')}')));
                                   //  //   },
                                   //  // ),
                                    TextButton(
                                      onPressed: () {
                                        String phoneNumber = doc.get('numberPhone'); // Le numéro de téléphone de la personne à contacter
                                        String message = "Hello  ${doc.get('firstName')},\n\nThanks for agreeing to be my sports partner! I just wanted to confirm the details for our practice session. We'll be practicing ${sport} on ${start} to ${end} at ${address}.\n\nPlease let me know if you have any questions or concerns about these details. Otherwise, I look forward to seeing you there!\n\nBest regards,\n${loggedInuser.firstname} ${loggedInuser.lastName}";

                                        // Le message que vous voulez envoyer
                                        String url = 'sms:$phoneNumber?body=$message';
                                        launch(url);
                                        // ScaffoldMessenger.of(context).showSnackBar(
                                        //     SnackBar(content: Text('Contacted ${doc.get('firstName')}')));
                                      },
                                      child: Text('Contact',style: TextStyle(color: Colors.lightBlue),),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ) : Center())
                              .toList(),
                        ),
                      )
                      ;
                    }
                    else if (snapshot.hasError) {
                      return Text('Error!');
                    } else {
                      return Container();
                    }

                  }



              )
          ):Center(),
        ],
      ),
    );
  }
  Future<void> getDataFromFirestore() async {
    DocumentReference<Map<String, dynamic>> docRef = FirebaseFirestore.instance.collection('partnerDemands').doc(user!.uid);

    DocumentSnapshot<Map<String, dynamic>> docSnapshot = await docRef.get();




    // Parcourir les documents et accéder aux champs spécifiques
    if (docSnapshot.exists) {
      // Récupérer le document contenant le champ à trier



      Map<String, dynamic>? data = docSnapshot.data();
      if (data != null) {
        own_uid = data['uid'];
        final partners = data['partners'];
        sport = data['sport'];
        address=data['address'];
        final array_accepted_partners= data['acceptedPartners']!;
        Timestamp timestamp = data['start'];
        DateTime date_start = timestamp.toDate();
        start1= date_start;
        Timestamp timestamp2 = data['end'];
        DateTime date_end = timestamp2.toDate();
        end1 = date_end;
        start='${DateFormat('EEEE, MMMM d yyyy HH:mm').format(date_start)}';
        end='${DateFormat('EEEE, MMMM d yyyy HH:mm').format(date_end)}';
        if (partners != null) {
          DocumentSnapshot documentSnapshot = await docRef.get();
          List<String> listeATrier = List<String>.from(documentSnapshot.get("partners"));
          principale_liste=listeATrier;

          if(array_accepted_partners!=null) {
            accepted_partners =
            List<String>.from(documentSnapshot.get("acceptedPartners"));
          }
          List<DocumentSnapshot> userDocuments = await FirebaseFirestore.instance.collection("users")
              .where(FieldPath.documentId, whereIn: listeATrier)
              .get()
              .then((querySnapshot) => querySnapshot.docs);

          List<UserModel> userList = userDocuments.map((doc) => UserModel.fromMap(doc.data())).toList();

          userList.sort((a, b) {
            DateTime dateA = DateFormat('yyyy-MM-dd').parse(a.dateBirth!);
            DateTime dateB = DateFormat('yyyy-MM-dd').parse(b.dateBirth!);
            return dateA.compareTo(dateB);
          });

          List<String?> nouvelleListe = userList.map((user) => user.uid).toList();
          await docRef.update({"partners": nouvelleListe});

        }


      }
      // ...
    } else {
      print('Le document n\'existe pas.');
    }
  }
  int calculateAge(String? dateOfBirth) {
    DateTime now = DateTime.now();
    int age=32;

    if(dateOfBirth!=null) {
      DateTime birthDate = DateTime.parse(dateOfBirth);

       age = now.year - birthDate.year;

      if (now.month < birthDate.month ||
          (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }
    }
    return age;
  }
}
