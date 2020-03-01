import 'package:chat_mate/bloc/chat_bloc.dart';
import 'package:chat_mate/chatAPI/chat.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/chat_event.dart';
import 'bloc/chat_state.dart';

class Details extends StatelessWidget {
  Details(this.clickedName, this.username);
  final String username;
  final String clickedName;
  final TextEditingController _textController = new TextEditingController();
  var chatBloc;
  List<GetMessage> receivedMessages;
  @override
  Widget build(BuildContext context) {
    repeat(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(clickedName),
        ),
        body: BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
          if (state is LoadingState) {
            return Text("Loading....");
          } else if (state is LoadedAllMessagesState) {
            receivedMessages = state.messagesList.messages;
            return showMessages(context, state.messagesList.messages);
          } else if (state is SendMessageState) {
            return showMessages(context, receivedMessages);
          } else
            return Text("");
        }));
  }

  Widget _buildTextComposer(BuildContext context) {
    return new IconTheme(
        data: IconThemeData(),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                decoration:
                    InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () => _submitted(context, _textController.text))),
          ]),
        ));
  }

  Widget showMessages(BuildContext context, List<GetMessage> reqmsg) {
    return Column(children: <Widget>[
      Flexible(child: Builder(builder: (BuildContext context) {
        return ListView.builder(
            itemCount: reqmsg.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(
                  reqmsg[index].rmsg,
                  textAlign: reqmsg[index].from == username
                      ? TextAlign.left
                      : TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            });
      })),
      Divider(height: 1.0),
      Container(
        decoration: new BoxDecoration(color: Theme.of(context).cardColor),
        child: _buildTextComposer(context),
      ),
    ]);
  }

  void _submitted(BuildContext context,String text) {
    if (text == "") return;
    chatBloc = BlocProvider.of<ChatBloc>(context);
    chatBloc.add(SendMessages(username, clickedName, text));
    _textController.clear();
  }

  void repeat(BuildContext context) async {
    for (;;) {
      await Future.delayed(const Duration(seconds: 1), () {
        chatBloc = BlocProvider.of<ChatBloc>(context);
        chatBloc.add(GetAllMessages(username, clickedName));
      });
    }
  }
}
