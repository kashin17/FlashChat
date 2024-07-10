import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/Components/message_bubble.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  static String id = 'chat_screen';
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User? loggedInUser;
  String? messageText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }


  void getCurrentUser() {
    try{
      final user = _auth.currentUser;
      if (user != null){
        loggedInUser = user;
        print(loggedInUser!.email);
      }
    }
    catch(e){
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: [
          IconButton(onPressed: (){
            _auth.signOut();
            Navigator.pop(context);
          }, icon: Icon(Icons.close)),
        ],
        centerTitle: true,
        title: Text('⚡️ Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder(
                stream: _firestore.collection('messages').snapshots(),
                builder: (context, snapshot){
                  if(!snapshot.hasData){
                    return const Center(
                     child: CircularProgressIndicator(
                       backgroundColor: Colors.lightBlueAccent,
                     ),
                    );
                  }
                    final messages = snapshot.data!.docs;
                    List<MessageBubble> messageWidgets = [];
                    for (var message in messages){
                      final messageText = message['text'];
                      final messageSender = message['sender'];
                      final currentUser = loggedInUser!.email;

                      final messageWidget = MessageBubble(
                        text: messageText,
                        sender: messageSender,
                        isMe: currentUser == messageSender,);


                      messageWidgets.add(messageWidget);
                    }
                    return Expanded(
                      child: ListView(
                        reverse: true,
                        padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
                        children: messageWidgets,
                      ),
                    );

                },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: TextField(
                    controller: messageTextController,
                    onChanged: (value){ messageText = value; },
                    decoration: kMessageTextFieldDecoration,
                  ),),
                  TextButton(
                      onPressed: (){
                        _firestore.collection('messages').add({'text': messageText, 'sender':loggedInUser!.email});
                        messageTextController.clear();
                      },
                      child:Text(
                        'Send',
                        style: kSendButtonTextStyle),

                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
