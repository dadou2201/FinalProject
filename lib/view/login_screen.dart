
import 'package:app_sport/view/signup.dart';
import 'package:app_sport/view/splash_view1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' ;
import 'package:fluttertoast/fluttertoast.dart';

import '../model/user_model.dart';
import '../utils/global_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //form key
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  //firebase
  final _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInuser = UserModel();
  void initState() {
    // TODO: implement initState
    super.initState();

     }

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,

        //validator
        validator: (value){
          if(value!.isEmpty)
            {
              return ("Email is required to login");

            }
          if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
            return("Enter a valid email");

          }
            //reg expression for email validation

        },
        onSaved: (value) {
          emailController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration : InputDecoration(
            prefixIcon: Icon(Icons.mail,color: GlobalColors.textColor,),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: GlobalColors.textColor,
            ),

          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: GlobalColors.textColor,
            ),
          ),

        )
    );

    //password field
    final passwordField = TextFormField(

        autofocus: false,
        controller: passwordController,
        obscureText: true,
        //validator
        validator: (value){
          RegExp regex = new RegExp(r'^.{6,}$');
          if(value!.isEmpty){
            return ("Password is required to login");
          }
          if(!regex.hasMatch(value)){
            return ("Enter Valid Pasword (Min. 6 Character)");
          }

        },
        onSaved: (value) {
          passwordController.text = value!;
        },
        decoration : InputDecoration(

            prefixIcon: Icon(Icons.lock,color: GlobalColors.textColor,),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: GlobalColors.textColor,
              ),

            ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: GlobalColors.textColor,
            ),
          ),


        )

    );

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: GlobalColors.mainColor,
      child :MaterialButton(
        padding : EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed:(){ signIn(emailController.text,passwordController.text);


        },
        child : Text("Se connecter", textAlign: TextAlign.center,style:TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold)),
      ),
    );
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: GlobalColors.mainColor,
            elevation:0,

        ),
        body: Center(
            child: SingleChildScrollView(
                child: Container(
                    color: Colors.white,
                    child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                            key: _formKey,
                            child: Column(

                                children :<Widget>[
                                  SizedBox(
                                      height :180,
                                      child : Image.asset(
                                        "assets/sports.jpg",
                                        fit : BoxFit.contain,
                                      )
                                ),
                                  SizedBox(height : 35),
                                  emailField,
                                  SizedBox(height : 25),
                                  passwordField,
                                  SizedBox(height : 35),
                                  loginButton,
                                  SizedBox(height: 15),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:<Widget>[
                                        Text("Vous n'avez pas de compte?"),
                                        GestureDetector(onTap:(){
                                          Navigator.push(context,MaterialPageRoute(builder: (context)=>SignUp(

                                          )));
                                        },
                                          child: Text(" S'enregistrer",style: TextStyle(
                                            fontWeight:FontWeight.bold,
                                            fontSize:15,
                                            color : GlobalColors.mainColor,

                                          ),
                                          ),

                                        )

                                      ]

                                  ),
                                  SizedBox(height: 15),


                                ]

                            )
                        )

                    )
                )
            )
        )
    );
  }
//login funciton

void signIn(String email, String password) async {

     if(_formKey.currentState!.validate()){

        await _auth.signInWithEmailAndPassword(email: email, password: password)
            .then((uid) =>
        {
          Fluttertoast.showToast(msg: "Login successful"),

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => SplashView())),

        }).catchError((e) {
          Fluttertoast.showToast(msg: "Incorrect email/password or no internet connection");
        });






}
  }

}




