// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i5;

import '../configs/build_config.dart' as _i3;
import '../data/local/datasource/task_local_datasource.dart' as _i7;
import '../data/local/keychain/shared_prefs.dart' as _i6;
import '../data/task/task_service.dart' as _i8;
import '../pages/complete/bloc/complete_cubit.dart' as _i11;
import '../pages/create_task/bloc/create_task_bloc.dart' as _i12;
import '../pages/inprogress/bloc/inprogress_cubit.dart' as _i13;
import '../pages/main/bloc/main_cubit.dart' as _i4;
import '../pages/todo/bloc/todo_cubit.dart' as _i10;
import '../repositories/task_repository.dart' as _i9;
import 'modules.dart' as _i14; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  final injectableModule = _$InjectableModule();
  gh.lazySingleton<_i3.BuildConfig>(() => _i3.BuildConfig());
  gh.factory<_i4.MainCubit>(() => _i4.MainCubit());
  await gh.factoryAsync<_i5.SharedPreferences>(
    () => injectableModule.prefs,
    preResolve: true,
  );
  gh.lazySingleton<_i6.SharedPrefs>(
      () => _i6.SharedPrefs(get<_i5.SharedPreferences>()));
  gh.lazySingleton<_i7.TaskLocalDatasource>(
      () => _i7.TaskLocalDatasourceImpl(get<_i6.SharedPrefs>()));
  gh.lazySingleton<_i8.TaskService>(() => _i8.TaskServiceImpl());
  gh.lazySingleton<_i9.TaskRepository>(() => _i9.TaskRepositoryImpl(
        userService: get<_i8.TaskService>(),
        taskLocalDatasource: get<_i7.TaskLocalDatasource>(),
      ));
  gh.factory<_i10.TodoCubit>(() => _i10.TodoCubit(get<_i9.TaskRepository>()));
  gh.factory<_i11.CompleteCubit>(
      () => _i11.CompleteCubit(get<_i9.TaskRepository>()));
  gh.factory<_i12.CreateTaskBloc>(
      () => _i12.CreateTaskBloc(get<_i9.TaskRepository>()));
  gh.factory<_i13.InProgressCubit>(
      () => _i13.InProgressCubit(get<_i9.TaskRepository>()));
  return get;
}

class _$InjectableModule extends _i14.InjectableModule {}
