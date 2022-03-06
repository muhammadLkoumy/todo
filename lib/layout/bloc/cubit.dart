import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/layout/bloc/states.dart';
import 'package:todo_app/modules/archived_tasks.dart';
import 'package:todo_app/modules/done_tasks.dart';
import '../../modules/new_tasks.dart';

class TodoCubit extends Cubit<TodoStates> {
  TodoCubit() : super(TodoInitialState());

  static TodoCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  bool isBottom = false;
  List<String> titles = const [
    'New',
    'Done',
    'Archived',
  ];

  List<Widget> screens = const [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(TodoChangeIndexState());
  }

  void showBottomSheet() {
    isBottom = true;
    emit(TodoShowBottomSheetState());
  }

  void hideBottomSheet() {
    isBottom = false;
    emit(TodoHideBottomSheetState());
  }

  late Database database;

  List<Map> tasks = [];

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createData() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        database.execute(
            'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)');
      },
      onOpen: (database) {
        getData(database);
      },
    ).then((value) {
      database = value;
      emit(TodoCreateDataSuccessState());
    });
  }

  Future insertData({
    required String title,
    required String date,
    required String time,
  }) async {
    await database.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO Tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
        emit(TodoInsertDataSuccessState());
        getData(database);
      });
    });
  }

  void getData(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    database.rawQuery('SELECT * FROM Tasks').then((value) {
      tasks = value;
      for (var element in tasks) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      }
      emit(TodoGetDataSuccessState());
    });
  }

  void updateData({
    required String status,
    required int id,
  }) async {
    return await database.rawUpdate(
        'UPDATE Tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      emit(TodoUpdateDataState());
      getData(database);
    });
  }

  void deleteData({
    required int id,
  }) async {
    await database
        .rawDelete('DELETE FROM Tasks WHERE id = ?', [id]).then((value) {
      emit(TodoDeleteDataState());
      getData(database);
    });
  }
}
