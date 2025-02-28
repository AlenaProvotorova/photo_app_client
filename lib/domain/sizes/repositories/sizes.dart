import 'package:dartz/dartz.dart';

abstract class SizeRepository {
  Future<Either> getSizes();
}
