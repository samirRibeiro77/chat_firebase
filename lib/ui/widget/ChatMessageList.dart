import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'ChatMessage.dart';

class ChatMessageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection("messages").snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    List r = snapshot.data.documents.reversed.toList();
                    return ChatMessage(r[index].data);
                  });
          }
        });
  }
}
