import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'main_state.dart';

@injectable
class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainState());
}
