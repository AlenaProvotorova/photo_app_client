import 'package:dio/dio.dart';

class UploadFilesBatchReqParams {
  final FormData formData;
  final int folderId;

  UploadFilesBatchReqParams({
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
