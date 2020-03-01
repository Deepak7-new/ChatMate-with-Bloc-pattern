import 'package:equatable/equatable.dart';

class Users extends Equatable {
  final List<String> users;

  Users(this.users);

  @override
  List<Object> get props => users;

}