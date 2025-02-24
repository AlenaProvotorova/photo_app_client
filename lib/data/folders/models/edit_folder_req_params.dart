class EditFolderReqParams {
  final int id;
  final String? name;

  EditFolderReqParams({
    required this.id,
    this.name,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (name != null) map['name'] = name;
    return map;
  }
}
