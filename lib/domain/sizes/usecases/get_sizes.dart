import 'package:dartz/dartz.dart';
import 'package:photo_app/core/usecase/usecase.dart';
import 'package:photo_app/domain/sizes/repositories/sizes.dart';
import 'package:photo_app/service_locator.dart';

class GetSizesUseCase extends Usecase<Either, void> {
  @override
  Future<Either> call({void params}) async {
    return await sl<SizeRepository>().getSizes();
  }
}
