import 'package:equatable/equatable.dart';
import 'package:photo_app/data/folder_settings/models/folder_settings.dart';

abstract class FolderSettingsState extends Equatable {
  const FolderSettingsState();

  @override
  List<Object?> get props => [];
}

class FolderSettingsInitial extends FolderSettingsState {}

class FolderSettingsLoading extends FolderSettingsState {}

class FolderSettingsLoaded extends FolderSettingsState {
  final FolderSettings folderSettings;

  const FolderSettingsLoaded({required this.folderSettings});

  @override
  List<Object?> get props => [folderSettings];
}

class FolderSettingsError extends FolderSettingsState {
  final String message;

  const FolderSettingsError({required this.message});

  @override
  List<Object?> get props => [message];
}
