import 'package:flutter/material.dart';
import 'package:harajsedirah/main.dart';

import "package:harajsedirah/model/notification_response.dart" as notifi;
import 'package:harajsedirah/provider/notification_provider.dart';
import 'package:harajsedirah/ui/ad_screen.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    CollectionCount = 0;
    return ChangeNotifierProvider(
        create: (context) => NotificationProvider()..init(),
        child: Builder(builder: (context) {
          return Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              title: const Text('الأشعارات'),
              centerTitle: true,
              elevation: 0.4,
              /*actions: <Widget>[
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: (){
                  
                },
              ),
            ],*/
            ),
            body: Consumer<NotificationProvider>(
                builder: (context, value, child) => value.notifications != null
                    ? ListView.builder(
                        itemCount: value.notifications.length,
                        itemBuilder: (context, index) => NotfiOne(
                            notification: value.notifications[index],
                            key: Key(value.notifications[index].id.toString())),
                      )
                    : Container()),
          );
        }));
  }
}

class NotfiOne extends StatefulWidget {
  final notifi.Notification notification;

  const NotfiOne({Key key, this.notification}) : super(key: key);

  @override
  State<NotfiOne> createState() => _NotfiOneState();
}

class _NotfiOneState extends State<NotfiOne> {
  int x = 0;
  Color c = Colors.grey[500];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          x == 1;
          c = Colors.white;
        });
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AdScreen(
                id: widget.notification.ad.id,
                area: widget.notification.ad.areaId,
                city: widget.notification.ad.city,
                date: widget.notification.ad.dateString,
                title: widget.notification.ad.adTitle,
                user: widget.notification.ad.username,
                userId: int.parse(widget.notification.ad.userId)),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
        padding: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: widget.notification.seen.toString() == "1" && x == 0
              ? Colors.white
              : c,
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
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
                SizedBox(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        widget.notification.type,
                        style: const TextStyle(fontSize: 18),
                      ),
                    )),
                Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    margin: const EdgeInsets.only(right: 10, left: 10),
                    child: Text(
                      widget.notification.dateString,
                      style: const TextStyle(fontSize: 12),
                    )),
              ],
            ),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
