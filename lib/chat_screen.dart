import 'dart:async';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'chat_message_list_item.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

final googleSignIn = GoogleSignIn();
final analytics = FirebaseAnalytics.instance;
final auth = FirebaseAuth.instance;
var currentUserEmail;
var _scaffoldContext;

class ChatScreen extends StatefulWidget {
  final String username;
  final int conversationId;
  const ChatScreen({Key key, this.conversationId, this.username})
      : super(key: key);
  @override
  ChatScreenState createState() {
    return ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> {
  Color _colorCont = Colors.transparent;
  bool visibleAlert = false;
  final TextEditingController _textEditingController = TextEditingController();
  bool _isComposingMessage = false;
  final reference = FirebaseDatabase.instance.reference().child('messages');
  var picker = ImagePicker();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(widget.username),
          centerTitle: true,
          elevation: 0.4,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                  onTap: () {
                    setState(() {
                      visibleAlert = true;
                      _colorCont = Colors.grey;
                    });
                  },
                  child: const Icon(Icons.more_vert)),
            ),
          ],
        ),
        body: Builder(builder: (BuildContext context) {
          return Stack(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    visibleAlert = false;
                    _colorCont = Colors.transparent;
                  });
                },
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
                            query: reference,
                            padding: const EdgeInsets.all(8.0),
                            reverse: true,
                            sort: (a, b) => b.key.compareTo(a.key),
                            // comparing timestamp of messages to check which one would appear first
                            itemBuilder: (_, DataSnapshot messageSnapshot,
                                Animation<double> animation, int x) {
                              return ChatMessageListItem(
                                messageSnapshot: messageSnapshot,
                                animation: animation,
                              );
                            },
                          ),
                        ),
                        const Divider(height: 1.0),
                        Container(
                          decoration:
                              BoxDecoration(color: Theme.of(context).cardColor),
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
                    height: 130,
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
                                  "مسح المحادثة",
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
                                  "إلغاء",
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
        }));
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

  Widget _buildTextComposer() {
    return IconTheme(
        data: IconThemeData(
          color: _isComposingMessage
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).disabledColor,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: IconButton(
                    icon: Icon(
                      Icons.photo_camera,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () async {
                      await _ensureLoggedIn();

                      var pickedFile =
                          await picker.getImage(source: ImageSource.gallery);
                      File imageFile = File(pickedFile.path);
                      int timestamp = DateTime.now().millisecondsSinceEpoch;
                      FirebaseStorage storageReference =
                          FirebaseStorage.instance;
                      Reference ref = storageReference
                          .ref()
                          .child("img_" + timestamp.toString() + ".jpg");
                      UploadTask uploadTask = ref.putFile(File(imageFile.path));
                      /*
                      final metadata = firebase_storage.SettableMetadata(
                          contentType: 'image/jpeg',
                          customMetadata: {'picked-file-path': file.path});
                      */
                      var downloadUrl;
                      uploadTask.then((res) {
                        var downloadUrl = ref.getDownloadURL();
                      });
                      _sendMessage(
                          messageText: null, imageUrl: downloadUrl.toString());
                    }),
              ),
              Flexible(
                child: TextField(
                  controller: _textEditingController,
                  onChanged: (String messageText) {
                    setState(() {
                      _isComposingMessage = messageText.isNotEmpty;
                    });
                  },
                  onSubmitted: _textMessageSubmitted,
                  decoration: const InputDecoration.collapsed(
                      hintText: "Send a message"),
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

  Future<void> _textMessageSubmitted(String text) async {
    _textEditingController.clear();

    setState(() {
      _isComposingMessage = false;
    });

    await _ensureLoggedIn();
    _sendMessage(messageText: text, imageUrl: null);
  }

  void _sendMessage({String messageText, String imageUrl}) {
    reference.push().set({
      'text': messageText,
      'email': googleSignIn.currentUser.email,
      'imageUrl': imageUrl,
      'senderName': googleSignIn.currentUser.displayName,
      'senderPhotoUrl': googleSignIn.currentUser.photoUrl,
    });

    // analytics.logEvent(name: 'send_message');
  }

  Future<void> _ensureLoggedIn() async {
    GoogleSignInAccount signedInUser = googleSignIn.currentUser;
    signedInUser ??= await googleSignIn.signInSilently();
    if (signedInUser == null) {
      await googleSignIn.signIn();
      analytics.logLogin();
    }

    if (auth.currentUser == null) {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final FirebaseAuth _auth = FirebaseAuth.instance;
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
    }
  }

  Future _signOut() async {
    await auth.signOut();
    googleSignIn.signOut();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('User logged out')));
  }
}
