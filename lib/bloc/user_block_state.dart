part of 'user_block_bloc.dart';

@immutable
sealed class UserBlockState {}

final class UserBlockInitial extends UserBlockState {}

final class UserBlockLoading extends UserBlockState {}

final class UserBlockFailure extends UserBlockState {}

final class UserBlockSuccess extends UserBlockState {
  final user;

  UserBlockSuccess(this.user);

  @override
  List<Object> get props => [user];
}
