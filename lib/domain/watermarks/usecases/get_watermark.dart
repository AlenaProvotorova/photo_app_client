import 'package:dartz/dartz.dart';
import 'package:photo_app/core/usecase/usecase.dart';
import 'package:photo_app/data/watermarks/models/get_watermark_req_params.dart';
import 'package:photo_app/domain/watermarks/repositories/watermark.dart';
import 'package:photo_app/service_locator.dart';

class GetWatermarkUseCase extends Usecase<Either, GetAllWatermarksReqParams> {
  @override
  Future<Either> call({GetAllWatermarksReqParams? params}) async {
    return await sl<WatermarkRepository>().getWatermark(params!);
  }
}
