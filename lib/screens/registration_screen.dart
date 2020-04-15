//import 'dart:html';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'widgets/button_widget.dart';
import 'widgets/text_widget.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = "/Registration";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool _saving = false;
  String email;
  String password;
  String invalid = '';

  void authUser(mail, pass) async {
    setState(() {
      _saving = true;
    });
    try {
      final AuthResult result = await auth.createUserWithEmailAndPassword(
          email: mail, password: pass);
      final FirebaseUser user = result.user;

      if (result.user != null) {
        setState(() {
          _saving = false;
        });
        Navigator.pushNamed(context, ChatScreen.id);
      }
    } catch (e) {
      setState(() {
        invalid = e.message;
        print("Boom -- $invalid");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              Center(
                child: Text(
                  invalid,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                onChanged: (value) {
                  email = value;
                },
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: kInputField.copyWith(
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                onChanged: (value) {
                  password = value;
                },
                obscureText: true,
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: kInputField.copyWith(
                  hintText: 'Enter your password',
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              ButtonFunction(
                label: "Register",
                color: Colors.blueAccent,
                pressed: () {
                  setState(() {
                    print("Email: $invalid");
                    authUser(email, password);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
