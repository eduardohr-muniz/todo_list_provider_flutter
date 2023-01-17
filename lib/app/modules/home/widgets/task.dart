// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/models/task_model.dart';
import 'package:todo_list_provider/app/modules/home/home_controller.dart';

class Task extends StatelessWidget {
  final TaskModel taskModel;
  final dateFormat = DateFormat("dd/MM/y");
  Task({Key? key, required this.taskModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.3,
        dragDismissible: true,
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(100),
                topLeft: Radius.circular(100)),
            label: "Excluir",
            foregroundColor: Colors.white,
            onPressed: (_) =>
                context.read<HomeController>().delete(taskModel.id),
            icon: Icons.delete,
            backgroundColor: Colors.red,
          )
        ],
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 3,
        child: IntrinsicHeight(
          child: ListTile(
            leading: Checkbox(
              value: taskModel.finished,
              onChanged: (value) =>
                  context.read<HomeController>().checkOrUncheckTask(taskModel),
            ),
            title: Text(
              taskModel.description,
              style: TextStyle(
                decoration:
                    taskModel.finished ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(
              dateFormat.format(taskModel.dateTime),
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }
}
