import 'package:arma/screens/signup_screen.dart';
import 'package:arma/utils/color_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../reusable_widgets/reusable_widget.dart';
import 'home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringToColor("5c3a93"),
            hexStringToColor("7d61a9"),
            hexStringToColor("9d89be")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                child: Column(children: <Widget>[
                  logoWidget("assets/images/logo.png"),
                  SizedBox(
                    height: 30,
                  ),
                  reusableTextField("Enter Email", Icons.email_outlined, false,
                      _emailTextController),
                  SizedBox(
                    height: 20,
                  ),
                  reusableTextField("Enter Password", Icons.lock_outline, true,
                      _passwordTextController),
                  SizedBox(
                    height: 20,
                  ),
                  singnInSignUpButton(context, true, () {
                    _signIn(_emailTextController.text,
                        _passwordTextController.text);
                  }),
                  signUpOption()
                ])),
          )),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account ?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  _signIn(String _email, String _password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
      //success
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } on FirebaseAuthException catch (error) {
      if (error.message.toString().toUpperCase() ==
          "THE EMAIL ADDRESS IS BADLY FORMATTED.") {
        Fluttertoast.showToast(
            msg: "Email Adress is wrong !",
            backgroundColor: Colors.red,
            fontSize: 15,
            gravity: ToastGravity.TOP);
      } else if (_email.length == 0 && _password.length == 0) {
        Fluttertoast.showToast(
            msg: "Email and Password cannot be empty !",
            backgroundColor: Colors.red,
            fontSize: 15,
            gravity: ToastGravity.TOP);
      } else if (_email.length == 0) {
        Fluttertoast.showToast(
            msg: "Email adress cannot be empty !",
            backgroundColor: Colors.red,
            fontSize: 15,
            gravity: ToastGravity.TOP);
      } else if (_password.length == 0) {
        Fluttertoast.showToast(
            msg: "Password cannot be empty !",
            backgroundColor: Colors.red,
            fontSize: 15,
            gravity: ToastGravity.TOP);
      } else if (error.message.toString().toUpperCase() ==
          "THERE IS NO USER RECORD CORRESPONDING TO THIS IDENTIFIER. THE USER MAY HAVE BEEN DELETED.") {
        Fluttertoast.showToast(
            msg: "There is no user with this email/password !",
            backgroundColor: Colors.red,
            fontSize: 15,
            gravity: ToastGravity.TOP);
      } else if (_password.length < 6) {
        Fluttertoast.showToast(
            msg: "Password is too short !",
            backgroundColor: Colors.red,
            fontSize: 15,
            gravity: ToastGravity.TOP);
      } else if (error.message.toString().toUpperCase() ==
          "THE PASSWORD IS INVALID OR THE USER DOES NOT HAVE A PASSWORD.") {
        Fluttertoast.showToast(
            msg: "The password is invalid for this user !",
            backgroundColor: Colors.red,
            fontSize: 15,
            gravity: ToastGravity.TOP);
      } else if (error.message.toString().toUpperCase() ==
          "WE HAVE BLOCKED ALL REQUESTS FROM THIS DEVICE DUE TO UNUSUAL ACTIVITY. TRY AGAIN LATER.") {
        Fluttertoast.showToast(
            msg: "Too many logging in attempts , Try again later",
            textColor: Colors.black,
            backgroundColor: Colors.yellowAccent,
            fontSize: 15,
            gravity: ToastGravity.TOP);
      } else {
        print(error.message.toString());
      }
    }
  }
}
