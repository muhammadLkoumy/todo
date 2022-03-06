import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/layout/bloc/cubit.dart';
import 'package:todo_app/layout/bloc/states.dart';

import '../shared/components/constants.dart';

class NewTasks extends StatefulWidget {
  const NewTasks({Key? key}) : super(key: key);

  @override
  _NewTasksState createState() => _NewTasksState();
}

class _NewTasksState extends State<NewTasks> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = TodoCubit.get(context);

        return Scaffold(
          body: cubit.newTasks.isNotEmpty
              ? ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) =>
                      task(cubit.newTasks[index], cubit),
                  separatorBuilder: (context, index) => separator(),
                  itemCount: cubit.newTasks.length,
                )
              : emptyPage(),
        );
      },
    );
  }

  Widget separator() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Container(
        width: double.infinity,
        height: 1,
        color: Colors.grey.shade300,
      ),
    );
  }

  Widget task(Map model, TodoCubit cubit) {
    return Dismissible(
      key: Key(model['id'].toString()),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) {
        cubit.deleteData(id: model['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                '${model['time']}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('${model['date']}'),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    cubit.updateData(status: 'done', id: model['id']);
                  },
                  icon: const Icon(Icons.check_box_outlined),
                  color: Colors.green,
                ),
                IconButton(
                  onPressed: () {
                    cubit.updateData(status: 'archive', id: model['id']);
                  },
                  icon: const Icon(Icons.archive),
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
