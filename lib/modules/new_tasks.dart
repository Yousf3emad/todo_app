import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';
import '../shared/components/components.dart';

class NewTasks extends StatelessWidget {
  const NewTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state){},
      builder: (context,state){
        var tasks = AppCubit.get(context).newTasks;
        return taskBuilder(
          tasks: tasks,
        );
      },
    );
  }
}
