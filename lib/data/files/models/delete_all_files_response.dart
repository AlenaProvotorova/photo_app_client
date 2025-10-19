class DeleteAllFilesResponse {
  final int deletedCount;
  final int totalFiles;
  final String message;

  DeleteAllFilesResponse({
    required this.deletedCount,
    required this.totalFiles,
    required this.message,
  });

  factory DeleteAllFilesResponse.fromJson(Map<String, dynamic> json) {
    return DeleteAllFilesResponse(
      deletedCount: json['deletedCount'] ?? 0,
      totalFiles: json['totalFiles'] ?? 0,
      message: json['message'] ?? 'Files deleted successfully',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deletedCount': deletedCount,
      'totalFiles': totalFiles,
      'message': message,
    };
  }

  @override
  String toString() {
    return 'DeleteAllFilesResponse(deletedCount: $deletedCount, totalFiles: $totalFiles, message: $message)';
  }
}
