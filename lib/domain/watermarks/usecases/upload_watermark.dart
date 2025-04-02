import 'package:dartz/dartz.dart';
import 'package:photo_app/core/usecase/usecase.dart';
import 'package:photo_app/data/watermarks/models/upload_watermark_req_params.dart';
import 'package:photo_app/domain/watermarks/repositories/watermark.dart';
import 'package:photo_app/service_locator.dart';

class UploadWatermarkUseCase extends Usecase<Either, UploadWatermarkReqParams> {
  @override
  Future<Either> call({UploadWatermarkReqParams? params}) async {
    return await sl<WatermarkRepository>().uploadWatermark(params!);
  }
}
