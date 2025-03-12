import 'package:dartz/dartz.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final Order order;
  OrderLoaded(this.order);
}

class OrderError extends OrderState {
  final String message;
  OrderError(this.message);
}
