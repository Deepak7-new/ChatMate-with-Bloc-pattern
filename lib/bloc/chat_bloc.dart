import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_mate/chatAPI/chat.pb.dart';
import 'package:chat_mate/repository/chat_repository.dart';
import './bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final AbstractChatRepository chatRepository;
  List<String> usersList = [];
  List<GetMessage> userMessages = [];

  ChatBloc(this.chatRepository);

  @override
  ChatState get initialState => InitialState();

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    //yield LoadingState();

    if (event is GetUsersList) {
      try {
        final users = await chatRepository.fetchUsers(event.currentUserName);
        if (users.users.length > usersList.length) {
          usersList = users.users;
          print("--------");
          yield LoadedUsersState(users);
        }
      } on NetworkError {
        yield ChatError("Couldn't fetch users. Is the device online?");
      }
    } else if (event is SearchName) {
      List<String> tempList = [];
      if (event.searchText != null) {
        for (int i = 0; i < event.initialList.length; i++) {
          if (event.initialList[i].contains(event.searchText)) {
            tempList.add(event.initialList[i]);
          }
        }
        print(tempList);
        yield SearchState(tempList);
      } else {
        yield SearchState(event.initialList);
      }
    } else if (event is GetAllMessages) {
      try {
        final messages = await chatRepository.fetchMessages(
            event.currentUserName, event.clickedUserName);
        if (messages.messages.length > userMessages.length) {
          userMessages = messages.messages;
          yield LoadedAllMessagesState(messages);
        }
      } on NetworkError {
        yield ChatError("Couldn't fetch messages. Is the device online?");
      }
    } else if (event is SendMessages) {
      try {
        await chatRepository.postMessages(
            event.senderName, event.receiverName, event.message);
        yield SendMessageState();
      } on NetworkError {
        yield ChatError("Couldn't fetch messages. Is the device online?");
      }
    }
  }
}
