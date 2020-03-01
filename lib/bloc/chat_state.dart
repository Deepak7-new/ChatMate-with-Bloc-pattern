import 'package:chat_mate/model/messages.dart';
import 'package:chat_mate/model/users.dart';
import 'package:equatable/equatable.dart';

abstract class ChatState extends Equatable {
  const ChatState();
}

class InitialState extends ChatState {
  @override
  List<Object> get props => [];
}

class LoadingState extends ChatState{
  @override
  List<Object> get props => null;
}

class LoadedUsersState extends ChatState{
  final Users usersList;

  LoadedUsersState(this.usersList);

  @override
  List<Object> get props => [usersList];

}

class LoadedAllMessagesState extends ChatState{
  final Messages messagesList;

  LoadedAllMessagesState(this.messagesList);

  @override
  List<Object> get props => [messagesList];
}

class SearchState extends ChatState {
  final List<String> filteredList;

  SearchState(this.filteredList);

  @override
  List<Object> get props => [filteredList];

}

class SendMessageState extends ChatState {
  @override
  List<Object> get props => [];
}
class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);
  @override
  List<Object> get props => [message];
}