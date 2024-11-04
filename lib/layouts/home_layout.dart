import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/todo_screens/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/todo_screens/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/todo_screens/new_tasks/new_tasks_screen.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

import '../shared/components/constants.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              title: Text(
                AppCubit.get(context)
                    .screensTitle[AppCubit.get(context).indexTapped],
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Color(0xFF45140E),
              iconTheme: const IconThemeData(
                color: Colors.white, // This makes the back button white
              ),
            ),
            body: ConditionalBuilder(
                condition: state is !AppGetDatabaseLoadingState,
                builder: (context) => cubit.screens[cubit.indexTapped],
                fallback: (context) =>
                    Center(child: CircularProgressIndicator())),
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Color(0xFF45140E),
                selectedItemColor: Color(0xFFD6AA59),
                unselectedItemColor: Colors.white,
                showSelectedLabels: true,
                showUnselectedLabels: false,
                selectedIconTheme: IconThemeData(
                  color: Color(0xFFD6AA59),
                ),
                unselectedIconTheme: IconThemeData(
                  color: Colors.white,
                ),
                currentIndex: cubit.indexTapped,
                onTap: (index) {
                  cubit.changeIndex(index);
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                    ),
                    label: "Tasks",
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.check_circle_outline,
                      ),
                      label: "Done"),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.archive_outlined,
                      ),
                      label: "Archived")
                ]),
          );
        },
      ),
    );
  }
}
