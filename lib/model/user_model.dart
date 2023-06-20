import 'package:cloud_firestore/cloud_firestore.dart';
 const firstValue =0;
class UserModel{
  String? uid;
  String? email;
  String? firstname;
  String? lastName;
  String? gender;
  String? dateBirth;
  String? connectWith;
  String? numberPhone;
  String? token_message;
  String? file;
  GeoPoint? currentPosition;
  double stars=0.0 ;
  List<dynamic>? ratings_stars;
  List<dynamic>?messages;
  int numberRatings =0;
  UserModel({this.uid,this.file,this.email,this.firstname,this.lastName,this.gender,this.dateBirth,this.numberPhone,this.connectWith,this.stars=0.0,this.numberRatings=0,this.currentPosition=const GeoPoint(31.77181625366211,35.18861389160156),this.ratings_stars,this.messages,this.token_message});
 //data frm server

  factory UserModel.fromMap(map){
    return UserModel(
      uid: map['uid'],
      file: map['file'],
      email: map['email'],
      firstname: map['firstName'],
      lastName: map['lastname'],
      gender: map['gender'],
      connectWith: map['connectWith'],
      dateBirth: map['dateBirth'],
      numberPhone:map['numberPhone'],
      stars: map['stars'].toDouble(),
      numberRatings:map['numberRatings'],
      currentPosition: map['currentPosition'],
      ratings_stars: map['ratings_stars'],
      messages: map['messages'],
      token_message:map['token_message'],
    );
  }

  //dendding data o our server
  Map<String,dynamic> toMap(){
    return{
      'uid' : uid,
      'file': file,
      'email' : email,
      'connectWith': connectWith,
      'firstName' : firstname,
      'lastname' : lastName,
      'gender' : gender,
      'dateBirth' : dateBirth,
      'numberPhone' : numberPhone,
      'stars':stars,
      'numberRatings':numberRatings,
      'currentPosition':currentPosition,
      'ratings_stars':ratings_stars,
      'messages':messages,
      'token_message':token_message,
    };
  }

  List<UserModel> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> map =
      snapshot.data() as Map<String, dynamic>;

      return UserModel(
        uid: map['uid'],
        file:map['file'],
        email:map['email'],
        firstname: map['firstName'],
        lastName: map['lastname'],
        gender: map['gender'],
        dateBirth: map['dateBirth'],
        numberPhone:map['numberPhone'],
        stars: map['stars'],
        numberRatings:map['numberRatings'],
        currentPosition: map['currentPosition'],
        ratings_stars: map['ratings_stars'],
        messages: map['messages'],
        token_message:map['token_message'],
      );
    }).toList();
  }
}
