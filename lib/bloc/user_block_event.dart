part of 'user_block_bloc.dart';

@immutable
sealed class UserBlockEvent {}

class FetchUser extends UserBlockEvent {}
