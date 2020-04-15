import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'widgets/button_widget.dart';
import 'widgets/text_widget.dart';
import 'package:flash_chat/constants.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = "/Login";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _saving = false;
  String email = '';
  String password = '';
  String invalid = '';

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
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
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
                label: "Log In",
                color: Colors.lightBlueAccent,
                pressed: () async {
                  setState(() {
                    _saving = true;
                  });
                  try {
                    final AuthResult result =
                        await _auth.signInWithEmailAndPassword(
                            email: email, password: password);

                    setState(() {
                      invalid = '';
                      _saving = false;
                    });

                    if (result.user != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                  } catch (e) {
                    setState(() {
                      invalid = e.message;
                      _saving = false;
                      print(e.message);
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
