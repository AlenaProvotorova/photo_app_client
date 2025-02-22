import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:photo_app/core/network/dio_client.dart';
import 'package:photo_app/data/auth/repositories/auth.dart';
import 'package:photo_app/data/auth/sources/auth_api_service.dart';
import 'package:photo_app/data/files/repositories/files.dart';
import 'package:photo_app/data/files/sourses/files_api_service.dart';
import 'package:photo_app/data/folders/repositories/folders.dart';
import 'package:photo_app/data/folders/sourses/folders_api_service.dart';
import 'package:photo_app/data/image_picker/repositories/mobile_image_picker.dart';
import 'package:photo_app/data/image_picker/repositories/web_image_picker%20copy.dart';
import 'package:photo_app/domain/auth/repositories/auth.dart';
import 'package:photo_app/domain/auth/usecases/signin.dart';
import 'package:photo_app/domain/auth/usecases/signup.dart';
import 'package:photo_app/domain/files/repositories/files.dart';
import 'package:photo_app/domain/files/usecases/get_all_files.dart';
import 'package:photo_app/domain/files/usecases/upload_file.dart';
import 'package:photo_app/domain/folders/repositories/folders.dart';

import 'package:photo_app/domain/folders/usecases/create_folder.dart';
import 'package:photo_app/domain/folders/usecases/delete_folder.dart';
import 'package:photo_app/domain/folders/usecases/get_all_folders.dart';
import 'package:photo_app/domain/image_picker/repositories/image_picker.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerSingleton<DioClient>(DioClient());

  //services
  sl.registerSingleton<AuthApiService>(AuthApiServiceImplementation());
  sl.registerSingleton<FoldersApiService>(FoldersApiServiceImplementation());
  sl.registerSingleton<FilesApiService>(FilesApiServiceImplementation());

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

  //usecases
  //auth
  sl.registerSingleton<SignUpUseCase>(SignUpUseCase());
  sl.registerSingleton<SignInUseCase>(SignInUseCase());
  //folders
  sl.registerSingleton<CreateFolderUseCase>(CreateFolderUseCase());
  sl.registerSingleton<GetAllFoldersUseCase>(GetAllFoldersUseCase());
  sl.registerSingleton<DeleteFolderUseCase>(DeleteFolderUseCase());
  //files
  sl.registerSingleton<UploadFileUseCase>(UploadFileUseCase());
  sl.registerSingleton<GetAllFilesUseCase>(GetAllFilesUseCase());
}
