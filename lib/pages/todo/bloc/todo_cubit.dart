import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_app/common/enums/data_source_status.dart';
import 'package:todo_app/common/enums/status.dart';
import 'package:todo_app/common/event/event_bus_mixin.dart';
import 'package:todo_app/pages/helper/event_bus/task_events.dart';
import 'package:todo_app/repositories/task_repository.dart';

import '../../../common/api_client/data_state.dart';
import '../../../models/task.dart';
import 'todo_state.dart';

@Injectable()
class TodoCubit extends Cubit<TodoState> with EventBusMixin {
  TodoCubit(this._taskRepository) : super(const TodoState()) {
    listenEvent<OnCreateTaskEvent>((_) => _getTasks());
    listenEvent<OnUpdateTaskEvent>((_) => _getTasks());
    listenEvent<OnDeleteTaskEvent>((_) => _getTasks());
  }

  TaskRepository _taskRepository;

  Future<void> initData() async {
    _getTasks();
  }

  Future<void> _getTasks() async {
    emit(state.copyWith(dataStatus: DataSourceStatus.loading));
    try {
      final result = await _taskRepository.getCachedTasks();
      if (result != null) {
        emit(state.copyWith(tasks: result, dataStatus: DataSourceStatus.refreshing));
      } else {
        emit(state.copyWith(dataStatus: DataSourceStatus.failed));
      }
      await _fetchTasks();
    } catch (e) {
      emit(state.copyWith(dataStatus: DataSourceStatus.failed));
    }
  }

  Future<void> _fetchTasks() async {
    emit(state.copyWith(dataStatus: DataSourceStatus.refreshing));
    try {
      final result = await _taskRepository.getTasks();
      if (result is DataSuccess) {
        emit(state.copyWith(tasks: result.data, dataStatus: (result.data?.isNotEmpty ?? false) ? DataSourceStatus.success : DataSourceStatus.empty));
      } else {
        emit(state.copyWith(dataStatus: DataSourceStatus.failed));
      }
    } catch (e) {
      emit(state.copyWith(dataStatus: DataSourceStatus.failed));
    }
  }

  Future<void> onSearchTasks(String? text) async {
    if ((text ?? '').isEmpty) {
      await _fetchTasks();
      return;
    }
    emit(state.copyWith(dataStatus: DataSourceStatus.refreshing));
    try {
      final result = await _taskRepository.searchTasks(text!);
      if (result is DataSuccess) {
        emit(state.copyWith(tasks: result.data, dataStatus: (result.data?.isNotEmpty ?? false) ? DataSourceStatus.success : DataSourceStatus.empty));
      } else {
        emit(state.copyWith(dataStatus: DataSourceStatus.failed));
      }
    } catch (e) {
      emit(state.copyWith(dataStatus: DataSourceStatus.failed));
    }
  }

  Future<void> onRefresh() async {
    _fetchTasks();
  }

  Future<void> deleteTask(Task? task) async {
    if (task?.id == null) {
      return;
    }
    emit(state.copyWith(status: RequestStatus.requesting));
    try {
      final result = await _taskRepository.deleteTask(task!.id!);
      if (result is DataSuccess) {
        final newTasks = state.tasks?..removeWhere((element) => element.id == task.id);
        emit(state.copyWith(
            tasks: newTasks,
            status: RequestStatus.success,
          dataStatus: (newTasks?.isNotEmpty ?? false) ? DataSourceStatus.success : DataSourceStatus.empty
        ));
        shareEvent(OnDeleteTaskEvent(task));
      } else {
        emit(state.copyWith(status: RequestStatus.failed, message: result.message,));
      }
    } catch (e) {
      emit(state.copyWith(status: RequestStatus.failed, message: e.toString()));
    }
  }

   Future<void> updateTaskStatus(Task? task, bool value) async {
     if (task?.id == null) {
       return;
     }
     emit(state.copyWith(status: RequestStatus.requesting));
    final newTask = Task(
      id: task?.id,
      name: task?.name,
      desc: task?.desc,
      createAt: task?.createAt,
      expiredAt: task?.expiredAt,
      status: value ? TaskStatus.complete : TaskStatus.inprogress,
      image: task?.image,
    );
    try {
      final result = await _taskRepository.updateTask(newTask);
      if (result is DataSuccess) {
        final List<Task> newTasks = List.from(state.tasks ?? []);
        final index = newTasks.indexWhere((element) => element.id == newTask.id);
        if (index >= 0) {
          newTasks[index] = newTask;
        }
        emit(state.copyWith(status: RequestStatus.success, message: result.message, tasks: newTasks));
        // await _fetchTasks();
        shareEvent(OnUpdateTaskEvent(task));
      } else {
        emit(state.copyWith(status: RequestStatus.failed, message: result.message));
      }
    } catch (e) {
      emit(state.copyWith(status: RequestStatus.failed, message: e.toString()));
    }
  }

  void onSortByTitle() {
    final values = List<Task>.from(state.tasks ?? [])..sort((a,b) {
      return (a.name ?? '').compareTo(b.name ?? '');
    });

    emit(state.copyWith(tasks: values));
  }

  void onSortByDesc() {
    final values = List<Task>.from(state.tasks ?? [])..sort((a,b) {
      return (a.desc ?? '').compareTo(b.desc ?? '');
    });

    emit(state.copyWith(tasks: values));
  }

  void onSortByDate() {
    final values = List<Task>.from(state.tasks ?? [])..sort((a,b) {
      return (a.createAt ?? DateTime.now()).compareTo(b.createAt ?? DateTime.now());
    });

    emit(state.copyWith(tasks: values));
  }
}
