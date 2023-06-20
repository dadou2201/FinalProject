import 'package:app_sportner2/screens/utils.dart';
import 'package:app_sportner2/utils/global_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../model/partner_demand-model.dart';
import '../model/user_model.dart';
import 'location_search_screen.dart';
class AddPartnerDemand extends StatefulWidget {
  const AddPartnerDemand({Key? key}) : super(key: key);

  @override
  _AddPartnerDemandState createState() => _AddPartnerDemandState();
}

class _AddPartnerDemandState extends State<AddPartnerDemand> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  final firstNameEditingController = new TextEditingController();
  final descriptionEditingController= new TextEditingController();
  final sportEditingController = new TextEditingController();
  final phoneNumberEditingController = new TextEditingController();
  final genderEditingController = new TextEditingController();
  final numberPartnerController = TextEditingController();
  DateTime fromDate=DateTime.now();
  DateTime toDate=DateTime.now().add(Duration(hours:2));
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
    final List<String> genderItems = [
      'Male',
      'Female',
      'Whatever',
    ];
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
      "Climbing",
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
      "Paddle Tennis",
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
      hint: const Text(
        'Gender',
        style: TextStyle(fontSize: 14),
      ),

      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black45,
      ),
      iconSize: 30,
      buttonHeight: 60,
      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      items: genderItems
          .map((item) =>
          DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Choose the gender required';
        }
      },
      onChanged: (value) {
        genderEditingController.text = value.toString();
        //Do something when changing the item if you want.
      },
      onSaved: (value) {
        genderEditingController.text = value!.toString();
      },
    );
    final sportField = DropdownButtonFormField2(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.sports_soccer_rounded,color: GlobalColors.mainColor,size: 20,),
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
      hint: const Text(
        'Sport',
        style: TextStyle(fontSize: 14),
      ),

      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black45,
      ),
      iconSize: 30,
      buttonHeight: 60,
      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      items: statusSports
        .map((item) =>
        DropdownMenuItem<String>(
          value: item,
          child : Text(
              item,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),


        ))
        .toList(),
      validator: (value) {
        if (value == null) {
          return 'Choose your sport';
        }
      },
      onChanged: (value) {
        sportEditingController.text = value!.toString();
        //Do something when changing the item if you want.
      },
      onSaved: (value) {
        sportEditingController.text = value!.toString();
      },
    );
    final numberPartnerField = TextFormField(
        autofocus: false,
        controller: numberPartnerController,
        keyboardType: TextInputType.number,
        validator: (value){
          if(value!.isEmpty){
            return ("This field is required");
          }
        },

        onSaved: (value) {
          numberPartnerController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration : InputDecoration(

          prefixIcon: Icon(Icons.emoji_people_rounded,color: GlobalColors.mainColor,),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Number of Partner(s)",
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
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
    final descriptionField= TextFormField(
      controller: descriptionEditingController,
      keyboardType: TextInputType.name,
      validator: (value){


      },

      onSaved: (value) {
        descriptionEditingController.text = value!;
      },

      textInputAction: TextInputAction.next,
      decoration : InputDecoration(
          prefixIcon: Icon(Icons.text_fields,color: GlobalColors.mainColor,),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "More details...(optional)",
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
              color: GlobalColors.mainColor),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
              color: GlobalColors.mainColor),
        ),

      ),
      maxLines: 7,
    );
    Widget buildDropdownField({required String text, required VoidCallback onClicked}) =>
        ListTile(
          title: Text(text),
          trailing: Icon(Icons.arrow_drop_down),
          onTap: onClicked,
        );
    Widget buildDateTimePickers()=>
        Column(
          children: [
            Row(
              children: [

                Expanded(
                  flex: 2,

                  child: ListTile(
                    title: Text(Utils.toDate(fromDate)),
                    trailing: Icon(Icons.arrow_drop_down),
                    onTap: (){
                      pickFromDateTime(pickDate:true);
                    },
                  ),

                ),
                Expanded(child: buildDropdownField(text: Utils.toTime(fromDate),onClicked:(){
                  pickFromDateTime(pickDate:false);
                }),

                ),
              ],
            ),
            Row(
              children: [

                Expanded(
                  flex: 2,

                  child: ListTile(
                    title: Text(Utils.toDate(toDate)),
                    trailing: Icon(Icons.arrow_drop_down),
                    onTap: (){
                      pickToDateTime(pickDate:true);
                    },
                  ),

                ),
                Expanded(child: buildDropdownField(text: Utils.toTime(toDate),onClicked:(){
                  pickToDateTime(pickDate:false);
                }),

                ),
              ],
            ),
          ],
        );
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        heroTag: "btn1",

        onPressed: ()async {
          postDetailsToFireStore();

        },
        backgroundColor: Colors.white,
        child: Icon(Icons.arrow_forward,color: GlobalColors.mainColor,),
      ),
        appBar: AppBar(
          title: Text("Add Demand Partner On The Map"),
          backgroundColor: GlobalColors.mainColor,
          automaticallyImplyLeading: false,

        ),
      body: Container(
          padding: EdgeInsets.only(left: 8,top:12,right:8),
          child:ListView(
            children: [
              Center(
                child : Stack(
                  children: [

              Padding(
                padding: EdgeInsets.all(25.0),
                child :Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      numberPartnerField,
                      SizedBox(height: 20,),
                      genderField,
                      SizedBox(height: 20,),
                      sportField,

                    ],
                  ),
                ),
              ),
                    Padding(
                        padding: EdgeInsets.only(top: 300),
                    child : buildDateTimePickers(),
                  ),
                    Padding(
                      padding: EdgeInsets.only(left : 20,top: 420,right: 20,bottom: 62),
                      child : descriptionField,
                    ),

            ],

    )
    )
    ]
    )
    )
    );
  }
  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate,pickDate:pickDate);
    if(date==null)return ;

    if(date.isAfter(toDate)){
      toDate=DateTime(date.year,date.month,date.day,toDate.hour,toDate.minute);

    }
    setState(() =>fromDate=date);

  }

  Future<DateTime?>pickDateTime(DateTime initialDate, {required bool pickDate, DateTime? firstDate,}) async {
    if(pickDate){
      final date = await showDatePicker(context: context, initialDate: initialDate, firstDate: firstDate?? DateTime(2016,8), lastDate: DateTime(2101));
      if(date==null )return null;
      final time = Duration(hours:initialDate.hour,minutes: initialDate.minute);
      return date.add(time);
    }
    else {
      final timeOfDay = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(initialDate));
      if(timeOfDay==null)return null;
      final date = DateTime(initialDate.year,initialDate.month,initialDate.day);
      final time = Duration(hours:timeOfDay.hour,minutes: timeOfDay.minute);

      return date.add(time);
    }


  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(toDate,pickDate:pickDate,firstDate: pickDate?fromDate:null);
    if(date==null)return ;

    if(date.isAfter(toDate)){
      toDate=DateTime(date.year,date.month,date.day,toDate.hour,toDate.minute);

    }
    setState(() =>toDate=date);

  }

  postDetailsToFireStore() async {
    //calling our firebase
    // calling our user model;
    // sedding the values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
   // User? user = _auth.currentUser;
    String res = "Some error occurred";
    PartnerDemand partnerDemand = PartnerDemand();
    if (_formKey.currentState!.validate()) {
      try {
        partnerDemand.uid = user!.uid;
        partnerDemand.firstname = loggedInuser.firstname;
        partnerDemand.end = toDate.add(Duration(hours: 1));
        partnerDemand.start = fromDate;
        partnerDemand.sport = sportEditingController.text;
        partnerDemand.iconSport = checkAndAddSport(sportEditingController.text);
        partnerDemand.description = descriptionEditingController!.text;
        partnerDemand.gender = genderEditingController.text;
        partnerDemand.numPartner = numberPartnerController.text;
        partnerDemand.numberPhone = loggedInuser.numberPhone;
        partnerDemand.partners=['${user!.uid}'];
        partnerDemand.tokenMessageOrganizator=loggedInuser.token_message;
        partnerDemand.acceptedPartners=[];
        await firebaseFirestore
            .collection("partnerDemands")
            .doc(user!.uid)
            .set(partnerDemand.toMap());
      } catch (err) {
        res = err.toString();
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchLocationScreen(
          uid: '${user!.uid}',
        )),
      );
    }


  }
  String checkAndAddSport(String sport){
    if(sport=="Aikido")
      {
        return "assets/Aikido_pictogram.svg.png";

      }
    else if(sport=='Badminton'){

      return "assets/badminton-svgrepo-com.png";
    }
    else if(sport=='Baseball'){

    return "assets/baseball-1-svgrepo-com.png";
    }
    else if(sport=='Basketball'){

      return "assets/basketball-svgrepo-com.png";
    }
    else if(sport=='Beach volleyball'){

      return "assets/beach-volleyball-svgrepo-com.png";
    }
    else if(sport=='BMX'){

      return "assets/cycling-2-svgrepo-com.png";
    }
    else if(sport=='BMX racing'){

      return "assets/racetrack-cycling-svgrepo-com.png";
    }
    else if(sport=='Boxing'){

      return "assets/boxing-gloves-combat-svgrepo-com.png";
    }
    else if(sport=='Canoeing'){

      return "assets/canoe-kayak-svgrepo-com.png";
    }
    else if(sport=='Climbing'){

      return "assets/climbing.png";
    }
    else if(sport=='Cricket'){

      return "assets/cricket-svgrepo-com.png";
    }
    else if(sport=='Diving'){

      return "assets/diving-2-svgrepo-com.png";
    }
    else if(sport=='Fencing'){

      return "assets/fencing-attack-svgrepo-com.png";
    }
    else if(sport=='Field hockey'){

      return "assets/field-hockey-svgrepo-com.png";
    }
    else if(sport=='Football'){

      return "assets/football-svgrepo-com.png";
    }
    else if(sport=='Golf'){

      return "assets/golf-svgrepo-com.png";
    }
    else if(sport=='Gymnastics'){

      return "assets/gymnastics-svgrepo-com.png";
    }
    else if(sport=='Handball'){

      return "assets/handball-svgrepo-com.png";
    }
    else if(sport=='Hockey'){

      return "assets/hockey-svgrepo-com.png";
    }
    else if(sport=='Judo'){

      return "assets/martial-arts-uniform-svgrepo-com.png";
    }
    else if(sport=='Karate'){

      return "assets/karate-fighter-svgrepo-com.png";
    }
    else if(sport=='Kayaking'){

      return "assets/canoe-kayak-svgrepo-com.png";
    }
    else if(sport=='Kickboxing'){

      return "assets/kickboxing-svgrepo-com.png";
    }
    else if(sport=='Lacrosse'){

      return "assets/lacrosse-svgrepo-com.png";
    }
    else if(sport=='Mountain biking'){

      return "assets/person-mountain-biking-svgrepo-com.png";
    }
    else if(sport=='Paddle Tennis'){

      return "assets/padel_tennis.png";
    }
    else if(sport=='Polo'){

      return "assets/polo-silhouette-svgrepo-com.png";
    }
    else if(sport=='Rowing'){

      return "assets/kisspng-computer-icons-rowing-oar-clip-art-rowing-5acd76a9ac2b31.5111840515234146977052.jpg";
    }
    else if(sport=='Rugby'){

      return "assets/rugby-4-svgrepo-com.png";
    }
    else if(sport=='Skiing'){

      return "assets/skiing-svgrepo-com.png";
    }
    else if(sport=='Snowboarding'){

      return "assets/snowboard-svgrepo-com.png";
    }
    else if(sport=='Soccer'){

      return "assets/soccer-ball-illustration-svgrepo-com.png";
    }
    else if(sport=='Surfing'){

      return "assets/surfing-pictogram-4-svgrepo-com.png";
    }
    else if(sport=='Synchronized swimming'){

      return "assets/synchronized-swimming-svgrepo-com.png";
    }
    else if(sport=='Swimming')
      {
        return "assets/swimming-svgrepo-com.png";
      }
    else if(sport=='Table tennis'){

      return "assets/table-tennis-4-svgrepo-com.png";
    }
    else if(sport=='Taekwondo'){

      return "assets/taekwondo-couple-silhouettes-svgrepo-com.png";
    }
    else if(sport=='Tennis'){

      return "assets/tennis-svgrepo-com.png";
    }
    else if(sport=='Track and field'){

      return "assets/badminton-svgrepo-com.png";
    }
    else if(sport=='Volleyball'){

      return "assets/volleyball-ball-svgrepo-com.png";
    }
    else if(sport=='Water polo'){

      return "assets/water-polo-svgrepo-com.png";
    }
    else if(sport=='Weightlifting'){

      return "assets/weightlifting-silhouette-svgrepo-com.png";
    }
    else if(sport=='Windsurfing'){

      return "assets/wind-surfing-svgrepo-com.png";
    }
    else if(sport=='Wrestling'){

      return "assets/wrestling-svgrepo-com.png";
    }



    return "";
  }
}
