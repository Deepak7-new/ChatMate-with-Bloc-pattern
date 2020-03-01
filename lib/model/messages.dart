import 'package:chat_mate/chatAPI/chat.pb.dart';
import 'package:equatable/equatable.dart';

class Messages extends Equatable {
  final List<GetMessage> messages;

 Messages(this.messages);

  @override
  List<Object> get props => messages;

}