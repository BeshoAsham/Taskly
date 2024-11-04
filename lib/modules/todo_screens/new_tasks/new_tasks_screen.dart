import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

import '../../../shared/components/constants.dart';
import '../../../shared/cubit/states.dart';

class NewTasksScreen extends StatelessWidget {
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        var tasks = cubit.newTasks;

        return Scaffold(
          key: scaffoldkey,
          body: tasksBuilder(
            tasks: tasks,
            doneIcon: Icons.check_circle,
            onDonePressed: (index) {
              cubit.updateData(status: 'done', id: tasks[index]['id']);
            },
            archiveIcon: Icons.archive_rounded,
            onArchivePressed: (index) {
              cubit.updateData(status: 'archive', id: tasks[index]['id']);
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (cubit.isBottomSheetShow) {
                if (formkey.currentState!.validate()) {
                  cubit.insertToDatabase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text);
                }
              } else {
                scaffoldkey.currentState
                    ?.showBottomSheet(
                      (context) => Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(20.0),
                    child: Form(
                      key: formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          defaultFormField(
                            controller: titleController,
                            keyboardType: TextInputType.text,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return "Title must not be empty";
                              }
                              return null;
                            },
                            label: "Task Title",
                            prefix: Icons.title,
                          ),
                          SizedBox(height: 15.0),
                          defaultFormField(
                            controller: timeController,
                            keyboardType: TextInputType.datetime,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return "Time must not be empty";
                              }
                              return null;
                            },
                            label: "Task Time",
                            prefix: Icons.watch_later_outlined,
                            ontap: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((value) {
                                timeController.text =
                                    value!.format(context).toString();
                              });
                            },
                          ),
                          SizedBox(height: 15.0),
                          defaultFormField(
                            controller: dateController,
                            keyboardType: TextInputType.datetime,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return "Date must not be empty";
                              }
                              return null;
                            },
                            label: "Task Date",
                            prefix: Icons.calendar_month_outlined,
                            ontap: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2026),
                              ).then((value) {
                                dateController.text = DateFormat.yMMMd()
                                    .format(value!);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  elevation: 25.0,
                )
                    .closed
                    .then((_) {
                  cubit.changeBottomSheetState(
                      isShow: false, icon: Icons.edit);
                });
                cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
              }
            },
            backgroundColor: Color(0xFF45140E),
            child: Icon(
              cubit.fabIcon,
              color: Color(0xFFD6AA59),
            ),
          ),
        );
      },
    );
  }
}
