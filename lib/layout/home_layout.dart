import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';
import '../shared/components/components.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase()..newTasks..doneTasks..archiveTasks,
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is InsertToDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = BlocProvider.of(context);
          return Scaffold(
            backgroundColor: Colors.white,
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentIndex],
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                    onPressed: (){},
                    icon: const Icon(Icons.sort_rounded,),
                ),
              ],
            ),
            body: ConditionalBuilder(
              condition: state is! GetDatabaseLoadingState || state is! InitialState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => const Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                        title: cubit.titleController.text,
                        time: cubit.timeController.text,
                        date: cubit.dateController.text).then((value) {

                         showToast(message: 'Task added successfully',);

                         AppCubit.get(context).timeController.text = '';
                         AppCubit.get(context).titleController.text = '';
                         AppCubit.get(context).dateController.text = '';

                    });
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormField(
                                  controller: cubit.titleController,
                                  label: 'Task title',
                                  type: TextInputType.text,
                                  prefix: Icons.title,
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                defaultFormField(
                                  controller: cubit.timeController,
                                  label: 'Task time',
                                  type: TextInputType.none,
                                  onTap: () {
                                    showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now())
                                        .then((value) {
                                      cubit.timeController.text =
                                          value!.format(context).toString();
                                    });
                                  },
                                    prefix: Icons.watch_later_rounded,
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                defaultFormField(
                                  controller: cubit.dateController,
                                  label: 'Task date',
                                  type: TextInputType.none,
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2024, 5, 23),
                                    ).then((date) {
                                      cubit.dateController.text =
                                          DateFormat.yMMMd().format(date!);
                                    });
                                  },
                                  prefix: Icons.calendar_month_outlined,
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 20.0,
                      ).closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              elevation: 3.0,
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
