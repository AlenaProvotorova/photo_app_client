import 'package:dartz/dartz.dart';
import 'package:photo_app/data/watermarks/models/get_watermark_req_params.dart';
import 'package:photo_app/data/watermarks/models/remove_watermark_req_params.dart';
import 'package:photo_app/data/watermarks/models/upload_watermark_req_params.dart';

abstract class WatermarkRepository {
  Future<Either> uploadWatermark(UploadWatermarkReqParams params);
  Future<Either> getWatermark(GetAllWatermarksReqParams params);
  Future<Either> removeWatermark(RemoveWatermarkReqParams params);
}
