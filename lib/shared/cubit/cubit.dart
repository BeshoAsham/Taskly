import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/cubit/states.dart';

import '../../modules/todo_screens/archived_tasks/archived_tasks_screen.dart';
import '../../modules/todo_screens/done_tasks/done_tasks_screen.dart';
import '../../modules/todo_screens/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  late Database database;
  int indexTapped = 0;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> screensTitle = [
    "New Tasks",
    "Done Tasks",
    "Archived Tasks",
  ];
  List<Map> newTasks = [];
  List<Map> archivesTasks = [];
  List<Map> doneTasks = [];

  void createDatabase() {
    openDatabase("todo.db", version: 1, onCreate: (Database db, int version) {
      // When creating the db, create the table
      print("database created");
      db
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT , status TEXT)')
          .then((value) {
        print("table created");
      }).catchError((error) {
        print("error when creating table ${error.toString()}");
      });
    }, onOpen: (database) {
      print("database opened");
      getDataFromDatabase(database: database);
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  Future<void> deleteDatabaseFile() async {
    String dbPath = await getDatabasesPath();
    String path = '$dbPath/todo.db';

    try {
      await deleteDatabase(path);
      print("Database deleted successfully");
      emit(AppDeleteDatabaseState());
    } catch (error) {
      print("Error deleting database: ${error.toString()}");
    }
  }

  insertToDatabase({
    required title,
    required date,
    required time,
  }) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
        print("$value inserted successfully");
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database: database);
      }).catchError((error) {
        print("Error when inserting new record: ${error.toString()}");
      });
    });
  }

  void getDataFromDatabase({required database}) {
    newTasks=[];
    doneTasks=[];
    archivesTasks=[];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element){
        if(element['status']=='new')
          newTasks.add(element);
        else if(element['status']=='done')
          doneTasks.add(element);
        else
          archivesTasks.add(element);
      });


      emit(AppGetDatabaseState());
    });
    ;
  }

  void updateData({
    required String status,
    required int id,
  }) async {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      getDataFromDatabase(database: database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({
    required int id,
  }) async {
    database.rawDelete
      ('DELETE FROM tasks WHERE id = ?', [id])
        .then((value) {
      getDataFromDatabase(database: database);
      emit(AppDeleteRecordDatabaseState());
    });
  }

  void changeIndex(int index) {
    indexTapped = index;
    emit(AppChangeBottomNavBarState());
  }

  bool isBottomSheetShow = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({required bool isShow, required IconData icon}) {
    isBottomSheetShow = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
