import 'package:dartz/dartz.dart';
import 'package:photo_app/data/watermarks/models/get_watermark_req_params.dart';
import 'package:photo_app/data/watermarks/models/remove_watermark_req_params.dart';
import 'package:photo_app/data/watermarks/models/upload_watermark_req_params.dart';
import 'package:photo_app/data/watermarks/sourses/watermark_api_service.dart';
import 'package:photo_app/domain/watermarks/repositories/watermark.dart';
import 'package:photo_app/service_locator.dart';

class WatermarkRepositoryImplementation extends WatermarkRepository {
  @override
  Future<Either> uploadWatermark(UploadWatermarkReqParams params) async {
    return await sl<WatermarkApiService>().uploadWatermark(params);
  }

  @override
  Future<Either> getWatermark(GetAllWatermarksReqParams params) async {
    return await sl<WatermarkApiService>().getWatermark(params);
  }

  @override
  Future<Either> removeWatermark(RemoveWatermarkReqParams params) async {
    return await sl<WatermarkApiService>().removeWatermark(params);
  }
}
