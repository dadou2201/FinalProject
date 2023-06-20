
import 'package:app_sportner2/screens/google_map.dart';
import 'package:app_sportner2/screens/home_screen.dart';
import 'package:app_sportner2/screens/registration_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/user_model.dart';
import '../utils/global_colors.dart';
import 'forgot_password_page.dart';

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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInuser = UserModel();
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();


  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleAuth = await googleSignInAccount!
          .authentication;
    String email = googleSignInAccount.email;
    print("email: " + email);

    // Vérifier si l'adresse e-mail est déjà enregistrée dans la galerie des utilisateurs
    bool isEmailRegistered = await checkIfEmailIsRegistered(email);
    if (isEmailRegistered) {
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
          credential);

      return userCredential;
    }
    else {
      Fluttertoast.showToast(msg: "Sign up with your email before using this method");
    }


    }

  void _handleGoogleSignIn() async {

    try {

      final UserCredential? userCredential = await signInWithGoogle();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      // Une erreur s'est produite lors de la connexion
      print('Erreur lors de la connexion avec Google: $e');
    }
  }

  Future<bool> checkIfEmailIsRegistered(String email) async {
    // Référence à la collection "users" dans Firebase Firestore
    CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

    // Effectuez une requête pour récupérer les documents ayant un champ "email" correspondant à l'adresse e-mail donnée
    QuerySnapshot querySnapshot = await usersCollection.where('email', isEqualTo: email).get();

    // Vérifiez si des documents ont été trouvés avec l'adresse e-mail donnée
    bool isRegistered = querySnapshot.docs.isNotEmpty;

    return isRegistered;
  }
  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,

        //
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
        onPressed:(){
          signIn(emailController.text,passwordController.text);


        },
        child : Text("Login", textAlign: TextAlign.center,style:TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold)),
      ),
    );
    List images = [
      "g.png",

    ];
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
                                        "assets/sports.png",
                                        fit : BoxFit.contain,
                                      )
                                  ),
                                  SizedBox(height : 5),
                                  emailField,
                                  SizedBox(height : 25),
                                  passwordField,
                                  SizedBox(height : 35),
                                  loginButton,
                                  SizedBox(height: 15),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:<Widget>[
                                        Text("Forgot your password ?"),
                                        GestureDetector(onTap:(){
                                          Navigator.push(context,MaterialPageRoute(builder: (context)=>ForgotPasswordPage()
                                          ));
                                        },
                                          child: Text(" Click here",style: TextStyle(
                                            fontWeight:FontWeight.bold,
                                            fontSize:15,
                                            color : GlobalColors.mainColor,

                                          ),
                                          ),

                                        )

                                      ]

                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:<Widget>[
                                        Text("You don't have an account ?"),
                                        GestureDetector(onTap:(){
                                          Navigator.push(context,MaterialPageRoute(builder: (context)=>RegistrationScreen()

                                          ));
                                        },
                                          child: Text(" Sign up",style: TextStyle(
                                            fontWeight:FontWeight.bold,
                                            fontSize:15,
                                            color : GlobalColors.mainColor,

                                          ),
                                          ),

                                        )

                                      ]

                                  ),
                                  SizedBox(height: 15),
                                  RichText(
                                    text: TextSpan(
                                      text:"Sign in using Google method",
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 16,

                                      ),

                                    ),
                                  ),
                                  Wrap(
                                    children: List<Widget>.generate(1,
                                            (index) {
                                          return Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: CircleAvatar(
                                                radius: 30,
                                                backgroundColor: Colors.white,
                                                child :  InkWell(
                                                  onTap: ()async {
                                                      if(index==0)
                                                        {
                                                          _handleGoogleSignIn();

                                                         // Handle successful login

                                                        }

                                                  },
                                                  child: CircleAvatar(
                                                    radius: 25,
                                                    backgroundImage: AssetImage(
                                                      "assets/"+images[index],
                                                    ) ,


                                                  ),
                                                )),
                                          );
                                        }
                                    ),
                                  )


                                ]

                            )
                        )

                    )
                )
            )
        )
    );
  }

  void signIn(String email, String password) async {

    if(_formKey.currentState!.validate()){

      await _auth.signInWithEmailAndPassword(email: email, password: password)
          .then((uid) =>
      {
        Fluttertoast.showToast(msg: "Login successful"),

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) =>HomeScreen() )),

      }).catchError((e) {
        Fluttertoast.showToast(msg: "Incorrect email/password or no internet connection");
      });

    }
  }

}
