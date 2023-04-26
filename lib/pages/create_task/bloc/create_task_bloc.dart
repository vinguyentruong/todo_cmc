import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_app/common/api_client/data_state.dart';
import 'package:todo_app/common/enums/status.dart';
import 'package:todo_app/common/event/event_bus_mixin.dart';
import 'package:todo_app/common/utils/photo_utils.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/pages/helper/event_bus/task_events.dart';
import 'package:todo_app/repositories/task_repository.dart';
import 'package:uuid/uuid.dart';

import 'create_task_event.dart';
import 'create_task_state.dart';
import 'package:image/image.dart' as img;

@Injectable()
class CreateTaskBloc extends Bloc<CreateTaskEvent, CreateTaskState> with EventBusMixin {
  CreateTaskBloc(this._taskRepository) : super(CreateTaskState());

  final TaskRepository _taskRepository;

  @override
  Stream<CreateTaskState> mapEventToState(CreateTaskEvent event) async* {
    if (event is CreateTaskChangeInitEvent) {
      yield state.copyWith(
        task: event.value,
        name: event.value?.name,
        desc: event.value?.desc,
      );
    } else if (event is CreateTaskChangeNameEvent) {
      yield state.copyWith(name: event.value);
    } else if (event is CreateTaskChangeDescEvent) {
      yield state.copyWith(desc: event.value);
    } else if (event is CreateTaskChangeExpiredEvent) {
      yield state.copyWith(expiredTime: event.value);
    } else if (event is CreateTaskChangeImageEvent) {
      yield state.copyWith(image: event.value);
    } else if (event is CreateTaskChangeUpdateEvent) {
      yield* _updateTask();
    } else if (event is CreateTaskChangeCreateEvent) {
      yield* _createTask();
    }
  }

  Stream<CreateTaskState> _updateTask() async* {
    yield state.copyWith(status: RequestStatus.requesting);

    String? base64Image = await _getBase64Image(state.image) ?? state.task?.image;
    final task = Task(
      id: state.task?.id,
      name: state.name,
      desc: state.desc,
      createAt: state.task?.createAt,
      expiredAt: state.expiredTime ?? state.task?.expiredAt,
      status: state.task?.status,
      image: base64Image,
    );
    try {
      final result = await _taskRepository.updateTask(task);
      if (result is DataSuccess) {
        yield state.copyWith(status: RequestStatus.success);
        shareEvent(OnUpdateTaskEvent(task));
      } else {
        yield state.copyWith(status: RequestStatus.failed, message: result.message);
      }
    } catch (e) {
      yield state.copyWith(status: RequestStatus.failed, message: e.toString());
    }
  }

  Stream<CreateTaskState> _createTask() async* {
    yield state.copyWith(status: RequestStatus.requesting);
    String? base64Image = await _getBase64Image(state.image);
    final task = Task(
      id: Uuid().v1(),
      name: state.name,
      desc: state.desc,
      createAt: DateTime.now(),
      expiredAt: state.expiredTime,
      status: TaskStatus.inprogress,
      image: base64Image,
    );
    try {
      final result = await _taskRepository.createTask(task);
      if (result is DataSuccess) {
        yield state.copyWith(status: RequestStatus.success);
        shareEvent(OnCreateTaskEvent(task));
      } else {
        yield state.copyWith(status: RequestStatus.failed);
      }
    } catch (e) {
      yield state.copyWith(status: RequestStatus.failed, message: e.toString());
    }
  }

  Future<String?> _getBase64Image(File? file) async {
    final Uint8List? imageBytes = file?.readAsBytesSync();
    final reduceSizeImage = await reduceImageQualityAndSize(imageBytes);
    String? base64Image = reduceSizeImage == null ? null : base64Encode(reduceSizeImage);
    return base64Image;
  }
}
