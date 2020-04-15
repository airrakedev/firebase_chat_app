import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/rendering.dart';

final Firestore _firestore = Firestore.instance;
String loggedInUser;

class ChatScreen extends StatefulWidget {
  static String id = "/Chat";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _chatController = TextEditingController();

  String chatMessage;
  bool isUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();

      if (user != null) {
        loggedInUser = user.email;
      }
    } catch (e) {
      print(e);
    }
  }

//FIREBASE SNAPSHOTS METHOD
//  void streamMessage() async {
//    await for (var message in _firestore.collection('messages').snapshots()) {
//      for (var chat in message.documents) {
//        print(chat.data);
//      }
//    }
//  }

  void sendMessage() async {
    try {
      final message = await _firestore.collection('messages').add(
        {
          'email': loggedInUser,
          'chat': chatMessage,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
//                _auth.signOut();
//                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ChatBuilder(),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _chatController,
                        onChanged: (value) {
                          setState(() {
                            chatMessage = value;
                          });
                        },
                        decoration: kMessageTextFieldDecoration,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        _chatController.clear();
                        sendMessage();
                      },
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.teal,
            ),
          );
        }

        List<Widget> listResult = [];
        final messages = snapshot.data.documents.reversed;

        for (var message in messages) {
          final user = message.data['email'];
          final chatMessage = message.data['chat'];

          listResult.add(
            BubbleMessage(
              chatMessage: chatMessage,
              user: user,
              isMe: loggedInUser == user,
            ),
          );
        }

        return Expanded(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              reverse: true,
              children: listResult,
            ),
          ),
        );
      },
    );
  }
}

class BubbleMessage extends StatelessWidget {
  BubbleMessage(
      {@required this.chatMessage, @required this.user, @required this.isMe});

  final String chatMessage;
  final String user;
  bool isMe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 0.0),
          child: Text(this.user),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 5.0),
          child: Material(
            borderRadius: BorderRadiusDirectional.only(
              topEnd: isMe ? Radius.circular(20.0) : Radius.circular(0.0),
              topStart: isMe ? Radius.circular(0.0) : Radius.circular(20.0),
              bottomEnd: Radius.circular(20.0),
              bottomStart: Radius.circular(20.0),
            ),
            color: isMe ? Colors.blueAccent : Colors.teal,
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 30.0,
              ),
              child: Text(
                this.chatMessage,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
