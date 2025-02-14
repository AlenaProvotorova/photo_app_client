class CreateFolderReqParams {
  final String name;

  CreateFolderReqParams({
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
    };
  }
}
