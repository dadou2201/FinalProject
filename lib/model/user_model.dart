import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String? uid;
  String? email;
  String? firstname;
  String? lastName;
  String? gender;
  String? dateBirth;
  String? status;
  String? numberPhone;
  String? file;
  int check;
  UserModel({this.uid,this.file,this.email,this.firstname,this.lastName,this.gender,this.dateBirth,this.status,this.numberPhone,this.check=0});

  //data frm server

  factory UserModel.fromMap(map){
    return UserModel(
      uid: map['uid'],
      file: map['file'],
      email: map['email'],
      firstname: map['firstName'],
      lastName: map['lastname'],
      gender: map['gender'],
      dateBirth: map['dateBirth'],
      status: map['status'],
      numberPhone:map['numberPhone'],
    );
  }

  //dendding data o our server
  Map<String,dynamic> toMap(){
    return{
      'uid' : uid,
      'file': file,
      'email' : email,
      'firstName' : firstname,
      'lastname' : lastName,
      'gender' : gender,
      'dateBirth' : dateBirth,
      'status' : status,
      'numberPhone' : numberPhone,

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
        status: map['status'],
        numberPhone:map['numberPhone'],

      );
    }).toList();
  }
}




