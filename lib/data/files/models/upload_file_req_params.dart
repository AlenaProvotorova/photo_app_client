import 'package:dio/dio.dart';

class UploadFileReqParams {
  final FormData formData;
  final int folderId;

  UploadFileReqParams({
    required this.formData,
    required this.folderId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'formData': formData,
      'folderId': folderId,
    };
  }
}
