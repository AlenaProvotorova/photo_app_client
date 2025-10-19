import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:photo_app/core/network/dio_client.dart';
import 'package:photo_app/data/auth/repositories/auth.dart';
import 'package:photo_app/data/auth/sources/auth_api_service.dart';
import 'package:photo_app/data/clients/repositories/clients.dart';
import 'package:photo_app/data/clients/sourses/clients_api_service.dart';
import 'package:photo_app/data/files/repositories/files.dart';
import 'package:photo_app/data/files/sourses/files_api_service.dart';
import 'package:photo_app/data/folder_settings/repositories/folder_settings.dart';
import 'package:photo_app/data/folder_settings/sourses/folder_settings_api_service.dart';
import 'package:photo_app/data/folders/repositories/folders.dart';
import 'package:photo_app/data/folders/sourses/folders_api_service.dart';
import 'package:photo_app/data/image_picker/repositories/desktop_image_picker.dart';
import 'package:photo_app/data/image_picker/repositories/mobile_image_picker.dart';
import 'package:photo_app/data/image_picker/repositories/web_image_picker.dart';
import 'package:photo_app/data/order/repositories/order.dart';
import 'package:photo_app/data/order/sourses/clients_api_service.dart';
import 'package:photo_app/data/sizes/repositories/size.dart';
import 'package:photo_app/data/sizes/sources/size_api_service.dart';
import 'package:photo_app/data/user/repositories/user.dart';
import 'package:photo_app/data/user/sources/user_api_service.dart';
import 'package:photo_app/data/users/repositories/users.dart';
import 'package:photo_app/data/users/sources/users_api_service.dart';
import 'package:photo_app/data/watermarks/repositories/watermark.dart';
import 'package:photo_app/data/watermarks/sourses/watermark_api_service.dart';
import 'package:photo_app/domain/auth/repositories/auth.dart';
import 'package:photo_app/domain/auth/usecases/signin.dart';
import 'package:photo_app/domain/auth/usecases/signup.dart';
import 'package:photo_app/domain/clients/repositories/clients.dart';
import 'package:photo_app/domain/clients/usecases/get_all_clients.dart';
import 'package:photo_app/domain/clients/usecases/get_client_by_id.dart';
import 'package:photo_app/domain/clients/usecases/update_clients.dart';
import 'package:photo_app/domain/clients/usecases/update_order_album.dart';
import 'package:photo_app/domain/clients/usecases/update_order_digital.dart';
import 'package:photo_app/domain/files/repositories/files.dart';
import 'package:photo_app/domain/files/usecases/delete_all_files.dart';
import 'package:photo_app/domain/files/usecases/get_all_files.dart';
import 'package:photo_app/domain/files/usecases/remove_files.dart';
import 'package:photo_app/domain/files/usecases/upload_file.dart';
import 'package:photo_app/domain/files/usecases/upload_files_batch.dart';
import 'package:photo_app/domain/folder_settings/repositories/folder_settings.dart';
import 'package:photo_app/domain/folder_settings/usecases/get_folder_settings.dart';
import 'package:photo_app/domain/folder_settings/usecases/update_folder_settings.dart';
import 'package:photo_app/domain/folders/repositories/folders.dart';
import 'package:photo_app/domain/folders/usecases/create_folder.dart';
import 'package:photo_app/domain/folders/usecases/delete_folder.dart';
import 'package:photo_app/domain/folders/usecases/edit_folder.dart';
import 'package:photo_app/domain/folders/usecases/get_all_folders.dart';
import 'package:photo_app/domain/image_picker/repositories/image_picker.dart';
import 'package:photo_app/domain/order/repositories/order.dart';
import 'package:photo_app/domain/order/usecases/get_order.dart';
import 'package:photo_app/domain/order/usecases/update_order.dart';
import 'package:photo_app/domain/sizes/repositories/sizes.dart';
import 'package:photo_app/domain/sizes/usecases/get_sizes.dart';
import 'package:photo_app/domain/user/repositories/user.dart';
import 'package:photo_app/domain/user/usecases/get_user.dart';
import 'package:photo_app/domain/users/repositories/users.dart';
import 'package:photo_app/domain/users/usecases/get_all_users.dart';
import 'package:photo_app/domain/users/usecases/update_user_is_admin.dart';
import 'package:photo_app/domain/watermarks/repositories/watermark.dart';
import 'package:photo_app/domain/watermarks/usecases/get_watermark.dart';
import 'package:photo_app/domain/watermarks/usecases/remove_watermark.dart';
import 'package:photo_app/domain/watermarks/usecases/upload_watermark.dart';
import 'package:photo_app/presentation/folders_storage/pages/folders_storage/bloc/folder_bloc.dart';
import 'package:photo_app/entities/users/bloc/users_bloc.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerSingleton<DioClient>(DioClient());

  //services
  sl.registerSingleton<AuthApiService>(AuthApiServiceImplementation());
  sl.registerSingleton<UserApiService>(UserApiServiceImplementation());
  sl.registerSingleton<FoldersApiService>(FoldersApiServiceImplementation());
  sl.registerSingleton<FilesApiService>(FilesApiServiceImplementation());
  sl.registerSingleton<ClientsApiService>(ClientsApiServiceImplementation());
  sl.registerSingleton<SizeApiService>(SizeApiServiceImplementation());
  sl.registerSingleton<OrderApiService>(OrderApiServiceImplementation());
  sl.registerSingleton<FolderSettingsApiService>(
      FolderSettingsApiServiceImplementation());
  sl.registerSingleton<WatermarkApiService>(
      WatermarkApiServiceImplementation());
  sl.registerSingleton<UsersApiService>(UsersApiServiceImplementation());

  //repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImplementation());
  sl.registerSingleton<FoldersRepository>(FoldersRepositoryImplementation());
  sl.registerSingleton<FilesRepository>(FilesRepositoryImplementation());
  if (kIsWeb) {
    sl.registerSingleton<ImagePickerRepository>(
        WebImagePickerRepositoryImplementation());
  } else if (Platform.isAndroid || Platform.isIOS) {
    sl.registerSingleton<ImagePickerRepository>(
        MobileImagePickerRepositoryImplementation());
  } else {
    sl.registerSingleton<ImagePickerRepository>(
        DesktopImagePickerRepositoryImplementation());
  }
  sl.registerSingleton<UserRepository>(UserRepositoryImplementation());
  sl.registerSingleton<ClientsRepository>(ClientsRepositoryImplementation());
  sl.registerSingleton<SizeRepository>(SizeRepositoryImplementation());
  sl.registerSingleton<OrderRepository>(OrderRepositoryImplementation());
  sl.registerSingleton<FolderSettingsRepository>(
      FolderSettingsRepositoryImplementation());
  sl.registerSingleton<WatermarkRepository>(
      WatermarkRepositoryImplementation());
  sl.registerSingleton<UsersRepository>(UsersRepositoryImplementation());

  //usecases
  //auth
  sl.registerSingleton<SignUpUseCase>(SignUpUseCase());
  sl.registerSingleton<SignInUseCase>(SignInUseCase());
  //user
  sl.registerSingleton<GetUserUseCase>(GetUserUseCase());
  //folders
  sl.registerSingleton<CreateFolderUseCase>(CreateFolderUseCase());
  sl.registerSingleton<GetAllFoldersUseCase>(GetAllFoldersUseCase());
  sl.registerSingleton<DeleteFolderUseCase>(DeleteFolderUseCase());
  sl.registerSingleton<EditFolderUseCase>(EditFolderUseCase());
  //files
  sl.registerSingleton<UploadFileUseCase>(UploadFileUseCase());
  sl.registerSingleton<UploadFilesBatchUseCase>(UploadFilesBatchUseCase());
  sl.registerSingleton<GetAllFilesUseCase>(GetAllFilesUseCase());
  sl.registerSingleton<RemoveFilesUseCase>(RemoveFilesUseCase());
  sl.registerSingleton<DeleteAllFilesUseCase>(DeleteAllFilesUseCase());
  //clients
  sl.registerSingleton<GetAllClientsUseCase>(GetAllClientsUseCase());
  sl.registerSingleton<UpdateClientsUseCase>(UpdateClientsUseCase());
  sl.registerSingleton<UpdateOrderDigitalUseCase>(UpdateOrderDigitalUseCase());
  sl.registerSingleton<UpdateOrderAlbumUseCase>(UpdateOrderAlbumUseCase());
  sl.registerSingleton<GetClientByIdUseCase>(GetClientByIdUseCase());
  //sizes
  sl.registerSingleton<GetSizesUseCase>(GetSizesUseCase());
  //orders
  sl.registerSingleton<GetOrderUseCase>(GetOrderUseCase());
  sl.registerSingleton<CreateOrUpdateOrderUseCase>(
      CreateOrUpdateOrderUseCase());
  //folder settings
  sl.registerSingleton<GetFolderSettingsUseCase>(GetFolderSettingsUseCase());
  sl.registerSingleton<UpdateFolderSettingsUseCase>(
      UpdateFolderSettingsUseCase());
  //watermarks
  sl.registerSingleton<UploadWatermarkUseCase>(UploadWatermarkUseCase());
  sl.registerSingleton<GetWatermarkUseCase>(GetWatermarkUseCase());
  sl.registerSingleton<RemoveWatermarkUseCase>(RemoveWatermarkUseCase());
  //users
  sl.registerSingleton<GetAllUsersUseCase>(GetAllUsersUseCase());
  sl.registerSingleton<UpdateUserIsAdminUseCase>(UpdateUserIsAdminUseCase());

  //bloc
  sl.registerFactory(() => FolderBloc());
  sl.registerFactory(() => UsersBloc());
}
