import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class TextComposer extends StatefulWidget {
  @override
  _TextComposerState createState() => _TextComposerState();
}


final googleSignIn = GoogleSignIn();
final auth = FirebaseAuth.instance;

Future<Null> _ensureLogedIn() async {
  var user = googleSignIn.currentUser;
  if (user == null) user = await googleSignIn.signInSilently();

  if (user == null) user = await googleSignIn.signIn();

  if (await auth.currentUser() == null) {
    var credentials = await googleSignIn.currentUser.authentication;
    await auth.signInWithCredential(GoogleAuthProvider.getCredential(
        idToken: credentials.idToken, accessToken: credentials.accessToken));
  }
}

_handleSubimitted(BuildContext context, String text) async {
  try {
    await _ensureLogedIn();
    _sendMessage(text: text);
  }
  catch(error) {
    print(error);

    final snackBar = SnackBar(content: Text('Erro no login, tente novamente.'));
    Scaffold.of(context).showSnackBar(snackBar);
  }
}

void _sendMessage({String text, String imageUrl}) {
  Firestore.instance.collection("messages").add({
    "text":text,
    "image":imageUrl,
    "senderName":googleSignIn.currentUser.displayName,
    "senderImage":googleSignIn.currentUser.photoUrl
  });
}

class _TextComposerState extends State<TextComposer> {
  bool _isComposing = false;
  final _textController = TextEditingController();

  void _reset() {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[200])))
            : null,
        child: Row(
          children: <Widget>[
            Container(
              child:
                  IconButton(icon: Icon(Icons.photo_camera), onPressed: () {}),
            ),
            Expanded(
              child: TextField(
                controller: _textController,
                onSubmitted: (text) {
                  _handleSubimitted(context, text);
                  _reset();
                },
                decoration:
                    InputDecoration.collapsed(hintText: "Enviar uma mensagem"),
                onChanged: (text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? CupertinoButton(
                      child: Text("Enviar"),
                      onPressed: _isComposing ? () {
                        _handleSubimitted(context, _textController.text);
                        _reset();
                      } : null)
                  : IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _isComposing ? () {
                        _handleSubimitted(context, _textController.text);
                        _reset();
                      } : null),
            )
          ],
        ),
      ),
    );
  }
}
