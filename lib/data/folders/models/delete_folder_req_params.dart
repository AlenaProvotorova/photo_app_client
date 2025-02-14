class DeleteFolderReqParams {
  final int id;

  DeleteFolderReqParams({
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
    };
  }
}
