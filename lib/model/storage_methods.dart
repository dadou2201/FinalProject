import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
class StorageMethods{
  final FirebaseStorage _storage =FirebaseStorage.instance;
  final FirebaseAuth _auth =FirebaseAuth.instance;
  //adding image to firebase storage
  Future<String> uploadImageToStorage(String childName,Uint8List file,bool isPost)async {
    Reference ref =_storage.ref().child(_auth.currentUser!.uid);
    if(isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap =await uploadTask;
    String downloadURL = await snap.ref.getDownloadURL();

    return downloadURL;
  }
  Future<String> uploadImageToStorage2(String childName,Uint8List file,bool isEvent)async {
    Reference ref =_storage.ref().child(_auth.currentUser!.uid);
    if(isEvent) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap =await uploadTask;
    String downloadURL = await snap.ref.getDownloadURL();

    return downloadURL;
  }
}