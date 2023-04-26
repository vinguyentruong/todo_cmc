import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/common/widgets/content_bundle.dart';
import 'package:todo_app/common/widgets/default_app_bar.dart';
import 'package:todo_app/common/widgets/spacing.dart';

import '../../common/enums/status.dart';
import '../../common/resources/index.dart';
import '../../common/widgets/dialogs/loading_dialog.dart';
import '../../common/widgets/toast/toast.dart';
import '../../di/injection.dart';
import '../../models/task.dart';
import '../../routes/app_routes.dart';
import '../complete/bloc/complete_cubit.dart';
import '../widgets/task_list_widget.dart';
import 'bloc/inprogress_cubit.dart';
import 'bloc/inprogress_state.dart';

class InProgressPage extends StatefulWidget {
  const InProgressPage({Key? key}) : super(key: key);

  @override
  State<InProgressPage> createState() => _InProgressPageState();
}

class _InProgressPageState extends State<InProgressPage> {
  final _bloc = getIt<InProgressCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc..initData(),
      child: BlocConsumer<InProgressCubit, InProgressState>(
        listener: _handleStateListener,
        builder: (_, state) {
          return Scaffold(
            appBar: DefaultAppBar(
              titleText: Strings.localized.inProgress,
              leading: const SizedBox(),
            ),
            body: SafeArea(
              child: Container(
                child: Column(
                  children: [
                    const Spacing(),
                    Expanded(
                      child: ContentBundle(
                        onRefresh: (_) => _bloc.onRefresh(),
                        status: state.dataStatus,
                        child: TaskListWidget(
                          tasks: state.tasks,
                          showCheckBox: false,
                          onItemTapped: (task) => _onItemTapped(context, task),
                          onEditTapped: (task) => _onEditTapped(context, task),
                          onDeleteTapped: (task) => _onDeleteTapped(context, task),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
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
