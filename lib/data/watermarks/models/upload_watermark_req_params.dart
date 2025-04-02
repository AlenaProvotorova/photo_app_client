import 'package:dio/dio.dart';

class UploadWatermarkReqParams {
  final FormData formData;
  final int userId;

  UploadWatermarkReqParams({
    required this.formData,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'formData': formData,
      'userId': userId,
    };
  }
}
