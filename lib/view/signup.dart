import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../model/user_model.dart';
import '../utils/global_colors.dart';
import 'google_sign_in.dart';
import 'login_screen.dart';
class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //form key
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();


  // editing controller

  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();

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
            return ("Email can't be empty");

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
            return ("Password can't be empty");
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
    final confirmPasswordField = TextFormField(
        autofocus: false,
        controller: confirmPasswordEditingController,
        obscureText: true,
        validator:(value)
        {
          if(passwordController.text != value)
          {
            return "The password is not the same";
          }
          return null;
        },
        onSaved: (value) {
          confirmPasswordEditingController.text = value!;
        },
        decoration : InputDecoration(

          prefixIcon: Icon(Icons.lock,color: GlobalColors.textColor,),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
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
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: GlobalColors.mainColor,
      child :MaterialButton(
        padding : EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed:(){
          signUp(emailController.text,passwordController.text);
        },
        child : Text("Sign up", textAlign: TextAlign.center,style:TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold)),
      ),
    );

    List images = [
      "g.png",
      "i.png",
      "f.png",
      "a.png",
    ];

    double w = MediaQuery.of(context).size.width;
    double h =MediaQuery.of(context).size.height;
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
                                  confirmPasswordField,
                                  SizedBox(height : 25),
                                  signUpButton,
                                  SizedBox(height: 15),
                                  RichText(
                                    text: TextSpan(
                                      text:"Sign up using one of the following methods",
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 16,

                                      ),

                                    ),
                                  ),
                                  Wrap(
                                    children: List<Widget>.generate(4,
                                        (index) {
                                      return Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.grey[300],
                                        child :  InkWell(
                                          onTap: (){
                                            if(index==0){
                                              final provider = Provider.of<GoogleSignInProvider>(context,listen : false);
                                              provider.googleLogin();
                                              //  signInWithGoogle();
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
  void signUp(String email,String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password)
          .then((value)=>{
        postDetailsToFireStore(),

      }).catchError((e)
      {
        Fluttertoast.showToast(msg:"Error");
      });
    }
  }
  Future <void> signInWithGoogle() async{
    final GoogleSignInAccount? _googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? _googleAuth = await _googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(accessToken: _googleAuth?.accessToken,
      idToken: _googleAuth?.idToken,
    );
    try {

       await _auth.signInWithCredential(credential).then((value) => { postDetailsFireStoreForGoogle(_googleUser)});

    }
    on FirebaseAuthException catch (error){
       print(error);
    }



  }

  postDetailsFireStoreForGoogle(GoogleSignInAccount? _googleUser) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    UserModel userModel = UserModel();
    User? user = _auth.currentUser;


    userModel.email =_googleUser!.email;
    userModel.uid = user!.uid;
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());

    Fluttertoast.showToast(msg: "The account has been successfully created :)");
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()), (route) => false);

  }

  postDetailsToFireStore() async {
    //calling our firebase
    // calling our user model;
    // sedding the values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();


    userModel.email =user!.email;
    userModel.uid = user.uid;
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());

    Fluttertoast.showToast(msg: "The account has been successfully created :)");
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()), (route) => false);

  }
}

