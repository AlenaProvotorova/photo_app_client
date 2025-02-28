import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:photo_app/core/network/dio_client.dart';
import 'package:photo_app/data/auth/repositories/auth.dart';
import 'package:photo_app/data/auth/sources/auth_api_service.dart';
import 'package:photo_app/data/clients/repositories/clients.dart';
import 'package:photo_app/data/clients/sourses/clients_api_service.dart';
import 'package:photo_app/data/files/repositories/files.dart';
import 'package:photo_app/data/files/sourses/files_api_service.dart';
import 'package:photo_app/data/folders/repositories/folders.dart';
import 'package:photo_app/data/folders/sourses/folders_api_service.dart';
import 'package:photo_app/data/image_picker/repositories/mobile_image_picker.dart';
import 'package:photo_app/data/image_picker/repositories/web_image_picker.dart';
import 'package:photo_app/data/sizes/repositories/size.dart';
import 'package:photo_app/data/sizes/sources/size_api_service.dart';
import 'package:photo_app/data/user/repositories/user.dart';
import 'package:photo_app/data/user/sources/user_api_service.dart';
import 'package:photo_app/domain/auth/repositories/auth.dart';
import 'package:photo_app/domain/auth/usecases/signin.dart';
import 'package:photo_app/domain/auth/usecases/signup.dart';
import 'package:photo_app/domain/clients/repositories/clients.dart';
import 'package:photo_app/domain/clients/usecases/get_all_clients.dart';
import 'package:photo_app/domain/clients/usecases/update_clients.dart';
import 'package:photo_app/domain/files/repositories/files.dart';
import 'package:photo_app/domain/files/usecases/get_all_files.dart';
import 'package:photo_app/domain/files/usecases/remove_files.dart';
import 'package:photo_app/domain/files/usecases/upload_file.dart';
import 'package:photo_app/domain/folders/repositories/folders.dart';

import 'package:photo_app/domain/folders/usecases/create_folder.dart';
import 'package:photo_app/domain/folders/usecases/delete_folder.dart';
import 'package:photo_app/domain/folders/usecases/edit_folder.dart';
import 'package:photo_app/domain/folders/usecases/get_all_folders.dart';
import 'package:photo_app/domain/image_picker/repositories/image_picker.dart';
import 'package:photo_app/domain/sizes/repositories/sizes.dart';
import 'package:photo_app/domain/sizes/usecases/get_sizes.dart';
import 'package:photo_app/domain/user/repositories/user.dart';
import 'package:photo_app/domain/user/usecases/get_user.dart';
import 'package:photo_app/presentation/folders_storage/pages/folders_storage/bloc/folder_bloc.dart';

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

  //repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImplementation());
  sl.registerSingleton<FoldersRepository>(FoldersRepositoryImplementation());
  sl.registerSingleton<FilesRepository>(FilesRepositoryImplementation());
  if (kIsWeb) {
    sl.registerSingleton<ImagePickerRepository>(
        WebImagePickerRepositoryImplementation());
  } else {
    sl.registerSingleton<ImagePickerRepository>(
        MobileImagePickerRepositoryImplementation());
  }
  sl.registerSingleton<UserRepository>(UserRepositoryImplementation());
  sl.registerSingleton<ClientsRepository>(ClientsRepositoryImplementation());
  sl.registerSingleton<SizeRepository>(SizeRepositoryImplementation());

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
  sl.registerSingleton<GetAllFilesUseCase>(GetAllFilesUseCase());
  sl.registerSingleton<RemoveFilesUseCase>(RemoveFilesUseCase());
  //clients
  sl.registerSingleton<GetAllClientsUseCase>(GetAllClientsUseCase());
  sl.registerSingleton<UpdateClientsUseCase>(UpdateClientsUseCase());
  //sizes
  sl.registerSingleton<GetSizesUseCase>(GetSizesUseCase());

  //bloc
  sl.registerFactory(() => FolderBloc());
}
