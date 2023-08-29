import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/cubit/states.dart';
import '../../modules/archived_tasks.dart';
import '../../modules/done_tasks.dart';
import '../../modules/new_tasks.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(InitialStates());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  List<Widget> screens = const [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex (int index){
    currentIndex = index ;
    emit(ChangeBottomNavBarState());
  }


   late Database database;
  List<Map> newTasks =[];
  List<Map> doneTasks =[];
  List<Map> archiveTasks =[];

  void createDatabase() {
      openDatabase(
       'todo.dp',
       version: 1,
      onCreate: (database, version) {
        print('DataBase Created ');

        database
            .execute(
            'CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT, date TEXT,time TEXT, status TEXT)')
            .then((value) {
          print(' Table Created ');
        }).catchError((error) {
          print('Error when Creating Table: ${error.toString()} ');
        });
      },
      onOpen: ( database) {
        getFromDatabase(database);
        print(' DataBase opened ');
      },
    ).then((value) {
      database = value ;
      emit(CreateDatabaseState());
     }).catchError((error){
       print('error when open database-> ${error.toString()}');
      });
  }



  Future insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
     await database.transaction((txn) async {
      txn
          .rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
        print("$value inserted successfully ");
        emit(InsertToDatabaseState());
        getFromDatabase(database);
      }).catchError((error) {
        print('Error when inserting new record ${error.toString()}');
      });

      return null;
    });
  }

  void getFromDatabase(database)  {

    newTasks = [];
    doneTasks = [];
    archiveTasks = [];

    emit(GetDatabaseLoadingState());

      database.rawQuery('SELECT * FROM tasks').then((value) {

        value.forEach((element){
          if(element['status'] == 'new') {
            newTasks.add(element);
          } else if(element['status'] == 'done') {
            doneTasks.add(element);
          } else {
            archiveTasks.add(element);
          }
        });

        emit(GetDatabaseState());
      });

  }

  void updateDatabase({
    required String status,
    required int id,
})
  {
     database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value){

      getFromDatabase(database);
      emit(UpdateDatabaseState());
     });
  }

  void deleteDatabase({
    required int id,
  })
  {
    database.rawDelete(
      'DELETE from tasks WHERE id = ?', [id],
    ).then((value){

      getFromDatabase(database);
      emit(DeleteDatabaseState());
    });
  }

  bool isBottomSheetShown = false;
  var fabIcon = Icons.edit;

  void changeBottomSheetState({
  required bool isShow,
  required IconData icon,
})
  {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(ChangeBottomSheetState());
  }


}