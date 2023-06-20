import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class PartnerDemand{
  String? firstname;
  String? uid;
  String? numberPhone;
  String? sport;
  String? numPartner;
  String? gender;
  String? address;
  String? iconSport;
  String? tokenMessageOrganizator;
  GeoPoint? geoPoint;
  String? description;
  DateTime?  start, end;
  List<String>? partners;
  List<String>? acceptedPartners;
PartnerDemand({this.firstname,this.uid,this.numberPhone,this.gender,this.sport,this.geoPoint,this.numPartner,this.description,this.start,this.end,this.address,this.partners,this.iconSport,this.acceptedPartners,this.tokenMessageOrganizator});

  factory PartnerDemand.fromMap(map){
    return PartnerDemand(
      firstname: map['firstname'],
      uid: map['uid'],
      numberPhone:map['numberPhone'],
      gender: map['gender'],
      sport: map['sport'],
      geoPoint: map['geoPoint'],
      numPartner: map['numPartner'],
      description: map['description'],
      start: map['start'],
      end: map['end'],
      address: map['address'],
      partners: map['partners'],
      iconSport: map['iconSport'],
      acceptedPartners: map['acceptedPartners'],
      tokenMessageOrganizator:map['tokenMessageOrganizator'],

    );
  }

  Map<String,dynamic> toMap(){
    return{
      'firstname' : firstname,
      'uid' : uid,
      'numberPhone' : numberPhone,
      'gender' : gender,
      'sport' : sport,
      'geoPoint': geoPoint,
      'numPartner': numPartner,
      'description': description,
      'start':start,
      'end': end,
      'address':address,
      'partners': partners,
      'iconSport':iconSport,
      'acceptedPartners':acceptedPartners,
      'tokenMessageOrganizator':tokenMessageOrganizator,

    };
  }


}