import 'dart:typed_data';
import 'package:app_sportner2/screens/login_screen.dart';
import 'package:app_sportner2/utils/global_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../model/storage_methods.dart';
import '../model/user_model.dart';
class ProfilePageUser extends StatefulWidget {
  const ProfilePageUser({Key? key}) : super(key: key);

  @override
  _ProfilePageUserState createState() => _ProfilePageUserState();
}

class _ProfilePageUserState extends State<ProfilePageUser> {
  final _formKey = GlobalKey<FormState>();
  Uint8List _file_image=Uint8List(1024) ;
  final firstNameEditingController = new TextEditingController();
  final lastNameEditingController = new TextEditingController();
  final dateBirthEditingController =  new TextEditingController();
  final genderEditingController =  new TextEditingController();
  final yearOfAlyahEditingController =  new TextEditingController();
  final statusEditingController =  new TextEditingController();
  final idEditingController =  new TextEditingController();
  bool change = false;

  final phoneNumberEditingController = new TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInuser = UserModel();
  _selectImage(BuildContext context) async {
    return showDialog(context: context, builder: (context){
      return SimpleDialog(
        title: const Text('Photo de profil'),
        children: [
          SimpleDialogOption(
            padding : const EdgeInsets.all(20),
            child : const Text('Prendre une photo'),
            onPressed:() async {
              Navigator.of(context).pop();
              Uint8List file = await pickImage(ImageSource.camera,);
              setState(() {

                _file_image =file;
                change =true;
              });
            },
          ),
          SimpleDialogOption(
            padding : const EdgeInsets.all(20),
            child : const Text('Choisir depuis la gallerie'),
            onPressed:() async {
              Navigator.of(context).pop();
              Uint8List file = await pickImage(ImageSource.gallery,);
              setState(() {
                _file_image =file;
                change =true;
              });
            },
          ),
          SimpleDialogOption(
            padding : const EdgeInsets.all(20),
            child : const Text('Cancel'),
            onPressed:(){
              Navigator.of(context).pop();

            },
          )

        ],
      );
    });
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    print('user!.uid'+user!.uid);
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
    final List<String> genderItems = [
      'Male',
      'Female',
    ];

    final firstNameField = TextFormField(
        autofocus: false,
        controller: firstNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value){
          if(value!.isEmpty){

          }
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },

        cursorColor: GlobalColors.mainColor,

        textInputAction: TextInputAction.next,
        decoration : InputDecoration(

            prefixIcon: Icon(Icons.account_circle,color: GlobalColors.mainColor,),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: loggedInuser.firstname!=null?'${loggedInuser.firstname}':"FirstName",
          suffixText: loggedInuser.lastName!=null?"(FirstName)":"",
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: GlobalColors.mainColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                  color: GlobalColors.mainColor),
            ),


        )
    );
    final lastNameField = TextFormField(
        autofocus: false,
        controller: lastNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value){
          if(value!.isEmpty){

          }
        },
        onSaved: (value) {
          lastNameEditingController.text = value!;
        },

        textInputAction: TextInputAction.next,
        decoration : InputDecoration(
          hintText: loggedInuser.lastName!=null?'${loggedInuser.lastName}':"Name",
          suffixText: loggedInuser.lastName!=null?"(Name)":"",
            prefixIcon: Icon(Icons.account_circle,color: GlobalColors.mainColor,),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: GlobalColors.mainColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
                color: GlobalColors.mainColor),
          ),

        )
    );
    final genderField = DropdownButtonFormField2(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.people,color: GlobalColors.mainColor,size: 20,),
        //Add isDense true and zero Padding.
        //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
        isDense: true,
        contentPadding: EdgeInsets.zero,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: GlobalColors.mainColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
              color: GlobalColors.mainColor),
        ),
        //Add more decoration as you want here
        //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
      ),
      isExpanded: true,
      hint: loggedInuser.gender!=null ?Text(
        '${loggedInuser.gender}',

      ): Text(
        'Gender',
      ),

      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black45,
      ),
      iconSize: 30,
      buttonHeight: 60,
      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
      dropdownDecoration: BoxDecoration(
      ),
      items: genderItems
          .map((item) =>
          DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Choose your gender';
        }
      },
      onChanged: (value) {
        genderEditingController.text = value!.toString();
        //Do something when changing the item if you want.
      },
      onSaved: (value) {
        genderEditingController.text = value!.toString();
      },
    );

    final dateBirthField = DateTimePicker(

      decoration: InputDecoration(
        suffixText: loggedInuser.dateBirth!=null ?"(Date of birth)":"",
        hintText: loggedInuser.dateBirth!=null ?'${loggedInuser.dateBirth}':"Date of birth",
        prefixIcon: Icon(Icons.date_range,color: GlobalColors.mainColor,),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: GlobalColors.mainColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
              color: GlobalColors.mainColor),
        ),
      ),

      initialValue: '',
      firstDate: DateTime(1970),
      lastDate: DateTime(2100),

      validator: (value){

        if(value!.isEmpty){

        }
      },
      onChanged: (value) {

        dateBirthEditingController.text = value.toString();
      },
      onSaved: (value) {
        dateBirthEditingController.text = value!.toString();
      },
    );




    final numberPhoneField = TextFormField(
        autofocus: false,
        controller: phoneNumberEditingController,
        keyboardType: TextInputType.phone,
        validator: (value){
          if(value!.isEmpty){

          }
        },

        onSaved: (value) {
          phoneNumberEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration : InputDecoration(
            suffixText: loggedInuser.numberPhone!=null ?"Number Phone":"",
            prefixIcon: Icon(Icons.phone,color: GlobalColors.mainColor,),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: loggedInuser.numberPhone!=null ?'${loggedInuser.numberPhone}' : "Number Phone",
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: GlobalColors.mainColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
                color: GlobalColors.mainColor),
          ),

        )


    );
    final signModifs = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: GlobalColors.mainColor,
      child :MaterialButton(
        padding : EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed:(){
          changeUser();
          Fluttertoast.showToast(msg: "The changes have been successfully saved.");


        },
        child : Text("Save the changes", textAlign: TextAlign.center,style:TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold)),
      ),
    );



    return Scaffold(
      appBar: AppBar(

        title: Text('Edit Profile'),
        backgroundColor: GlobalColors.mainColor,
        automaticallyImplyLeading: false,

        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              logout(context);
              // Ajoutez ici le code pour naviguer vers l'écran de connexion ou toute autre action que vous souhaitez effectuer après la déconnexion.
            },
          ),
        ],
      ),
      body: Container(
          padding: EdgeInsets.only(left: 16,top:20,right:16),
          child:ListView(
            children: [
              Center(
                child : Stack(
                  children: [
                    Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 4,color:Colors.white),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 5,
                                color: Colors.black,
                                offset: Offset(0,10)
                            )
                          ],
                            image: change ==false ? DecorationImage(

                                fit:BoxFit.cover,
                                image: NetworkImage(
                                  "${loggedInuser.file.toString()}",
                                )
                            ) : DecorationImage(
                              fit: BoxFit.cover, image: MemoryImage(_file_image),
                        ),
                    ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color: Colors.white,
                                )
                            ),
                            height: 40,
                            width: 40,
                            child: FloatingActionButton(
                             backgroundColor: GlobalColors.mainColor,
                              child : Icon(Icons.add_a_photo,color:Colors.white,),
                              onPressed:(){  _selectImage(context); } ,
                            ))),

                  ],
                ),

              ),

              Padding(
                padding: EdgeInsets.all(15.0),
                child :Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      loggedInuser.stars
                          ==0?Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star_border,size: 40,color: Colors.grey[300],),
                          Icon(Icons.star_border,size: 40,color: Colors.grey[300],),
                          Icon(Icons.star_border,size: 40,color: Colors.grey[300],),
                          Icon(Icons.star_border,size: 40,color: Colors.grey[300],),
                          Icon(Icons.star_border,size: 40,color: Colors.grey[300],),
                          loggedInuser.numberRatings==0 ?Text("(0)",style: TextStyle(fontSize: 18,color: Colors.grey[300],),):Text("(${loggedInuser.numberRatings})",style: TextStyle(fontSize: 18),),



                        ],
                      ) :
                        loggedInuser.stars.toDouble()>=0.5 &&loggedInuser.stars.toDouble()<1  ?Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star_half,size: 40,color: Colors.orange,),
                          Icon(Icons.star_border,size: 40,color: Colors.grey[300],),
                          Icon(Icons.star_border,size: 40,color: Colors.grey[300],),
                          Icon(Icons.star_border,size: 40,color: Colors.grey[300],),
                          Icon(Icons.star_border,size: 40,color: Colors.grey[300],),
                          loggedInuser.numberRatings==0 ?Text("(0)",style: TextStyle(fontSize: 18,color: Colors.grey[300],),):Text("(${loggedInuser.numberRatings})",style: TextStyle(fontSize: 18),),
                        ],
                      ) : loggedInuser.stars.toDouble()>=1.0   &&loggedInuser.stars.toDouble()<1.5  ?Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star_purple500_outlined,size: 40,color: Colors.orange),
                          Icon(Icons.star_border,size: 40,color: Colors.grey[300],),
                          Icon(Icons.star_border,size: 40,color: Colors.grey[300],),
                          Icon(Icons.star_border,size: 40,color: Colors.grey[300],),
                          Icon(Icons.star_border,size: 40,color: Colors.grey[300],),
                          loggedInuser.numberRatings==0 ?Text("(0)",style: TextStyle(fontSize: 18,color: Colors.grey[300],),):Text("(${loggedInuser.numberRatings})",style: TextStyle(fontSize: 18),),


                        ],
                      ):loggedInuser.stars.toDouble()>=1.5 &&loggedInuser.stars.toDouble()<2  ?Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star_purple500_outlined,size: 40,color: Colors.orange,),
                          Icon(Icons.star_half,size: 40,color: Colors.orange,),
                          Icon(Icons.star_border,size: 40,color: Colors.grey[300],),
                          Icon(Icons.star_border,size: 40,color: Colors.grey[300],),
                          Icon(Icons.star_border,size: 40,color: Colors.grey[300],),
                          loggedInuser.numberRatings==0 ?Text("(0)",style: TextStyle(fontSize: 18,color: Colors.grey[300],),):Text("(${loggedInuser.numberRatings})",style: TextStyle(fontSize: 18),),


                        ],
                      ):loggedInuser.stars.toDouble() >=2.0 &&loggedInuser.stars.toDouble() <2.5  ?Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star_purple500_outlined,size: 40,color:Colors.orange,),
                            Icon(Icons.star_purple500_outlined,size: 40,color: Colors.orange,),
                            Icon(Icons.star_border,size: 40,color: Colors.grey[300],),
                            Icon(Icons.star_border,size: 40,color: Colors.grey[300],),
                            Icon(Icons.star_border,size: 40,color: Colors.grey[300],),
                            loggedInuser.numberRatings==0 ?Text("(0)",style: TextStyle(fontSize: 18,color: Colors.grey[300],),):Text("(${loggedInuser.numberRatings})",style: TextStyle(fontSize: 18),),
                          ],
                        ):loggedInuser.stars.toDouble() >=2.5 &&loggedInuser.stars.toDouble() <3  ?Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star_purple500_outlined,size: 40,color: Colors.orange,),
                            Icon(Icons.star_purple500_outlined,size: 40,color: Colors.orange,),
                            Icon(Icons.star_half,size: 40,color: Colors.orange,),
                            Icon(Icons.star_border,size: 40,color: Colors.grey[300],),
                            Icon(Icons.star_border,size: 40,color: Colors.grey[300],),
                            loggedInuser.numberRatings==0 ?Text("(0)",style: TextStyle(fontSize: 18,color: Colors.grey[300],),):Text("(${loggedInuser.numberRatings})",style: TextStyle(fontSize: 18),),
                          ],
                        ):loggedInuser.stars.toDouble()>=3 &&loggedInuser.stars.toDouble()<3.5  ?Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star_purple500_outlined,size: 40,color: Colors.orange,),
                            Icon(Icons.star_purple500_outlined,size: 40,color: Colors.orange,),
                            Icon(Icons.star_purple500_outlined,size: 40,color: Colors.orange,),
                            Icon(Icons.star_border,size: 40,color: Colors.grey[300],),
                            Icon(Icons.star_border,size: 40,color: Colors.grey[300],),
                            loggedInuser.numberRatings==0 ?Text("(0)",style: TextStyle(fontSize: 18,color: Colors.grey[300],),):Text("(${loggedInuser.numberRatings})",style: TextStyle(fontSize: 18),),
                          ],
                        ):loggedInuser.stars.toDouble()>=3.5 &&loggedInuser.stars.toDouble()<4  ?Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star_purple500_outlined,size: 40,color: Colors.orange,),
                            Icon(Icons.star_purple500_outlined,size: 40,color: Colors.orange,),
                            Icon(Icons.star_purple500_outlined,size: 40,color: Colors.orange,),
                            Icon(Icons.star_half,size: 40,color: Colors.orange,),
                            Icon(Icons.star_border,size: 40,color: Colors.grey[300],),
                            loggedInuser.numberRatings==0 ?Text("(0)",style: TextStyle(fontSize: 18,color: Colors.grey[300],),):Text("(${loggedInuser.numberRatings})",style: TextStyle(fontSize: 18),),
                          ],
                        ):loggedInuser.stars.toDouble()>=4 &&loggedInuser.stars.toDouble()<4.5  ?Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star_purple500_outlined,size: 40,color: Colors.orange,),
                            Icon(Icons.star_purple500_outlined,size: 40,color: Colors.orange,),
                            Icon(Icons.star_purple500_outlined,size: 40,color: Colors.orange,),
                            Icon(Icons.star_purple500_outlined,size: 40,color: Colors.orange,),
                            Icon(Icons.star_border,size: 40,color: Colors.grey[300],),
                            loggedInuser.numberRatings==0 ?Text("(0)",style: TextStyle(fontSize: 18,color: Colors.grey[300],),):Text("(${loggedInuser.numberRatings})",style: TextStyle(fontSize: 18),),
                          ],
                        ):loggedInuser.stars.toDouble()>=4.5 &&loggedInuser.stars.toDouble()<5  ?Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star_purple500_outlined,size: 40,color: Colors.orange,),
                            Icon(Icons.star_purple500_outlined,size: 40,color: Colors.orange,),
                            Icon(Icons.star_purple500_outlined,size: 40,color: Colors.orange,),
                            Icon(Icons.star_purple500_outlined,size: 40,color: Colors.orange,),
                            Icon(Icons.star_half,size: 40,color: Colors.orange,),
                            loggedInuser.numberRatings==0 ?Text("(0)",style: TextStyle(fontSize: 18,color: Colors.grey[300],),):Text("(${loggedInuser.numberRatings})",style: TextStyle(fontSize: 18),),
                          ],
                        ):Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          Icon(Icons.star_purple500_outlined,size: 40,color: Colors.orange,),
                          Icon(Icons.star_purple500_outlined,size: 40,color: Colors.orange,),
                          Icon(Icons.star_purple500_outlined,size: 40,color: Colors.orange,),
                          Icon(Icons.star_purple500_outlined,size: 40,color: Colors.orange,),
                          Icon(Icons.star_purple500_outlined,size: 40,color: Colors.orange,),
                          loggedInuser.numberRatings==0 ?Text("(0)",style: TextStyle(fontSize: 18,color: Colors.grey[300],),):Text("(${loggedInuser.numberRatings})",style: TextStyle(fontSize: 18),),
                        ],
                      ),
                      SizedBox(height: 10,),
                      // Text("Participant rating :",style: TextStyle(fontWeight: FontWeight.bold),),
                      // SizedBox(height: 10,),
                      // loggedInuser.fiability_points.toDouble()==0?Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Icon(Icons.circle,size: 40,color: Colors.grey[300],),
                      //     Icon(Icons.circle,size: 40,color: Colors.grey[300],),
                      //     Icon(Icons.circle,size: 40,color: Colors.grey[300],),
                      //     Icon(Icons.circle,size: 40,color: Colors.grey[300],),
                      //     Icon(Icons.circle,size: 40,color: Colors.grey[300],),
                      //     loggedInuser.numberRatingsFiability==0 ?Text("(0)",style: TextStyle(fontSize: 18,color: Colors.grey[300],),):Text("(${loggedInuser.numberRatings})",style: TextStyle(fontSize: 18),),
                      //
                      //
                      //   ],
                      // ) :
                      // loggedInuser.fiability_points.toDouble()>=0.5 &&loggedInuser.stars.toDouble()<1.5  ?Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Icon(Icons.circle,size: 40,color: Colors.tealAccent,),
                      //     Icon(Icons.circle,size: 40,),
                      //     Icon(Icons.circle,size: 40,),
                      //     Icon(Icons.circle,size: 40,),
                      //     Icon(Icons.circle,size: 40,),
                      //     loggedInuser.numberRatingsFiability==0 ?Text("(0)",style: TextStyle(fontSize: 18,color: Colors.grey[300],),):Text("(${loggedInuser.numberRatings})",style: TextStyle(fontSize: 18),),
                      //   ],
                      // ) :loggedInuser.fiability_points.toDouble()>=1.5 &&loggedInuser.stars.toDouble()<2.5  ?Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Icon(Icons.circle,size: 40,color: Colors.tealAccent,),
                      //     Icon(Icons.circle,size: 40,color: Colors.tealAccent,),
                      //     Icon(Icons.circle,size: 40,),
                      //     Icon(Icons.circle,size: 40,),
                      //     Icon(Icons.circle,size: 40,),
                      //     loggedInuser.numberRatingsFiability==0 ?Text("(0)",style: TextStyle(fontSize: 18,color: Colors.grey[300],),):Text("(${loggedInuser.numberRatings})",style: TextStyle(fontSize: 18),),
                      //
                      //
                      //   ],
                      // ):loggedInuser.fiability_points.toDouble()>=2.5 &&loggedInuser.stars.toDouble()<3.5  ?Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Icon(Icons.circle,size: 40,color: Colors.tealAccent,),
                      //     Icon(Icons.circle,size: 40,color: Colors.tealAccent,),
                      //     Icon(Icons.circle,size: 40,color: Colors.tealAccent,),
                      //     Icon(Icons.circle,size: 40,),
                      //     Icon(Icons.circle,size: 40,),
                      //     loggedInuser.numberRatingsFiability==0 ?Text("(0)",style: TextStyle(fontSize: 18,color: Colors.grey[300],),):Text("(${loggedInuser.numberRatings})",style: TextStyle(fontSize: 18),),
                      //   ],
                      // ):loggedInuser.fiability_points.toDouble()>=3.5 &&loggedInuser.stars.toDouble()<4.5  ?Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Icon(Icons.circle,size: 40,color: Colors.tealAccent,),
                      //     Icon(Icons.circle,size: 40,color: Colors.tealAccent,),
                      //     Icon(Icons.circle,size: 40,color: Colors.tealAccent,),
                      //     Icon(Icons.circle,size: 40,color: Colors.tealAccent,),
                      //     Icon(Icons.circle,size: 40,),
                      //     loggedInuser.numberRatingsFiability==0 ?Text("(0)",style: TextStyle(fontSize: 18,color: Colors.grey[300],),):Text("(${loggedInuser.numberRatings})",style: TextStyle(fontSize: 18),),
                      //   ],
                      // ):Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children:  [
                      //     Icon(Icons.circle,size: 40,color: Colors.tealAccent,),
                      //     Icon(Icons.circle,size: 40,color: Colors.tealAccent,),
                      //     Icon(Icons.circle,size: 40,color: Colors.tealAccent,),
                      //     Icon(Icons.circle,size: 40,color: Colors.tealAccent,),
                      //     Icon(Icons.circle,size: 40,color: Colors.tealAccent,),
                      //     loggedInuser.numberRatingsFiability==0 ?Text("(0)",style: TextStyle(fontSize: 18,color: Colors.grey[300],),):Text("(${loggedInuser.numberRatings})",style: TextStyle(fontSize: 18),),
                      //   ],
                      // ),

                      SizedBox(height: 20,),
                      firstNameField,
                      SizedBox(height: 20,),
                      lastNameField,
                      SizedBox(height: 20,),
                      genderField,
                      SizedBox(height: 20,),
                      dateBirthField,
                      SizedBox(height: 20,),
                      numberPhoneField,
                      SizedBox(height: 20,),
                      signModifs,

                    ],
                  ),
                ),
              )


            ],
          )
      ),

    );
  }
  pickImage(ImageSource source)async{
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source : source);
    if(_file != null){
      return await _file.readAsBytes();
    }
    print("No image selected");

  }

  void changeUser() async {

    var collection = FirebaseFirestore.instance.collection('users');

    if(change==true ) {
      String photoURL = await StorageMethods().uploadImageToStorage(
          'profilePics', _file_image, false);
      collection
          .doc(loggedInuser.uid)
          .update({'file': photoURL});
      change =false;
    }

    if(firstNameEditingController.text!='') {
      collection
          .doc(loggedInuser.uid)
          .update({'firstName': firstNameEditingController.text});
    }
    if(lastNameEditingController.text!='') {
      collection
          .doc(loggedInuser.uid)
          .update({'lastname': lastNameEditingController.text});
    }//
    if(genderEditingController.text!='') {
      collection
          .doc(loggedInuser.uid)
          .update({'gender': genderEditingController.text});
    }//
    if(dateBirthEditingController.text!='') {
      collection
          .doc(loggedInuser.uid)
          .update({'dateBirth': dateBirthEditingController.text});
    }//


    if(phoneNumberEditingController.text!='') {
      collection
          .doc(loggedInuser.uid)
          .update({'numberPhone': phoneNumberEditingController.text});
    }//
    if(statusEditingController.text!='') {
      collection
          .doc(loggedInuser.uid)
          .update({'status': statusEditingController.text});
    }//


  }
  Future<void> logout(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

}

