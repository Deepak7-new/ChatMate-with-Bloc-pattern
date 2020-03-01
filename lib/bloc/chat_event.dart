import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}

class GetUsersList extends ChatEvent {
  final String currentUserName;

  const GetUsersList(this.currentUserName);

  @override
  List<Object> get props => [currentUserName];
}

class GetAllMessages extends ChatEvent {
  final String currentUserName;
  final String clickedUserName;

  const GetAllMessages(this.currentUserName, this.clickedUserName);

  @override
  List<Object> get props => [currentUserName, clickedUserName];
}

class SendMessages extends ChatEvent {
  final String senderName;
  final String receiverName;
  final String message;

  const SendMessages(this.senderName, this.receiverName, this.message);

  @override
  List<Object> get props => [senderName, receiverName, message];
}

class SearchName extends ChatEvent{
  final List<String> initialList;
  final String searchText;

  const SearchName(this.initialList, this.searchText);

  @override
  List<Object> get props => [initialList, searchText];

}
