import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/rendering.dart';
import 'package:eduverse/Pages/share.dart';
import 'package:eduverse/Utils/constants.dart';
import 'package:eduverse/Utils/constants.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({@required this.groupId, @required this.name});
  final String groupId;
  final String name;
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List messages;
  var userRole;
  var user;
  var userName;
  var userNameChat;
  final TextEditingController _messageController = TextEditingController();

  addMessage() {
    var value = _auth.currentUser.uid;
    DocumentReference collectionReference =
        FirebaseFirestore.instance.collection("users").doc(value);
    collectionReference.snapshots().listen((snapshot) {
      print(snapshot.data());
      userRole = snapshot.data();
      user = userRole["role"];
      setState(() {
        userRole = snapshot.data();
        user = userRole["role"];
        print(user);
      });
    });
    if (user == "student") {
      DocumentReference collection =
          FirebaseFirestore.instance.collection("students").doc(value);
      collection.snapshots().listen((snapshot) {
        print(snapshot.data());
        userName = snapshot.data();
        userNameChat = userName["first_name"];
        setState(() {
          userName = snapshot.data();
          userNameChat = userName["first_name"];
          print(userNameChat);
        });
      });
    } else {
      DocumentReference collection =
          FirebaseFirestore.instance.collection("teachers").doc(value);
      collection.snapshots().listen((snapshot) {
        print(snapshot.data());
        userName = snapshot.data();
        userNameChat = userName["first_name"];
        setState(() {
          userName = snapshot.data();
          userNameChat = userName["first_name"];
        });
      });
    }
    Map<String, dynamic> messageData = {
      "sent_role": userNameChat.toString(),
      "text": _messageController.text,
      "sent_by": value,
      "time": DateTime.now(),
    };

    print(value);
    CollectionReference message = FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .collection('messages');
    message.add(messageData);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.1),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: Row(
          children: [
            Container(
              // padding: EdgeInsets.all(25),
              width: 38,
              height: 38,
              margin: EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: kCyan,
                borderRadius: BorderRadius.circular(11),
                shape: BoxShape.rectangle,
                // image: DecorationImage(
                //     image: AssetImage('assets/images/sarah.jpg'),
                //     fit: BoxFit.fill),
              ),
            ),
            Text(widget.name, style: TextStyle(fontSize: 20)),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Tabs()),
                );
              },
              icon: Icon(Icons.perm_media))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('groups')
                    .doc(widget.groupId)
                    .collection('messages')
                    .orderBy("time")
                    .snapshots(),
                builder: (context, userSnapshot) {
                  return userSnapshot.hasData
                      ? ListView.builder(
                          itemCount: userSnapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            return userSnapshot.data.docs[index]["sent_by"] !=
                                    _auth.currentUser.uid
                                ? Container(
                                    color: Colors.transparent,
                                    child: ChatBubble(
                                      isUser: true,
                                      messageText: userSnapshot.data.docs[index]
                                          ["text"],
                                      time: userSnapshot.data.docs[index]
                                          ["time"],
                                      userName: userSnapshot.data.docs[index]
                                          ["sent_role"],
                                    ))
                                : Container(
                                    color: Colors.transparent,
                                    child: ChatBubble(
                                      isUser: false,
                                      messageText: userSnapshot.data.docs[index]
                                          ["text"],
                                      time: userSnapshot.data.docs[index]
                                          ["time"],
                                      userName: userSnapshot.data.docs[index]
                                          ["sent_role"],
                                    ));
                          })
                      : CircularProgressIndicator();
                },
              ),
            ),
          ),
          Container(
//            color: Colors.white.withOpacity(0.1),
            padding: EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: roundedContainer(),
                ),
                SizedBox(
                  width: 5.0,
                ),
                GestureDetector(
                  onTap: () {
                    addMessage();
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0), //or 15.0
                    child: Container(
                      height: 45.0,
                      width: 45.0,
                      color: kCyan,
                      child: Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                  // child: CircleAvatar(
                  // child: Icon(Icons.send),
                  // ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget roundedContainer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          color: Colors.white.withOpacity(0.2),
          child: Row(
            children: <Widget>[
              SizedBox(width: 8.0),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (builder) => bottomSheet(context));
                },
                icon: Transform.rotate(
                  angle: 3.8,
                  child: Icon(
                    Icons.attach_file,
                    size: 25.0,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(width: 8.0),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({this.isUser, this.messageText, this.time, this.userName});
  final bool isUser;
  final String userName;
  final String messageText;
  final Timestamp time;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 220,
          child: Bubble(
            nip: isUser ? BubbleNip.rightBottom : BubbleNip.leftBottom,
            borderWidth: 20,
            color:
                isUser ? kBlue.withOpacity(0.8) : Colors.white.withOpacity(0.1),
            radius: Radius.circular(15),
            nipRadius: 0,
            nipHeight: 15,
            nipWidth: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isUser ? "" : userName,
                    style: TextStyle(
                      color: kCyan,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(messageText,
                      style: TextStyle(fontSize: 15.0, color: Colors.white)),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          DateFormat.jm().format(time.toDate()),
                          style: TextStyle(fontSize: 12.0, color: Colors.white),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget bottomSheet(context) {
  return Container(
    color: Colors.transparent,
    width: MediaQuery.of(context).size.width,
    height: 220,
    child: Column(
      children: [
        Card(
          color: Color(0xff2A2D41),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.all(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 30,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                iconCreation(
                    Icons.insert_drive_file, kCyan, 'Material', context),
                SizedBox(
                  width: 40,
                ),
                iconCreation(Icons.assignment, kBlue, 'Assignment', context),
                SizedBox(
                  width: 40,
                ),
                iconCreation(Icons.image, kPurple, 'Image', context)
              ],
            ),
          ),
        ),
        SizedBox(
          height: 40,
        )
      ],
    ),
  );
}

Widget iconCreation(
    IconData icon, Color color, String text, BuildContext context) {
  return Column(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(15.0), //or 15.0
        child: Container(
          height: 45.0,
          width: 45.0,
          color: color,
          child: Icon(icon, color: Colors.white),
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Text(
        text,
        style: TextStyle(color: Colors.grey),
      )
    ],
  );
}
