import 'package:chat_mate/bloc/bloc.dart';
import 'package:chat_mate/repository/chat_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      home: BlocProvider(
        builder: (context) => ChatBloc(ChatRepository()),
        child: MyHomePage(),
      ),
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
  bool showSearch = false;
  var chatBloc;
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
                    chatBloc = BlocProvider.of<ChatBloc>(context);
                    chatBloc.add(SearchName(users, text));
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search), hintText: 'Search...'),
                )
              : Text('ChatMate'),
        ),
        body: Container(
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state is InitialState) {
                return Center(
                    child: Text(
                  "Loading..",
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 1.5),
                ));
              } else if (state is LoadingState) {
                return Text("Loading....");
              } else if (state is LoadedUsersState) {
                users = state.usersList.users;
                return showUsers(context, state.usersList.users);
              } else if (state is SearchState) {
                return showUsers(context, state.filteredList);
              } else if (state is ChatError) {
                return Text("error");
              } else {
                print("else");
                return showUsers(context, users);
              }
            },
          ),
        ));
  }

  Widget showUsers(BuildContext context, List<String> listOfUsers) {
    return ListView.separated(
      separatorBuilder: (context, index) =>
          Divider(height: 1.5, color: Colors.grey),
      itemCount: listOfUsers.length,
      itemBuilder: (context, int index) {
        return ListTile(
          leading: FlutterLogo(),
          title: Text(listOfUsers[index]),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<ChatBloc>(context),
                        child: Details(
                          listOfUsers[index],
                          userName,
                        ),
                      )),
            );
          },
        );
      },
    );
  }

  void repeat() async {
    for (;;) {
      await Future.delayed(const Duration(seconds: 1), () {
        chatBloc = BlocProvider.of<ChatBloc>(context);
        chatBloc.add(GetUsersList(userName));
      });
    }
  }

  void _search() {
    chatBloc = BlocProvider.of<ChatBloc>(context);
    setState(() {
      showSearch = showSearch ? false : true;
      chatBloc.add(SearchName(users, null));
    });
  }

  @override
  void dispose() {
    super.dispose();
    chatBloc.dispose();
  }
}
