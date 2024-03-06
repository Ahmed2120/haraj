import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

var currentUserEmail;

class ChatMessageListItem extends StatelessWidget {
  final DataSnapshot messageSnapshot;
  final Animation animation;
  final String userId, authId, annoniceId;
  const ChatMessageListItem(
      {Key key,
      this.messageSnapshot,
      this.animation,
      this.userId,
      this.authId,
      this.annoniceId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: animation, curve: Curves.decelerate),
      child: Column(
        children: [
          (messageSnapshot.value  as Map)['title'] != null
              ? Row(
                  children: [
                    Text((messageSnapshot.value  as Map)['title'].toString()),
                    SizedBox(
                      width: 8,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Divider(
                          thickness: 1,
                        )),
                  ],
                )
              : Container(),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: authId != (messageSnapshot.value  as Map)['user_id']
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width / 2,
                          padding: const EdgeInsets.only(
                              right: 10, left: 10, top: 15, bottom: 15),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: getSentMessageLayout())),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width / 2,
                          padding: const EdgeInsets.only(
                              right: 10, left: 10, top: 15, bottom: 15),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: getReceivedMessageLayout())),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  List<Widget> getSentMessageLayout() {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  (messageSnapshot.value  as Map)['senderName'],
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                Text(
                  '${(messageSnapshot.value  as Map)['created_at']}',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            ),
            Container(
              child: (messageSnapshot.value  as Map)['imageUrl'] != null
                  ? Image.network(
                      (messageSnapshot.value  as Map)['imageUrl'],
                      width: 250.0,
                    )
                  : Text(
                      (messageSnapshot.value  as Map)['text'],
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> getReceivedMessageLayout() {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  (messageSnapshot.value  as Map)['senderName'],
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                Text(
                  '${(messageSnapshot.value  as Map)['created_at']}',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            ),
            Container(
              child: (messageSnapshot.value  as Map)['imageUrl'] != null
                  ? Image.network(
                      (messageSnapshot.value  as Map)['imageUrl'],
                      width: 250.0,
                    )
                  : Text(
                      "${(messageSnapshot.value  as Map)['text']}",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
            ),
          ],
        ),
      ),
    ];
  }
}
