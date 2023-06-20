import 'dart:convert';

import 'package:app_sportner2/screens/research.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/user_model.dart';
import '../utils/global_colors.dart';
import 'add_partner_demand.dart';
import 'edit_profile.dart';
import 'google_map.dart';
import 'list_partners_screen.dart';
import 'location_search_screen.dart';
import 'login_screen.dart';
import 'notifications_list.dart';
String token="";
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInuser = UserModel();
final navigationKey = GlobalKey<CurvedNavigationBarState>();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();



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

  int index =1;
  final screens =[
    ProfilePageUser(),
    MapSample(),
    AddPartnerDemand(),
    ListPartners(),
    NotificationsList(),
  ];
  @override
  Widget build(BuildContext context) {

    final items =<Widget>[
      Icon(Icons.person,size: 30,),
      Icon(Icons.home,size: 30,),
      Icon(Icons.add,size: 30,),
      Icon(Icons.people),
      Badge(child: Icon(Icons.notifications),),
    ];
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: CurvedNavigationBar(
        buttonBackgroundColor: GlobalColors.mainColor,
        key: navigationKey,
        backgroundColor: Colors.transparent,
        height: 60,
        items: items,
        index: index,
        onTap: (index)=> setState(() => this.index=index),

      ),
    );
  }

}
