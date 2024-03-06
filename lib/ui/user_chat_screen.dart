import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harajsedirah/api/api.dart';
import 'package:harajsedirah/api/api_config.dart';
import 'package:harajsedirah/chat_message_list_item.dart';
import 'package:harajsedirah/helper/helper.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

var _scaffoldContext;

class UserChatScreen extends StatefulWidget {
  var username, user_id, conversation_id, id, title, onemess;
  UserChatScreen(
      {this.username,
      this.user_id,
      this.conversation_id,
      this.id,
      this.title,
      this.onemess});
  @override
  _UserChatScreenState createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  Color _colorCont = Colors.transparent;
  bool visibleAlert = false;
  final TextEditingController _textEditingController = TextEditingController();
  bool _isComposingMessage = false;
  final databaseReference =
      FirebaseDatabase.instance.reference().child('conversation_masseges');
  var getMassages;

  _getMassage() {
    setState(() {
      getMassages = FirebaseDatabase.instance
          .reference()
          .child('conversation_masseges')
          .orderByChild("conversation_id")
          .equalTo(widget.conversation_id);
    });
  }


  _seeMessage() async {
    var data = {
    };
    var res = await Api().postAuthData(data, ApiConfig.seeMessage + '?' + 'conversation_id=${widget.conversation_id}');
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      print('llllllljjjj------eror------');
      print(res.body);
    } else {
      print('llllllljjjj------------');
      print(res.body);

    }
  }


  var auth_id;

  void cheackLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('token') != null) {
      setState(() {
        auth_id = prefs.get('id');
      });
    }
  }

  @override
  void initState() {
    print(widget.user_id);
    super.initState();
    _seeMessage();
    _getMassage();
    cheackLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('${widget.username}'),
        centerTitle: true,
        elevation: 0.4,
        /*actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              onTap: (){
                setState(() {
                  visibleAlert =true;
                  _colorCont = Colors.grey;
                });
              },
              child: Icon(Icons.more_vert)
            ),
          ),
        ],*/
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Stack(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    visibleAlert = false;
                    _colorCont = Colors.transparent;
                  });
                },
                // child: Container(
                //   width: double.infinity,
                //   height: double.infinity,
                //   color: _colorCont,
                //   child: Container(
                //     margin: EdgeInsets.all(15),
                //     child: ListView(
                //       children: <Widget>[
                //         Chat(),
                //         Chat(),
                //         Chat(),
                //         Chat(),
                //         Chat(),
                //         Chat(),
                //         SizedBox(
                //           height: 80,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),

                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: _colorCont,
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        Flexible(
                          child: FirebaseAnimatedList(
                            query: getMassages,
                            padding: const EdgeInsets.all(8.0),
                            reverse: true,
                            sort: (a, b) => b.key.compareTo(a.key),
                            // comparing timestamp of messages to check which one would appear first
                            itemBuilder: (_, DataSnapshot messageSnapshot,
                                Animation<double> animation, int x) {
                              // print('❣❣');
                              // print(messageSnapshot.value);
                              return ChatMessageListItem(
                                messageSnapshot: messageSnapshot,
                                animation: animation,
                                annoniceId: widget.id.toString(),
                                userId:
                                    (messageSnapshot.value  as Map)['user_id'].toString(),
                                authId: auth_id,
                              );
                            },
                          ),
                        ),
                        const Divider(height: 1.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(25.0),
                            ),
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          child: _buildTextComposer(),
                        ),
                        Builder(builder: (BuildContext context) {
                          _scaffoldContext = context;
                          return const SizedBox(width: 0.0, height: 0.0);
                        })
                      ],
                    ),
                  ),
                  decoration: Theme.of(context).platform == TargetPlatform.iOS
                      ? BoxDecoration(
                          border: Border(
                              top: BorderSide(
                          color: Colors.grey[200],
                        )))
                      : null,
                ),
              ),
              Visibility(
                visible: visibleAlert,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.white,
                    height: 150,
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            setState(() {
                              visibleAlert = false;
                              _colorCont = Colors.transparent;
                            });
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.delete,
                                  size: 30,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'مسح المحادثة',
                                  style: TextStyle(fontSize: 20),
                                ),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              visibleAlert = false;
                              _colorCont = Colors.transparent;
                            });
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.close,
                                size: 30,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'إلغاء',
                                  style: TextStyle(fontSize: 20),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
        data: IconThemeData(
          color: _isComposingMessage
              ? Theme.of(context).primaryColor
              : Theme.of(context).disabledColor,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: _textEditingController,
                  keyboardType: TextInputType.multiline,
                  onChanged: (String messageText) {
                    setState(() {
                      _isComposingMessage = messageText.isNotEmpty;
                    });
                  },
                  onSubmitted: _textMessageSubmitted,
                  decoration: const InputDecoration(
                      fillColor: Colors.black,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(right: 19.0, left: 19),
                      hintText: 'أكتب هنا',
                      hintStyle: TextStyle(
                          color: Colors.black38,
                          fontSize: 14.0,
                          fontFamily: 'Cocan',
                          fontWeight: FontWeight.bold)),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? getIOSSendButton()
                    : getDefaultSendButton(),
              ),
            ],
          ),
        ));
  }

  void _sendMessage({String messageText, String imageUrl}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    var data = {
      'body': messageText,
      'conversation_id': widget.conversation_id,
      'receiver_id': widget.user_id,
    };
    print('99999999999999999');
    print(widget.user_id);
    var res = await Api().postAuthData(data, ApiConfig.sendMessagePath);
    print('9999999999000000000009');
    print(res.body);
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {

    } else {
      var body = json.decode(res.body);
      print(';;;;;;;;;;;;;;;;;;;;;;;');
      print(body);
      if (body['status']) {
        databaseReference.push().set({
          'text': messageText,
          'conversation_id': widget.conversation_id,
          'receiver_id': widget.user_id,
          'annoince': widget.id,
          'title': widget.title,
          'user_name': widget.username,
          'user_id': prefs.get('id'),
          'email': prefs.get('email'),
          'senderName': prefs.get('username'),
          'senderPhotoUrl': apiUrlImage(prefs.get('img')),
          'created_at': DateFormat('kk:mm').format(now),
        });
        _seeMessage();
      }
    }
  }

  void _sendoneMessage({String messageText, String imageUrl}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
print('----------------------');
print(messageText);
    // var data = {
    //   'body': messageText,
    //   'conversation_id': widget.conversation_id,
    //   'receiver_id': widget.user_id,
    // };
    // print(widget.conversation_id);
    // print("سززييزسيتزتسزي${widget.user_id.toString()}");

    // var res = await Api().postAuthData(
    //   ApiConfig.sendMessagePath,
    //   data,
    // );
    // final int statusCode = res.statusCode;
    // if (statusCode < 200 || statusCode > 400 || json == null) {
    //   print('error');
    // } else {
    //   print('success');

    // var body = json.decode(res.body);
    // if (body['status']) {
    databaseReference.push().set({
      'text': messageText,
      'conversation_id': widget.conversation_id,
      'receiver_id': widget.user_id,
      'annoince': widget.id,
      'title': widget.title,
      'user_name': widget.username,
      'user_id': prefs.get('id'),
      'email': prefs.get('email'),
      'senderName': prefs.get('username'),
      'senderPhotoUrl': apiUrlImage(prefs.get('img')),
      'created_at': DateFormat('kk:mm').format(now),
    });
    // }
    // }
    // analytics.logEvent(name: 'send_message');
  }

  Future<void> _textMessageSubmitted(String text) async {
    _textEditingController.clear();
    setState(() {
      _isComposingMessage = false;
    });

    // widget.onemess == false
    //     ? _sendMessage(messageText: text, imageUrl: null)
    //     : _sendoneMessage(messageText: text, imageUrl: null);

    _sendMessage(messageText: text, imageUrl: null);
  }

  CupertinoButton getIOSSendButton() {
    return CupertinoButton(
      child: const Text("Send"),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  IconButton getDefaultSendButton() {
    return IconButton(
      icon: const Icon(Icons.send),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }
}

class Chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(
                    right: 25, left: 25, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text(
                        'السلام عليكم',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    Text(
                      '11:56 ص',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(
                    right: 25, left: 25, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text(
                        'وعليكم السلام',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    Text(
                      '11:56 ص',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
