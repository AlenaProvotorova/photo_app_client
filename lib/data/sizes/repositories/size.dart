// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:photo_app/data/sizes/sources/size_api_service.dart';
import 'package:photo_app/domain/sizes/repositories/sizes.dart';
import 'package:photo_app/service_locator.dart';

class SizeRepositoryImplementation extends SizeRepository {
  @override
  Future<Either> getSizes() async {
    return await sl<SizeApiService>().getSizes();
  }
}
