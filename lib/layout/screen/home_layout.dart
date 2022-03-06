import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/layout/bloc/cubit.dart';
import 'package:todo_app/layout/bloc/states.dart';

class HomeLayout extends StatelessWidget {

  HomeLayout({Key? key}) : super(key: key);

  var scaffoldKey = GlobalKey<ScaffoldState>();
  dynamic titleController = TextEditingController();
  dynamic dateController = TextEditingController();
  dynamic timeController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TodoCubit()..createData(),
      child: BlocConsumer<TodoCubit, TodoStates>(
        listener: (context, state) {
          if (state is TodoInsertDataSuccessState) {
            Navigator.of(context).pop();
            titleController.clear();
            timeController.clear();
            dateController.clear();
          }
        },
        builder: (context, state) {
          var cubit = TodoCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
              centerTitle: true,
            ),
            body: cubit.screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottom) {
                  if (formKey.currentState!.validate()) {
                    cubit
                        .insertData(
                            title: titleController.text,
                            date: dateController.text,
                            time: timeController.text)
                        .then((value) {
                      cubit.hideBottomSheet();
                    });
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => inputFields(context),
                        elevation: 25,
                      )
                      .closed
                      .then((value) {
                    cubit.hideBottomSheet();
                  });
                  cubit.showBottomSheet();
                }
              },
              child: cubit.isBottom
                  ? const Icon(Icons.add)
                  : const Icon(Icons.edit),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              iconSize: 18,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'New',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget inputFields(context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                label: Text('Task Title'),
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              controller: titleController,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Title must not be empty!";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              decoration: const InputDecoration(
                label: Text('Task Date'),
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
              controller: dateController,
              keyboardType: TextInputType.datetime,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Date must not be empty!";
                }
                return null;
              },
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.parse('2200-02-27'),
                ).then((value) {
                  dateController.text = DateFormat.yMMMd().format(value!);
                });
              },
            ),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              decoration: const InputDecoration(
                label: Text('Task Time'),
                prefixIcon: Icon(Icons.watch_later_outlined),
                border: OutlineInputBorder(),
              ),
              controller: timeController,
              keyboardType: TextInputType.datetime,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Time must not be empty!";
                }
                return null;
              },
              onTap: () {
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                ).then((value) {
                  timeController.text = value!.format(context);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
