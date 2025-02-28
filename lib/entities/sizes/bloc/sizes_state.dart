import 'package:photo_app/data/sizes/models/size.dart';

abstract class SizesState {}

class SizesInitial extends SizesState {}

class SizesLoading extends SizesState {}

class SizesLoaded extends SizesState {
  final List<Size> sizes;
  SizesLoaded(this.sizes);
}

class SizesError extends SizesState {
  final String message;
  SizesError(this.message);
}
