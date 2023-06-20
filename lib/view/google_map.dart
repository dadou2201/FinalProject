import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:api_fcm/api_fcm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../components/delete_document_widget.dart';
import '../components/location_list_tile.dart';
import '../components/network_utility.dart';
import '../main.dart';
import '../model/autocomplate_prediction.dart';
import '../model/place_auto_complate_response.dart';
import '../model/user_model.dart';
import '../utils/constants.dart';
import '../utils/global_colors.dart';
import 'horizontal_menu.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  _MapSampleState createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {

  CameraPosition? _currentCameraPosition ;
  CameraPosition cameraPosition=CameraPosition(
    target: LatLng(31.77181625366211,35.18861389160156),
    zoom: 5.4746,
  );
  List<AutocompletePrediction> placePredictions=[];

  GeoPoint? geoPoint;
  void placeAutocomplete(String query) async {
    Uri uri =Uri.https("maps.googleapis.com",
        'maps/api/place/autocomplete/json',{
          "input": query,
          "key": apiKey,
        });
    //Get request
    String? response = await NetworkUtility.fetchUrl(uri);
    if(response!=null){
      PlaceAutocompleteResponse result = PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if(result.predictions!=null){
        setState(() {
          placePredictions=result.predictions!;

        });
      }
    }
  }
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInuser = UserModel();
  TextEditingController _searchController =TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotifications();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message: ${message.notification?.title}');
    });
    getCurrentPosition();
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


  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  final List<String> statusSports = [
    'Aikido' ,
    "Badminton",
    "Baseball" ,
    "Basketball" ,
    "Beach volleyball",
    "BMX",
    "BMX racing",
    "Boxing",
    "Canoeing",
    "Cricket",
    "Diving",
    "Fencing",
    "Field hockey",
    "Football",
    "Golf",
    "Gymnastics",
    "Handball",
    "Hockey",
    "Judo",
    "Karate",
    "Kayaking",
    "Kickboxing",
    "Lacrosse",
    "Mountain biking",
    "Polo",
    "Rowing",
    "Running",
    "Rugby",
    "Skiing",
    "Snowboarding",
    "Soccer",
    "Surfing",
    "Synchronized swimming",
    "Swimming",
    "Table tennis",
    "Taekwondo",
    "Tennis",
    "Track and field",
    "Volleyball",
    "Water polo",
    "Weightlifting",
    "Windsurfing",
    "Wrestling",

  ];
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, don't continue
      // accessing the position and request users of the
      // app to enable the location services.
      Fluttertoast.showToast(msg: "Please enable location");
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, you could try requesting
        // permissions again next time (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines,
        // your app should show an explanatory UI now.
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the device's position.
    Position position = await Geolocator.getCurrentPosition();
    GeoPoint geoPoint = GeoPoint(position.latitude, position.longitude);
    var collection = FirebaseFirestore.instance.collection('users');
    collection
        .doc(loggedInuser.uid)
        .update({'currentPosition': geoPoint});
    return position;
  }

  Future<BitmapDescriptor> _getMarkerIcon(String iconSport) async {
    const ImageConfiguration config = ImageConfiguration(size: Size(0.5, 0.5));
    final BitmapDescriptor bitmapDescriptor = await BitmapDescriptor.fromAssetImage(config, iconSport);
    return bitmapDescriptor;
  }
Future<Uint8List> getBytesFromAssets(String path,int width)async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }
  String selectedSport = '';

  void onSportSelected(String sport) {
    setState(() {
      selectedSport = sport;
    });
    // Mise à jour des marqueurs sur la carte en fonction du sport sélectionné
  }


  @override
  Widget build(BuildContext context) {
    final firestoreInstance = FirebaseFirestore.instance;
    Stream<QuerySnapshot<Map<String, dynamic>>> markersStream =
    firestoreInstance.collection('partnerDemands').snapshots();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: markersStream,
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        List<Future<Marker>> futures = snapshot.data!.docs.map((DocumentSnapshot<Map<String, dynamic>> document) async {
          Map<String, dynamic> data = document.data()!;
          DateTime now = DateTime.now();
          Timestamp timestamp = data['start'];
          DateTime dateStart = timestamp.toDate();
          Timestamp timestamp2 = data['end'];

          DateTime dateEnd = timestamp2.toDate().subtract(Duration(hours: 1));

          if(now.isAfter(dateEnd.add(Duration(hours: 1)))){
            FirebaseFirestore.instance
                .collection('partnerDemands')
                .doc(data['uid'])
                .delete()
                .then((value) {
              // Action à effectuer après la suppression réussie
            })
                .catchError((error) {
              print('Error $error');
            });
          }
          GeoPoint geoPoint = data['geoPoint'];
          String iconSport = data['iconSport'];
          double lat = geoPoint.latitude;
          double long = geoPoint.longitude;
          LatLng latLng = LatLng(lat, long);

          final database2 = FirebaseFirestore.instance;
          DocumentSnapshot doc = await database2.collection('users')
              .where('uid', isEqualTo: data['uid'])
              .get()
              .then((querySnapshot) => querySnapshot.docs.first);

            String image_profile = (doc.data() as Map<String, dynamic>)['file'].toString();
          BitmapDescriptor markerIcon = await _getMarkerIcon(iconSport);
          final Uint8List markerIcon2 =await getBytesFromAssets(iconSport, 180);

          if(((selectedSport==data['sport'] || selectedSport=='') && now.isBefore(dateEnd.subtract(Duration(hours: 1))))&& (loggedInuser.gender==data['gender']||data['gender']=='Whatever') && data['geoPoint']!=null)

           {

            return Marker(
              icon: BitmapDescriptor.fromBytes(markerIcon2),

              onTap: () {
                showDialog(context: context, builder: (BuildContext context) {
                  return FractionallySizedBox(
                    alignment: Alignment.bottomCenter,
                    heightFactor: 0.5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(18.0),
                          topRight: Radius.circular(18.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 10.0,
                            spreadRadius: 0.5,
                            offset: Offset(0.0, 5.0),
                          ),
                        ],
                      ),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                    width: 65,
                                    height: 65,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 2,
                                        color: Colors.white,
                                      ),

                                      image: image_profile.toString() != ""
                                          ? DecorationImage(

                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            image_profile.toString(),
                                          )
                                      )
                                          : DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage("assets/user.png"),

                                      ),
                                    )
                                ),

                              ],
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      data['uid']!=loggedInuser.uid ?Text(
                                        '${data['firstname']} is looking for ${data['numPartner']} partner(s)',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ):Text(
                                        'You are looking for ${data['numPartner']} partner(s)',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 12.0),
                                      Text(
                                        'Gender: ${data['gender']}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[700],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      SizedBox(height: 12.0),
                                      Text(
                                        'Address: ${data['address']}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[700],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        'Sport: ${data['sport']}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[700],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        'Start: ${DateFormat('dd/MM/yyyy, HH:mm')
                                            .format(dateStart)}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[700],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      Text(
                                        'End: ${DateFormat('dd/MM/yyyy, HH:mm')
                                            .format(dateEnd)}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[700],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      SizedBox(height: 12.0),
                                      Text(
                                        data['description'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5,
                                        ),
                                      ),
                                      SizedBox(height: 12.0),

                                      data['uid']!=loggedInuser.uid ?TextButton(
                                        style: ButtonStyle(),
                                        onPressed: () {
                                          // Définit la fonction de boîte de dialogue
                                          void showAlertDialog(
                                              BuildContext context) {
                                            // Définit les boutons de la boîte de dialogue
                                            Widget cancelButton = TextButton(
                                              child: Text("No"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            );
                                            Widget continueButton = TextButton(
                                              child: Text("Yes"),
                                              onPressed: () {
                                                if(loggedInuser.uid != null)
                                                  {
                                                    addToFirestoreArray(data['uid'],loggedInuser.uid);
                                                    CollectionReference partnerDemandsCollection =
                                                    FirebaseFirestore.instance.collection('users');
                                                    //sendNotificationToUser(data['tokenMessageOrganizator']);
                                                    partnerDemandsCollection
                                                        .doc(loggedInuser.uid)
                                                        .set({
                                                      'messages': FieldValue.arrayUnion(["You have requested to participate in a partner search for ${data['sport']}"]),
                                                    }, SetOptions(merge: true))
                                                        .then((_) {
                                                      print('Mise à jour du tableau réussie !');

                                                    })
                                                        .catchError((error) {
                                                      print('Erreur lors de la mise à jour du tableau : $error');
                                                    });
                                                    partnerDemandsCollection
                                                        .doc(data['uid'])
                                                        .set({
                                                      'messages': FieldValue.arrayUnion(["You have received a participation request."]),
                                                    }, SetOptions(merge: true))
                                                        .then((_) {
                                                      print('Mise à jour du tableau réussie !');

                                                    })
                                                        .catchError((error) {
                                                      print('Erreur lors de la mise à jour du tableau : $error');
                                                    });
                                                  }
                                                // CollectionReference partnerDemandsCollection =
                                                // FirebaseFirestore.instance.collection('partnerDemands');
                                                // partnerDemandsCollection
                                                //     .doc(data['uid'])
                                                //     .set(
                                                //     {
                                                //       'partners': loggedInuser
                                                //           .uid != null
                                                //           ? data['partners'].add(
                                                //           loggedInuser.uid)
                                                //           : data['partners'].add(
                                                //           "")
                                                //     }, SetOptions(merge: true));

                                                Navigator.pop(context);
                                              },
                                            );

                                            // Construit la boîte de dialogue
                                            AlertDialog alert = AlertDialog(
                                              content: Text("Are you sure?"),
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

                                          // Appelle la fonction de boîte de dialogue lorsque l'utilisateur appuie sur le bouton
                                          showAlertDialog(context);
                                        },
                                        child: Text(
                                          'Participate',
                                          style: TextStyle(
                                              color: GlobalColors.mainColor,fontSize: 18),
                                        ),
                                      ):DeleteDocumentWidget(collectionName: 'partnerDemands', documentId: doc['uid'],),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]
                      ),
                    ),
                  );
                });
              },

              markerId: MarkerId(document.id),
              position: latLng,
            );
          }
          else {
            return Marker(markerId: MarkerId(document.id));
          }
        }).toList();
        GoogleMapController? mapController ;

        return FutureBuilder<List<Marker>>(
          future: Future.wait(futures),
          builder: (BuildContext context, AsyncSnapshot<List<Marker>> snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            else {
              return Scaffold(
             appBar: AppBar(
                title: Text("Map"),
            backgroundColor: GlobalColors.mainColor,
            automaticallyImplyLeading: false,
            ),
              body: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: TextFormField(controller: _searchController,
                        decoration:InputDecoration(hintText: 'Search by location',
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: GlobalColors.mainColor),
                          ),
                        enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.white),
                  ),) ,onChanged: (value){
                          placeAutocomplete(value);
                        },  textInputAction: TextInputAction.search,)),
                      IconButton(onPressed: (){_goToPlace();}, icon: Icon(Icons.search))
                    ],
                  ),


                  _searchController.text!=""?Expanded(
                    child:  ListView.builder(
                      itemCount: placePredictions.length ,
                      itemBuilder: (context, index) =>
                          LocationListTile(
                            press: () {
                              _searchController.text= placePredictions[index].description!;
                            },
                            location: placePredictions[index].description!,
                          ),
                    ),
                  ):Center(),
                  SizedBox(height: 10.0),

                  HorizontalMenu(
                    sports: statusSports,
                    onSportSelected: onSportSelected,
                  ),
                  Expanded(
                    child: GoogleMap(
                      initialCameraPosition: loggedInuser.currentPosition?.latitude != null
                          ? CameraPosition(
                        target: LatLng(
                          loggedInuser.currentPosition!.latitude,
                          loggedInuser.currentPosition!.longitude,
                        ),
                        zoom: 9.4746,
                      )
                          : cameraPosition,

                      markers: Set.from(snapshot.data!),
                      myLocationEnabled: true,
                      mapType: MapType.normal,
                      buildingsEnabled: false,
                      onMapCreated: (GoogleMapController controller) {
                        controller.setMapStyle(json.encode([
                          {        "featureType": "landscape.man_made",        "stylers": [          {            "visibility": "off"          }        ]
                        },
                          {
                            "featureType": "landscape.natural",
                            "stylers": [
                              {
                                "visibility": "off"
                              }
                            ]
                          },
                          {
                            "featureType": "landscape.natural.landcover",
                            "elementType": "labels",
                            "stylers": [
                              {
                                "visibility": "off"
                              }
                            ]
                          },
                          {
                            "featureType": "poi.attraction",
                            "stylers": [
                              {
                                "visibility": "off"
                              }
                            ]
                          },
                          {
                            "featureType": "poi.business",
                            "stylers": [
                              {
                                "visibility": "off"
                              }
                            ]
                          },
                          {
                            "featureType": "poi.medical",
                            "stylers": [
                              {
                                "visibility": "off"
                              }
                            ]
                          },
                          {
                            "featureType": "poi.place_of_worship",
                            "stylers": [
                              {
                                "visibility": "off"
                              }
                            ]
                          }
                        ]));
                        _controller.complete(controller);
                      },
                    ),
                  ),
                ],
              ),
            );
            }
          },
        );
      },
    );
  }
   getNotifications() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token2 = await messaging.getToken();
    var collection = FirebaseFirestore.instance.collection('users');
    collection
        .doc(user!.uid)
        .update({'token_message': token2});
    sendNotificationToServer(token2!, 'Hello', "Eytan", 'assets/SPORTNER.png');





  }
  Future<bool> returnTrue() async {
    Position  currentPosition= await getCurrentPosition();
    getAdressFromLatLong(currentPosition);
    return true;
  }
  Future<void> getAdressFromLatLong (Position position)async {
    List<Placemark> placemark = await placemarkFromCoordinates(
        position.latitude, position.longitude);
    Placemark place =placemark[0];
    String adress = '${place.street}, ${place.locality}, ${place.country}';
    _searchController.text= adress;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference documentRef = firestore.collection('users').doc(loggedInuser.uid);
    GeoPoint geoPoint = GeoPoint(position.latitude, position.longitude);
    documentRef.update({'currentPosition': geoPoint});
  }
  void addToFirestoreArray(String documentUid, String? idToAdd) {
    CollectionReference partnerDemandsCollection =
    FirebaseFirestore.instance.collection('partnerDemands');

    partnerDemandsCollection
        .doc(documentUid)
        .set({
      'partners': FieldValue.arrayUnion([idToAdd]),
    }, SetOptions(merge: true))
        .then((_) {
      print('Mise à jour du tableau réussie !');
    })
        .catchError((error) {
      print('Erreur lors de la mise à jour du tableau : $error');
    });
  }
  Future<void> sendNotificationToServer(
      String userToken, String title, String body, String imageUrl) async {
    final String serverUrl = 'http://35.184.195.40:3000/send-notification';
    final headers = {'Content-Type': 'application/json'};
    final Map<String, String> queryParams = {
      'userToken': userToken,
      'title': title,
      'body': body,
      'imageUrl': imageUrl,
    };

    try {
      final url = Uri.parse('$serverUrl?userToken=$userToken&title=$title&body=$body&imageUrl=$imageUrl');
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        print('Notification sent successfully.');

      } else {
        print('Failed to send notification. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
  Future<void> _goToPlace() async{
    GeoData data = await Geocoder2.getDataFromAddress(
        address: _searchController.text,
        googleMapApiKey: "AIzaSyDBqX4HgXFmkhJcnWqQn1jasayYNfQCiuw");
    setState(() {
      cameraPosition = CameraPosition(target: LatLng(data.latitude,data.longitude));
      _currentCameraPosition=CameraPosition(target: LatLng(data.latitude,data.latitude));


      _searchController.text="";
    });
    //GeoPoint geoPoint =new GeoPoint(data.latitude, data.longitude);
    final GoogleMapController controller =await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(data.latitude,data.longitude),zoom: 14.4746)));
  }
  // void ConnectFirebaseMessaging() async{
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //   String? token2 = await messaging.getToken();
  //   //var collection = FirebaseFirestore.instance.collection('users');
  //   // collection
  //   //     .doc(user!.uid)
  //   //     .update({'token_message': token2});
  //   NotificationSettings settings = await messaging.requestPermission(
  //     alert: true,
  //     announcement: true,
  //     badge: true,
  //     carPlay: true,
  //     criticalAlert: true,
  //     provisional: true,
  //     sound: true,
  //   );
  //   sendNotificationToUser(token2!);
  // }
  // Future<void> sendNotificationToUser(String userToken) async {
  //   final serverKey = 'AAAAFgOqDVg:APA91bGggcXD4nnbXhD8dzBOxomX9Tsbp1isAAj0Y0cSOQ0H-B2jSInXh6mNHZWENZYWfyNeVKtfz5yVMLEuSsex3JRK3e2QDNEgHhclzBcUfqRTwGiq493KP9FgJrhxxVA5m4bQmcyL';
  //   final firebaseUrl = 'https://fcm.googleapis.com/fcm/send';
  //
  //   final headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'key=$serverKey',
  //   };
  //
  //   final notification = {
  //     'to': userToken,
  //     'notification': {
  //       'title': 'Sport Partnership Request',
  //       'body': 'Eytan wants to be your sport partner',
  //     },
  //     'data': {
  //       'custom_key': '1',
  //
  //     },
  //   };
  //
  //   final response = await http.post(
  //     Uri.parse(firebaseUrl),
  //     headers: headers,
  //     body: jsonEncode(notification),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print('Notification sent successfully.');
  //   } else {
  //     print('Failed to send notification. Error: ${response.reasonPhrase}');
  //   }
  // }

//  void sendNotificationToUser(String userToken) async {
    // var api = ApiFcm(tokenServer: 'AAAAFgOqDVg:APA91bGggcXD4nnbXhD8dzBOxomX9Tsbp1isAAj0Y0cSOQ0H-B2jSInXh6mNHZWENZYWfyNeVKtfz5yVMLEuSsex3JRK3e2QDNEgHhclzBcUfqRTwGiq493KP9FgJrhxxVA5m4bQmcyL');
    //
    // api.postMessage(
    //   listtokens: [userToken],
    //   notification: MessageModel(body: 'Notification test tokens'),
    // );
    //
    // api.postTopics(
    //   topics: 'test',
    //   notification: MessageModel(body: 'Notification test topics'),
    // );

    // final serverKey = 'AAAAFgOqDVg:APA91bGggcXD4nnbXhD8dzBOxomX9Tsbp1isAAj0Y0cSOQ0H-B2jSInXh6mNHZWENZYWfyNeVKtfz5yVMLEuSsex3JRK3e2QDNEgHhclzBcUfqRTwGiq493KP9FgJrhxxVA5m4bQmcyL';
    // final firebaseUrl = 'https://fcm.googleapis.com/fcm/send';
    //
    // final headers = {
    //   'Content-Type': 'application/json',
    //   'Authorization': 'key=$serverKey',
    // };
    //
    // final notification = {
    //   "to": userToken,
    //   'notification': {
    //     'title': 'Welcome',
    //     'body': 'Welcome to Sportner',
    //   },
    //   "priority": "high",
    //
    // };
    //
    // final response = await http.post(
    //   Uri.parse(firebaseUrl),
    //   headers: headers,
    //   body: jsonEncode(notification),
    // );
    //
    // if (response.statusCode == 200) {
    //   print('Notification sent successfully.');
    // } else {
    //   print('Failed to send notification. Error: ${response.reasonPhrase}');
    // }
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print('Got a message whilst in the foreground!');
    //   print('Message data: ${message.data}');
    //
    //   if (message.notification != null) {
    //     print('Message also contained a notification: ${message.notification}');
    //   }
    // });
//  }
 }