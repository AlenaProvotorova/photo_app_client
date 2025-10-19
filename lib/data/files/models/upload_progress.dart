class UploadProgress {
  final int currentBatch;
  final int totalBatches;
  final int uploadedFiles;
  final int totalFiles;
  final int failedFiles;

  UploadProgress({
    required this.currentBatch,
    required this.totalBatches,
    required this.uploadedFiles,
    required this.totalFiles,
    this.failedFiles = 0,
  });

  int get remainingFiles => totalFiles - uploadedFiles - failedFiles;
  double get progress =>
      totalFiles > 0 ? (uploadedFiles + failedFiles) / totalFiles : 0.0;
  double get batchProgress =>
      totalBatches > 0 ? currentBatch / totalBatches : 0.0;
}
