import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/components/components.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/cubit/states.dart';

class ArchivedTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).archivesTasks;
        return tasksBuilder(
          tasks: tasks,
          doneIconColor: Colors.red,
          doneIcon: Icons.assignment_return,
          onDonePressed: (index) {
            AppCubit.get(context).updateData(status: 'new', id: tasks[index]['id']);
          },

        );
      },
    );
  }
}
