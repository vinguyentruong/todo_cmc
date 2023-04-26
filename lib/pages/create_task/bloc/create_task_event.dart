import 'dart:io';

import 'package:todo_app/common/utils/change_value_event.dart';

import '../../../models/task.dart';

abstract class CreateTaskEvent {}

class CreateTaskChangeInitEvent extends CreateTaskEvent with ChangeValueEvent<Task> {}

class CreateTaskChangeNameEvent extends CreateTaskEvent with ChangeValueEvent<String> {}

class CreateTaskChangeDescEvent extends CreateTaskEvent with ChangeValueEvent<String> {}

class CreateTaskChangeExpiredEvent extends CreateTaskEvent with ChangeValueEvent<DateTime> {}

class CreateTaskChangeImageEvent extends CreateTaskEvent with ChangeValueEvent<File> {}

class CreateTaskChangeUpdateEvent extends CreateTaskEvent {}

class CreateTaskChangeCreateEvent extends CreateTaskEvent {}
