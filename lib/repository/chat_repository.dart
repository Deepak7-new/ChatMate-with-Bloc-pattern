import 'package:chat_mate/model/messages.dart';
import 'package:chat_mate/model/users.dart';
import 'dart:async';
import 'package:grpc/grpc.dart';
import 'package:chat_mate/chatAPI/chat.pb.dart';
import 'package:chat_mate/chatAPI/chat.pbgrpc.dart';

abstract class AbstractChatRepository{
Future<Users> fetchUsers(String currentUserName);
Future<Messages> fetchMessages(String currentUserName, String clickedUserName);
Future<void> postMessages(String sender, String receiver, String message);
}

class ChatRepository extends AbstractChatRepository{
  List<GetMessage> fetchedMessages;
  static final channel = ClientChannel(
    '10.0.2.2',
    port: 8080,
    options: const ChannelOptions(
      credentials: ChannelCredentials.insecure(),
    ),
  );
  static final stub = ChatsClient(channel);

  @override
  Future<Messages> fetchMessages(String currentUserName, String clickedUserName) async {
    List<GetMessage>  reqmsg= [];

    try {
      final response = await stub.message(new SendAllMessage()..usr = currentUserName);
      fetchedMessages = response.msgs;
    } catch (e) {
      print('Caught error: $e');
    }
    for (int i = 0; i < fetchedMessages.length; i++) {
      if (fetchedMessages[i].to == clickedUserName || fetchedMessages[i].from == clickedUserName) {
        reqmsg.add(fetchedMessages[i]);
      }
    }
    return Messages(reqmsg);
  }

  @override
  Future<Users> fetchUsers(String currentUserName) async {
    List<String> usersList = [];
    try {
      final response = await stub.users(new SendUsers());
      for (int i = 0; i < response.names.length; i++) {
        if (response.names[i] == currentUserName)
          continue;
        else {
          usersList.add(response.names[i]);
        }
      }
    } catch (e) {
      throw NetworkError();
    }
    return Users(usersList);
  }

  @override
  Future<void> postMessages(String sender, String receiver, String message) async {
    try {
      await stub.send(new SendMessage()
        ..from = sender
        ..to = receiver
        ..smsg = message);
    } catch (e) {
      print('Caught error: $e');
    }
    return ;
  }
}

class NetworkError extends Error{
//  final dynamic error;
//  NetworkError(this.error);
}