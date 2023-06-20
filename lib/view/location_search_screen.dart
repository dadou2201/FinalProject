import 'package:app_sportner2/components/network_utility.dart';
import 'package:app_sportner2/model/autocomplate_prediction.dart';
import 'package:app_sportner2/model/place_auto_complate_response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../components/location_list_tile.dart';
import '../model/partner_demand-model.dart';
import '../model/user_model.dart';
import '../utils/constants.dart';
import '../utils/global_colors.dart';
import 'home_screen.dart';

class SearchLocationScreen extends StatefulWidget {


  const SearchLocationScreen( {
        Key? key,
    required String? uid,
      }) : super(key: key);

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  List<AutocompletePrediction> placePredictions=[];
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  GeoPoint? geoPoint;
  final searchTextController = new TextEditingController();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Add Demand Partner On The Map"),
        backgroundColor: GlobalColors.mainColor,
  automaticallyImplyLeading: false,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [

            FloatingActionButton(
              heroTag: "btn2",
              onPressed: (){
                Navigator.pop(context);
              },
              backgroundColor: Colors.white,
              child: Icon(Icons.arrow_back_outlined,color: GlobalColors.mainColor,),
            ),
            Expanded(child: Container()),
            FloatingActionButton(
              heroTag: "btn3",
              onPressed: (){
                showAlertDialog( context);
              },
              backgroundColor: Colors.white,
              child: Icon(Icons.check,color: GlobalColors.mainColor,),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 60,),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: TextFormField(
                controller: searchTextController,
                onChanged: (value) {

                  placeAutocomplete(value);

                },
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: GlobalColors.mainColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: GlobalColors.mainColor),
                  ),

                  hintText: "Search your location",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Icon(Icons.location_on_outlined,color: GlobalColors.mainColor,)
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            height: 4,
            thickness: 4,
            color: secondaryColor5LightTheme,
          ),
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: ElevatedButton.icon(
              onPressed: () async {
                Position  currentPosition= await getCurrentPosition();
                getAdressFromLatLong(currentPosition);
              },
              icon:Icon(Icons.location_searching),
              label: const Text("Use my Current Location"),
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor10LightTheme,
                foregroundColor: textColorLightTheme,
                elevation: 0,
                fixedSize: const Size(double.infinity, 40),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
          const Divider(
            height: 4,
            thickness: 4,
            color: secondaryColor5LightTheme,
          ),

          Expanded(
            child: ListView.builder(
              itemCount: placePredictions.length,
              itemBuilder: (context, index) =>
                LocationListTile(
                  press: () {
                    searchTextController.text= placePredictions[index].description!;
                  },
                  location: placePredictions[index].description!,
                ),
            ),
          ),


        ],
      ),
    );
  }

  Future<void> getAdressFromLatLong (Position position)async {
    List<Placemark> placemark = await placemarkFromCoordinates(
        position.latitude, position.longitude);
    Placemark place =placemark[0];
    String adress = '${place.street}, ${place.locality}, ${place.country}';
    searchTextController.text= adress;
  }
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {},
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        changeUser();

      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
          "Are you sure ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  Future<Position> getCurrentPosition() async{
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      Fluttertoast.showToast(msg: "Please enable location");
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');

      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void changeUser() async {
    var collection = FirebaseFirestore.instance.collection('partnerDemands');
    String res = "Some error occurred";
    if (_formKey.currentState!.validate()) {
      try {
        GeoData data = await Geocoder2.getDataFromAddress(
            address: searchTextController.text,
            googleMapApiKey: "AIzaSyDBqX4HgXFmkhJcnWqQn1jasayYNfQCiuw");
        GeoPoint geoPoint =new GeoPoint(data.latitude, data.longitude);

        collection
            .doc('${loggedInuser.uid}')
            .update({'geoPoint': geoPoint});
        collection
            .doc('${loggedInuser.uid}')
            .update({'address': searchTextController.text});


      } catch (err) {
        res = err.toString();
      }
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) =>HomeScreen() ));
    }
  }

}
