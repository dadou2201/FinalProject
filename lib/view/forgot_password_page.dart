
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  @override
  void dispose(){
    emailController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,

        //validator
        validator: (value){
          if(value!.isEmpty)
          {
            return ("This field is required");

          }
          if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
            return("Please enter a valid password (6 characters)");

          }
          //reg expression for email validation

        },
        onSaved: (value) {
          emailController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration : InputDecoration(
            prefixIcon: const Icon(Icons.mail),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Email",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),

            )

        )
    );
    final resetButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.grey,
      child :MaterialButton(

        padding : const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed:(){
            resetPassword();

        },
        child : const Text("Reset password", textAlign: TextAlign.center,style:TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold)),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        elevation: 0,
        title: const Text('Reset password'),
      ),
      body: Padding(
        padding:const EdgeInsets.all(16) ,
        child : Form(
          key: _formKey,
          child : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Receive an email to reset the password',textAlign: TextAlign.center,style: TextStyle(fontSize: 24),),
              const SizedBox(height: 20),
              emailField,
              const SizedBox(height: 20),
              resetButton,
            ],
          )
        ),
      )
    );
  }

  Future  resetPassword() async {
    showDialog(context: context, barrierDismissible: false,
    builder:(context)=>const Center(child: CircularProgressIndicator()),
    );
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim());
      Fluttertoast.showToast(
          msg: "An email has been sent. Check your spam",fontSize: 16,timeInSecForIosWeb: 3);
      Navigator.of(context).popUntil((route) => route.isFirst) ;
    }on FirebaseAuthException catch(e){
      print(e);
      Fluttertoast.showToast(
          msg: "Error please try again",fontSize: 16,timeInSecForIosWeb: 3);
      Navigator.of(context).pop();
    }
  }
}
