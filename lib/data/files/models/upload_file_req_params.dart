import 'package:dio/dio.dart';

class UploadFileReqParams {
  final FormData formData;

  UploadFileReqParams({
    required this.formData,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'formData': formData,
    };
  }
}
