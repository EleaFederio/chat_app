import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';

  final _controller = new TextEditingController();

  CollectionReference userObj = FirebaseFirestore.instance.collection('users');

  void _sendMessage () async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await userObj.doc(user.uid).get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt' : Timestamp.now(),
      'userId' : user.uid,
      'username' : userData['username'],
      'userImage': userData['profile_pic_url']
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Send a message...'
              ),
              onChanged: (value){
                setState(() {
                  _enteredMessage = value.trim();
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(
              Icons.send
            ),
            onPressed: _enteredMessage.isEmpty ?  null : _sendMessage,
          )
        ],
      ),
    );
  }
}
