import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:harajsedirah/api/api.dart';
import 'package:harajsedirah/api/api_config.dart';

import 'user_chat_screen.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({Key key}) : super(key: key);

  @override
  _ConversationsScreenState createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {


  bool isConversations = false;
  List conversations = [];
  _getConversations() async {
    var data = {};
    var res = await Api().postAuthData(data, ApiConfig.myConversationsPath);
    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
    } else {
      var body = json.decode(res.body);
      if (body['status']) {
        var dataSections = body['data'];
        setState(() {
          conversations = dataSections;
          conversations.sort((a,b) {
            var adate = a['lastdate']; //before -> var adate = a.expiry;
            var bdate = b['lastdate'] ;//var bdate = b.expiry;
            return -adate.compareTo(bdate);
          });
          print(conversations.first['user_outher']);
          isConversations = true;
        });
      }
    }
  }


  @override
  void initState() {
    super.initState();
    _getConversations();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("المحادثات"),
        centerTitle: true,
        elevation: 0.4,
        /*actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
            },
          ),
        ],*/
      ),
      body: Builder(
        builder: (_) {
          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: conversations.length,
            itemBuilder: (BuildContext context, index) {
              print('-------------');
              print(conversations[index]);
              return InkWell(
                onTap: (){
                    // _seeMessage(conversations[index]['data']['conversation_id']);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserChatScreen(
                              onemess: true,
                              username: conversations[index]["first_name"],
                              conversation_id: conversations[index]['data']['conversation_id'].runtimeType ==
                                  String
                                  ? int.parse(conversations[index]['data']['conversation_id'])
                                  : conversations[index]['data']['conversation_id'],
                              user_id: conversations[index]['data']['receiver_id'],)))
                    .then((value) => _getConversations());
                },
                child: MsgOne(
                    user_outher: conversations[index]["first_name"],
                    conversation_id:
                        conversations[index]['data']['conversation_id'].runtimeType ==
                                String
                            ? int.parse(conversations[index]['data']['conversation_id'])
                            : conversations[index]['data']['conversation_id'],
                    user_id: conversations[index]['data']['receiver_id'],
                    isSeen: conversations[index]['data']['is_seen'].runtimeType ==
                        String
                        ? int.parse(conversations[index]['data']['is_seen'])
                        : conversations[index]['data']['is_seen'],
                    created_at: conversations[index]['data']['created_at'],
                    bodyMsg: conversations[index]['data']['body'],
                    typeMsg: conversations[index]['data']['type']),
              );
            },
          );
        },
      ),
    );
  }
}

class MsgOne extends StatefulWidget {
  String user_outher, bodyMsg, typeMsg, created_at;
  int conversation_id;
  int isSeen;
  var user_id;
  MsgOne(
      {Key key,
      this.bodyMsg,
      this.user_id,
      this.conversation_id,
      this.isSeen,
      this.created_at,
      this.typeMsg,
      this.user_outher})
      : super(key: key);
  @override
  _MsgOneState createState() => _MsgOneState();
}

class _MsgOneState extends State<MsgOne> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 5),
      padding: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: widget.isSeen == 0 ? Colors.grey[200] : null,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  const Icon(Icons.person_pin),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Text(
                      widget.user_outher ?? "name",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 10, top: 10, right: 25, left: 25),
                child: Text(
                  widget.bodyMsg ?? "",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  widget.created_at ?? "create",
                  style: const TextStyle(fontSize: 11),
                ),
              ),
              // Icon(Icons.chat_bubble_outline),
              Stack(
                children: const <Widget>[
                  Icon(Icons.chat_bubble_outline),
                  // Positioned(
                  //   right: 0,
                  //   child: Container(
                  //     padding: EdgeInsets.all(1),
                  //     decoration: BoxDecoration(
                  //       color: Theme.of(context).colorScheme.secondary,
                  //       borderRadius: BorderRadius.circular(6),
                  //     ),
                  //     constraints: BoxConstraints(
                  //       minWidth: 12,
                  //       minHeight: 12,
                  //     ),
                  //     child: Text(
                  //       '',
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 8,
                  //       ),
                  //       textAlign: TextAlign.center,
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

}
