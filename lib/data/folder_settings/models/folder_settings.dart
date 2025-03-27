class FolderSettings {
  final int id;
  final int folderId;
  final bool showSelectAllDigital;
  final bool showPhotoOne;
  final bool showPhotoTwo;
  final bool showSize1;
  final bool showSize2;
  final bool showSize3;
  final String? sizeDescription1;
  final String? sizeDescription2;
  final String? sizeDescription3;

  FolderSettings({
    required this.id,
    required this.folderId,
    required this.showSelectAllDigital,
    required this.showPhotoOne,
    required this.showPhotoTwo,
    required this.showSize1,
    required this.showSize2,
    required this.showSize3,
    required this.sizeDescription1,
    required this.sizeDescription2,
    required this.sizeDescription3,
  });

  factory FolderSettings.fromJson(Map<String, dynamic> json) {
    return FolderSettings(
      id: json['id'],
      folderId: json['folderId'],
      showSelectAllDigital: json['showSelectAllDigital'],
      showPhotoOne: json['showPhotoOne'],
      showPhotoTwo: json['showPhotoTwo'],
      showSize1: json['showSize1'],
      showSize2: json['showSize2'],
      showSize3: json['showSize3'],
      sizeDescription1: json['sizeDescription1'],
      sizeDescription2: json['sizeDescription2'],
      sizeDescription3: json['sizeDescription3'],
    );
  }

  dynamic getProperty(String propertyName) {
    switch (propertyName) {
      case 'showSelectAllDigital':
        return showSelectAllDigital;
      case 'showPhotoOne':
        return showPhotoOne;
      case 'showPhotoTwo':
        return showPhotoTwo;
      case 'showSize1':
        return showSize1;
      case 'showSize2':
        return showSize2;
      case 'showSize3':
        return showSize3;
      case 'sizeDescription1':
        return sizeDescription1;
      case 'sizeDescription2':
        return sizeDescription2;
      case 'sizeDescription3':
        return sizeDescription3;

      default:
        return null;
    }
  }
}
