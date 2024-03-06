import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:harajsedirah/ui/user_chat_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyChatList extends StatefulWidget {
  var username, user_id, conversation_id, id, title;
  MyChatList(
      {this.username, this.user_id, this.conversation_id, this.id, this.title});
  // const MyChatList({Key key}) : super(key: key);

  @override
  State<MyChatList> createState() => _MyChatListState();
}

class _MyChatListState extends State<MyChatList> {
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
          .orderByChild("title")
          .equalTo(widget.title);
    });
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
    super.initState();
    _getMassage();
    cheackLogin();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Flexible(
            child: FirebaseAnimatedList(
              query: getMassages,
              padding: const EdgeInsets.all(8.0),

              sort: (a, b) => b.key.compareTo(a.key),
              // comparing timestamp of messages to check which one would appear first
              itemBuilder: (_, DataSnapshot messageSnapshot,
                  Animation<double> animation, int x) {
                print(x);

                return x == 0
                    ? (messageSnapshot.value  as Map)['user_id'][x + 1] != widget.user_id
                        ? Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UserChatScreen(
                                                id: widget.id,
                                                title: widget.title,
                                                username: widget.username,
                                                user_id: widget.user_id,
                                                conversation_id: (messageSnapshot.value  as Map)['conversation_id'],
                                              ),
                                            ));
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(),
                                            // boxShadow: [
                                            //   BoxShadow(
                                            //     color:
                                            //         Colors.grey.withOpacity(0.2),
                                            //     spreadRadius: 5,
                                            //     blurRadius: 10,
                                            //     offset: const Offset(0,
                                            //         30), // changes position of shadow
                                            //   ),
                                            // ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      (messageSnapshot.value  as Map)['senderName'],
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    Spacer(),
                                                    Icon(
                                                        Icons.arrow_forward_ios)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : x != 0
                            ? (messageSnapshot.value  as Map)['user_id'][x - 1] !=
                                    widget.user_id
                                ? Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          UserChatScreen(
                                                        id: widget.id,
                                                        title: widget.title,
                                                        username:
                                                            widget.username,
                                                        user_id: widget.user_id,
                                                        conversation_id:
                                                            (messageSnapshot.value  as Map)['conversation_id'],
                                                      ),
                                                    ));
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    border: Border.all(),
                                                    // boxShadow: [
                                                    //   BoxShadow(
                                                    //     color:
                                                    //         Colors.grey.withOpacity(0.2),
                                                    //     spreadRadius: 5,
                                                    //     blurRadius: 10,
                                                    //     offset: const Offset(0,
                                                    //         30), // changes position of shadow
                                                    //   ),
                                                    // ],
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              (messageSnapshot.value  as Map)['senderName'],
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            Spacer(),
                                                            Icon(Icons
                                                                .arrow_forward_ios)
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : Container()
                            : Container()
                    : Container();

                // return ChatMessageListItem(
                //   messageSnapshot: messageSnapshot,
                //   animation: animation,
                //   annoniceId: widget.id.toString(),
                //   userId: messageSnapshot.value['user_id'].toString(),
                //   authId: auth_id,
                // );
              },
            ),
          ),
          const Divider(height: 1.0),
          // Container(
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: const BorderRadius.all(
          //       Radius.circular(25.0),
          //     ),
          //     border: Border.all(
          //       width: 1,
          //       color: Theme.of(context).primaryColor,
          //     ),
          //   ),
          //   child: _buildTextComposer(),
          // ),
          // Builder(builder: (BuildContext context) {
          //   _scaffoldContext = context;
          //   return const SizedBox(width: 0.0, height: 0.0);
          // })
        ],
      ),
    );
  }
}
