import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/bloc/states.dart';


import '../screens/archive_screen.dart';
import '../screens/done_screen.dart';
import '../screens/new_tasks_screen.dart';

class AppCubit extends Cubit<States> {
  AppCubit() :super(InitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int current_idex = 0;
  List<Widget> screens = [NewTasks(), DoneTasks(), ArchiveTasks()];

  void changeIndex(int index) {
    current_idex = index;
    emit(ChangeBottomNavBar());
  }

  static late Database database;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDatabase() {
    openDatabase('todo2.dp', version: 1,
        onCreate: (database, version) {
          print('database created');
          database.execute(
              'CREATE TABLE Test (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
              .then((value) {
            print('table created');
          }).catchError((error) {
            print(error.toString());
          });
        }, onOpen: (database) {
          getDataFromDatabase(database);
          print('database opened');
        }).then((value) {
      database = value;
      emit(CreateDataBasestate());
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(GetDataBaseLoadingstate());

    database.rawQuery('SELECT * FROM Test').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });

      emit(GetDataBasestate());
    });
  }


  insertToDatabase({required String title,
    required String time,
    required String date
  }) async {
    return await database.transaction((txn) {
      txn.rawInsert(
        'INSERT INTO Test(title, date, time, status) VALUES("$title", "$time", "$date", "new")',)
          .then((value) {
        print('insert success');
        emit(insertDataBaseLoadingstate());
      }).catchError((error) {
        print(error.toString());
      });
      return null;
    });
  }
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;

    emit(ChangBottomSheetState());
  }


  void updateData({
    required String status,
    required int id,
  }) async
  {
    database.rawUpdate(
      'UPDATE Test SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value)
    {
      getDataFromDatabase(database);
      emit(updateDataBaseLoadingstate());
    });
  }

  void deleteData({
    required int id,
  }) async
  {
    database.rawDelete('DELETE FROM Test WHERE id = ?', [id])
        .then((value)
    {
      getDataFromDatabase(database);
      emit(DeleteDataBaseLoadingstate());
    });
  }





}
