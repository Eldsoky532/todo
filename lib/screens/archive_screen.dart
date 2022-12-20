import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cubic.dart';
import '../bloc/states.dart';
import '../component/component.dart';

class ArchiveTasks extends StatelessWidget {
  const ArchiveTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,States>(
      listener: (context, state) {},
      builder: (context, state)
      {
        var tasks = AppCubit.get(context).archivedTasks;

        return tasksBuilder(
          tasks: tasks,
        );
      },
    );
  }
}
