abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final Map<String, Map<String, int>> orderForCarusel;
  final Map<String, Map<String, dynamic>> fullOrderForTable;

  OrderLoaded(this.orderForCarusel, this.fullOrderForTable);
}

class OrderError extends OrderState {
  final String message;
  OrderError(this.message);
}
