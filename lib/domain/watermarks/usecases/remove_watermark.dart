import 'package:dartz/dartz.dart';
import 'package:photo_app/core/usecase/usecase.dart';
import 'package:photo_app/data/watermarks/models/remove_watermark_req_params.dart';
import 'package:photo_app/domain/watermarks/repositories/watermark.dart';
import 'package:photo_app/service_locator.dart';

class RemoveWatermarkUseCase extends Usecase<Either, RemoveWatermarkReqParams> {
  @override
  Future<Either> call({RemoveWatermarkReqParams? params}) async {
    return await sl<WatermarkRepository>().removeWatermark(params!);
  }
}
