class Setting {
  final bool show;
  final String ruName;
  final int? price;

  Setting({
    required this.show,
    required this.ruName,
    this.price,
  });

  factory Setting.fromJson(Map<String, dynamic> json) {
    return Setting(
      show: json['show'],
      ruName: json['ruName'],
      price: json['price'],
    );
  }
}

class FolderSettings {
  final int id;
  final int folderId;
  final Setting showSelectAllDigital;
  final Setting photoOne;
  final Setting photoTwo;
  final Setting photoThree;
  final Setting sizeOne;
  final Setting sizeTwo;
  final Setting sizeThree;

  FolderSettings({
    required this.id,
    required this.folderId,
    required this.showSelectAllDigital,
    required this.photoOne,
    required this.photoTwo,
    required this.photoThree,
    required this.sizeOne,
    required this.sizeTwo,
    required this.sizeThree,
  });

  factory FolderSettings.fromJson(Map<String, dynamic> json) {
    return FolderSettings(
      id: json['id'],
      folderId: json['folderId'],
      showSelectAllDigital: Setting.fromJson(json['showSelectAllDigital']),
      photoOne: Setting.fromJson(json['photoOne']),
      photoTwo: Setting.fromJson(json['photoTwo']),
      photoThree: Setting.fromJson(json['photoThree']),
      sizeOne: Setting.fromJson(json['sizeOne']),
      sizeTwo: Setting.fromJson(json['sizeTwo']),
      sizeThree: Setting.fromJson(json['sizeThree']),
    );
  }

  dynamic getShowProperty(String propertyName) {
    switch (propertyName) {
      case 'showSelectAllDigital':
        return showSelectAllDigital.show;
      case 'photoOne':
        return photoOne.show;
      case 'photoTwo':
        return photoTwo.show;
      case 'photoThree':
        return photoThree.show;
      case 'sizeOne':
        return sizeOne.show;
      case 'sizeTwo':
        return sizeTwo.show;
      case 'sizeThree':
        return sizeThree.show;
      default:
        return null;
    }
  }

  dynamic getRuNameProperty(String propertyName) {
    switch (propertyName) {
      case 'showSelectAllDigital':
        return showSelectAllDigital.ruName;
      case 'photoOne':
        return photoOne.ruName;
      case 'photoTwo':
        return photoTwo.ruName;
      case 'photoThree':
        return photoThree.ruName;
      case 'sizeOne':
        return sizeOne.ruName;
      case 'sizeTwo':
        return sizeTwo.ruName;
      case 'sizeThree':
        return sizeThree.ruName;
      default:
        return null;
    }
  }

  dynamic getPriceProperty(String propertyName) {
    switch (propertyName) {
      case 'showSelectAllDigital':
        return showSelectAllDigital.price;
      case 'photoOne':
        return photoOne.price;
      case 'photoTwo':
        return photoTwo.price;
      case 'photoThree':
        return photoThree.price;
      case 'sizeOne':
        return sizeOne.price;
      case 'sizeTwo':
        return sizeTwo.price;
      case 'sizeThree':
        return sizeThree.price;
      default:
        return null;
    }
  }
}
