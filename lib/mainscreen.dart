/*import 'dart:async';
import 'package:grpc/grpc.dart';
import 'chatAPI/chat.pb.dart';
import 'chatAPI/chat.pbgrpc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'msgscreen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  List<String> searchUsersList = [];
  static final channel = ClientChannel(
    '10.0.2.2',
    port: 8080,
    options: const ChannelOptions(
      credentials: ChannelCredentials.insecure(),
    ),
  );
  static final stub = ChatsClient(channel);

  final userName = "Radha";
  List<String> users;
  List<GetMessage> ms = [];
  bool showSearch = false;

  @override
  void initState() {
    super.initState();
    stub.join(new SendJoin()..name = userName);
    repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: showSearch ? Icon(Icons.close) : Icon(Icons.search),
              onPressed: _search,
            ),
          ],
          leading: Builder(builder: (BuildContext context) {
            return Icon(Icons.airplay);
          }),
          title: showSearch
              ? TextField(
                  onChanged: (text) {
                    users = searchUsersList;
                    List<String> tempList = [];
                    for (int i = 0; i < users.length; i++) {
                      if (users[i].contains(text)) {
                        tempList.add(users[i]);
                      }
                    }
                    setState(() {
                      users = tempList;
                    });
                    print(users);
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search...'),
                )
              : Text('ChatMate'),
        ),
        body: Container(
          child: Builder(
            builder: (BuildContext context) {
              if (users == null) {
                return Container(
                  child: Center(
                    child: Text("Loading..."),
                  ),
                );
              } else {
                return ListView.separated(
                  separatorBuilder: (context, index) =>
                      Divider(height: 1.5, color: Colors.grey),
                  itemCount: users.length,
                  itemBuilder: (context, int index) {
                    return ListTile(
                      leading: FlutterLogo(),
                      title: Text(users[index]),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Details(
                                users[index],
                                clickedUserMessages(users[index]),
                                userName,
                                sendMessage),
                          ),
                        );
                      },
                    );
                  },
                );
              }
            },
          ),
        ));
  }

  void getAllMessage() async {
    try {
      final resp = await stub.message(new SendAllMessage()..usr = userName);
      ms = resp.msgs;
    } catch (e) {
      print('Caught error: $e');
    }
  }

  void repeat() async {
    for (;;) {
      await Future.delayed(const Duration(seconds: 1), () async {
        List<String> newUsers = [];
        var response;
        try {
          final resp = await stub.users(new SendUsers());
          for (int i = 0; i < resp.names.length; i++) {
            if (resp.names[i] == userName)
              continue;
            else {
              newUsers.add(resp.names[i]);
            }
          }
          response = await stub.message(new SendAllMessage()..usr = userName);
        } catch (e) {
          print('Caught error: $e');
        }
        setState(() {
          if (!showSearch) users = newUsers;
          ms = response.msgs;
        });
      });
    }
  }

  void sendMessage(String to, String text) async {
    try {
      await stub.send(new SendMessage()
        ..from = userName
        ..to = to
        ..smsg = text);
    } catch (e) {
      print('Caught error: $e');
    }
    print(text);
  }

  void _search() {
    setState(() {
      showSearch = showSearch ? false : true;
      searchUsersList = users;
    });
  }

  List<GetMessage> clickedUserMessages(String clickedName) {
    List<GetMessage> reqmsg = [];
    for (int i = 0; i < ms.length; i++) {
      if (ms[i].to == clickedName || ms[i].from == clickedName) {
        reqmsg.add(ms[i]);
      }
    }
    return reqmsg;
  }
}
*/