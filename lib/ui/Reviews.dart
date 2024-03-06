import 'package:flutter/material.dart';

import 'user_ad_screen.dart';

class Review extends StatefulWidget {
  const Review(
      {Key key,
      this.commentId,
      this.adId,
      this.comment,
      this.userId,
      @required this.onDelete,
      this.userimage,
      this.isMyComment = false,
      this.username,
      this.date})
      : super(key: key);

  final commentId, adId, comment, username, userimage, date;
  final int userId;
  final bool isMyComment;

  final Function() onDelete;

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(right: 10, left: 10, top: 15, bottom: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              offset: const Offset(
                1.0,
                2.0,
              ),
              blurRadius: 1,
              spreadRadius: 0.1),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UserAdScreen(username: "${widget.username}"),
                          ),
                        );
                      },
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          maxRadius: 20,
                          minRadius: 20,
                          backgroundImage: widget.userimage == null
                              ? const AssetImage('assets/user2.png')
                              : NetworkImage(widget.userimage),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 5, right: 15, left: 15),
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserAdScreen(
                                      username: "${widget.username}",
                                      user_id: widget.userId,
                                    ),
                                  ));
                            },
                            child: Text(
                              '${widget.username}',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                            ),
                          ),
                          Text(
                            '${widget.date}',
                            style: const TextStyle(
                              color: Colors.black45,
                              fontSize: 12,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (widget.isMyComment)
                  IconButton(
                    onPressed: widget.onDelete,
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Text(
              '${widget.comment} .',
              style: const TextStyle(fontSize: 12),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
