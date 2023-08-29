import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

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
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        border: const OutlineInputBorder(),
      ),
    );

Widget buildTaskItem(Map model, context,) => Dismissible(
      key: Key(model['id'].toString()),
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
                  AppCubit.get(context)
                      .updateDatabase(status: 'done', id: model['id']);

                }),
            IconButton(
                icon: const Icon(
                  Icons.archive_outlined,
                  color: Colors.black45,
                  size: 28,
                ),
                onPressed: () {
                  AppCubit.get(context)
                      .updateDatabase(status: 'archive', id: model['id'],
                  );
                }),
          ],
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).deleteDatabase(id: model['id']);
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
        itemBuilder: (context, index) => buildTaskItem(tasks[index], context,),
        separatorBuilder: (context, index) => myDivider(),
        itemCount: tasks.length,
      ),
      fallback: (context) => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 85,
              color: Colors.grey,
            ),
            Text(
              'No Tasks Yet, Please Add Some TAsks!',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );

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
