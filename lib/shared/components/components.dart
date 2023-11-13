import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String label,
  IconData? prefix,
  VoidCallback? onTap,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      onTap: onTap,
      validator: (value) {
        if (value!.isEmpty) {
          return 'field is required';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        border: const OutlineInputBorder(),
      ),
    );

Widget buildTaskItem(
  Map model,
  context,
) =>
    BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = BlocProvider.of(context);
        return Dismissible(
          key: Key(model['id'].toString()),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(50.0),
              onDoubleTap: () {
                cubit.changeBottomSheetState(isShow: true, icon: Icons.check);
                cubit.taskId = model['id'];
                cubit.titleController.text = model['title'];
                cubit.timeController.text = model['time'];
                cubit.dateController.text = model['date'];
                AppCubit.get(context)
                    .scaffoldKey
                    .currentState!
                    .showBottomSheet(
                      (context) => Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: AppCubit.get(context).formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultFormField(
                                controller:
                                    AppCubit.get(context).titleController,
                                label: 'Task title',
                                type: TextInputType.text,
                                prefix: Icons.title,
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              defaultFormField(
                                controller:
                                    AppCubit.get(context).timeController,
                                label: 'Task time',
                                type: TextInputType.none,
                                onTap: () {
                                  showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now())
                                      .then((value) {
                                    AppCubit.get(context).timeController.text =
                                        value!.format(context).toString();
                                  });
                                },
                                prefix: Icons.watch_later_rounded,
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              defaultFormField(
                                controller:
                                    AppCubit.get(context).dateController,
                                label: 'Task date',
                                type: TextInputType.none,
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2024, 5, 23),
                                  ).then((date) {
                                    AppCubit.get(context).dateController.text =
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
                    )
                    .closed
                    .then((value) {
                  AppCubit.get(context)
                      .changeBottomSheetState(isShow: false, icon: Icons.edit);
                  cubit.titleController.text = "";
                  cubit.timeController.text = "";
                  cubit.dateController.text = "";
                });
                //AppCubit.get(context).changeBottomSheetState(isShow: true, icon: Icons.check);
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 45.0,
                      backgroundColor: Colors.blue,
                      child: CircleAvatar(
                        radius: 40.0,
                        backgroundColor: Colors.grey[300],
                        child: Text(
                          '${model['time']}',
                          style: const TextStyle(
                            fontSize: 17.5,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${model['title']}',
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 2.5,
                          ),
                          Text(
                            '${model['date']}',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    IconButton(
                        icon: const Icon(
                          Icons.check_circle_outline,
                          color: Colors.blue,
                          size: 28,
                        ),
                        onPressed: () {
                          cubit.updateDatabaseStatus(
                              status: 'done', id: model['id']);
                          if (model['status'] == 'done') {
                          } else if (model['status'] == 'archive') {
                            showToast(message: 'Task is move to done tasks');
                          } else {
                            showToast(message: 'Congratulation! Task is done ');
                          }
                        }),
                    IconButton(
                        icon: const Icon(
                          Icons.archive_outlined,
                          color: Colors.black45,
                          size: 28,
                        ),
                        onPressed: () {
                          cubit.updateDatabaseStatus(
                            status: 'archive',
                            id: model['id'],
                          );
                          if (model['status'] == 'archive') {
                            return;
                          } else {
                            showToast(
                                message:
                                    'Task is remove to archive successfully',
                                color: Colors.redAccent);
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              barrierDismissible: false, //confirm user to choice
              builder: (context) {
                return AlertDialog(
                  title: const Text(
                    "Delete the task?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      //color: Colors.amber,
                    ),
                  ),
                  content: const Text(
                    'The task will be deleted for ever, and you will not restore it again',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(left: 90.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 20),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                cubit.deleteDatabase(id: model['id']);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Delete",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );

Widget myDivider() => Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    );

Widget taskBuilder({required List<Map> tasks}) => ConditionalBuilder(
    condition: tasks.isNotEmpty,
    builder: (context) => ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(
            tasks[index],
            context,
          ),
          separatorBuilder: (context, index) => myDivider(),
          itemCount: tasks.length,
        ),
    fallback: (context) {
      if (AppCubit.get(context).currentIndex == 0) {
        return emptyScreen(
          img: const AssetImage('assets/images/newScreen.jpg'),
        );
      } else if (AppCubit.get(context).currentIndex == 1) {
        return emptyScreen(
          img: const AssetImage('assets/images/doneScreen.jpg'),
        );
      }
      return emptyScreen(
        img: const AssetImage('assets/images/archiveScreen.jpg'),
      );
    });

Widget listSetting() => ListView(
      scrollDirection: Axis.vertical,
      children: const [
        Row(
          children: [
            Text('theme'),
            Icon(Icons.ac_unit),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          children: [
            Text('theme'),
            Icon(Icons.ac_unit),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          children: [
            Text('theme'),
            Icon(Icons.ac_unit),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );

void showToast({
  required String message,
  Color color = Colors.blueAccent,
  Color txtColor = Colors.black,
}) =>
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: color,
      textColor: txtColor,
      fontSize: 16.0,
    );

Widget emptyScreen({
  required AssetImage img,
}) =>
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsetsDirectional.all(20.0),
            height: 250.0,
            child: Image(
              image: img,
            ),
          ),
          const Text(
            'No Tasks Yet, Please Add Some Tasks!',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
