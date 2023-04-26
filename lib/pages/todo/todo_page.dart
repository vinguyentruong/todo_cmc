import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/common/resources/index.dart';
import 'package:todo_app/common/widgets/content_bundle.dart';
import 'package:todo_app/common/widgets/default_app_bar.dart';
import 'package:todo_app/common/widgets/spacing.dart';
import 'package:todo_app/pages/todo/bloc/todo_state.dart';
import 'package:todo_app/pages/todo/helper/task_options.dart';

import '../../common/enums/status.dart';
import '../../common/widgets/dialogs/loading_dialog.dart';
import '../../common/widgets/search_text_field.dart';
import '../../common/widgets/toast/toast.dart';
import '../../di/injection.dart';
import '../../models/task.dart';
import '../../routes/app_routes.dart';
import '../widgets/detail_option_widget.dart';
import '../widgets/task_list_widget.dart';
import 'bloc/todo_cubit.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final _bloc = getIt<TodoCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc..initData(),
      child: BlocConsumer<TodoCubit, TodoState>(
        listener: _handleStateListener,
        builder: (_, state) {
          return Scaffold(
            appBar: DefaultAppBar(
              titleText: Strings.localized.todo,
              trailingActions: [
                IconButton(onPressed: _onSortTapped, icon: Icon(Icons.sort))
              ],
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    const Spacing(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SearchTextField(
                        hintText: Strings.localized.search,
                        onChanged: (name) => _bloc.onSearchTasks(name),
                      ),
                    ),
                    const Spacing(),
                    Expanded(
                      child: ContentBundle(
                        onRefresh: (_) => _bloc.onRefresh(),
                        status: state.dataStatus,
                        child: TaskListWidget(
                          tasks: state.tasks,
                          onItemTapped: (task) => _onItemTapped(context, task),
                          onChecked: (task, val) => _onCheck(context, task, val),
                          onEditTapped: (task) => _onEditTapped(context, task),
                          onDeleteTapped: (task) => _onDeleteTapped(context, task),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      onPressed: () => _onAddTapped(context),
                      child: Icon(Icons.add),
                      backgroundColor: AppColors.primaryColor,
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void _onSortTapped() {
    showModalBottomSheet<dynamic>(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return TaskEditOptionsModal<SortOption>(
            onPress: (_, option) => _onSortOptionTapped(option.key), options: getSortTaskOptions());
      },
    );
  }

  void _onSortOptionTapped(SortOption option) {
    switch (option) {
      case SortOption.sortByTitle:
        _bloc.onSortByTitle();
        break;
      case SortOption.sortByDesc:
        _bloc.onSortByDesc();
        break;
      case SortOption.sortByDate:
        _bloc.onSortByDate();
        break;
    }
  }

  void _handleStateListener(context, state) {
    switch (state.status) {
      case RequestStatus.initial:
        break;
      case RequestStatus.requesting:
        IgnoreLoadingIndicator().show(context);
        break;
      case RequestStatus.success:
        IgnoreLoadingIndicator().hide(context);
        break;
      case RequestStatus.failed:
        IgnoreLoadingIndicator().hide(context);
        showFailureMessage(context, state.message ?? '');
        break;
    }
  }

  void _onCheck(BuildContext context, Task? task, bool value) {
    _bloc.updateTaskStatus(task, value);
  }

  void _onAddTapped(BuildContext context) {
    Navigator.pushNamed(context, RouterName.createTask);
  }

  void _onItemTapped(BuildContext context, Task? task) {
    Navigator.pushNamed(context, RouterName.taskDetail, arguments: task);
  }

  void _onEditTapped(BuildContext context, Task? task) {
    Navigator.pushNamed(context, RouterName.editTask, arguments: task);
  }

  void _onDeleteTapped(BuildContext context, Task? task) {
    _bloc.deleteTask(task);
  }
}
