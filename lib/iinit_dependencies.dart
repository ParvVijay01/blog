import 'package:get_it/get_it.dart';
import 'package:practice/core/secrets/app_secrets.dart';
import 'package:practice/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:practice/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:practice/features/auth/domain/repository/auth_repository.dart';
import 'package:practice/features/auth/domain/usecases/user_sign_up.dart';
import 'package:practice/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependecies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabasaeUrl,
    anonKey: AppSecrets.anonKey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserSignUp(
      serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
    ),
  );
}
