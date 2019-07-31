import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  Map<String, dynamic> _data;

  ChatMessage(this._data);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(_data["senderImage"]),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_data["senderName"], style: Theme.of(context).textTheme.subhead),
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  child: _data["image"] != null
                      ? Image.network(_data["image"], width: 250.0)
                      : Text(_data["text"]),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
