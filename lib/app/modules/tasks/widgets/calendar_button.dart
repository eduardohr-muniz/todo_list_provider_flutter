// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/modules/tasks/task_create_controller.dart';

class CalendarButton extends StatelessWidget {
  final dateFormat = DateFormat("dd/MM/y");
  CalendarButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () async {
        var lastDate = DateTime.now();
        lastDate = lastDate.add(const Duration(days: 10 * 365));

        final DateTime? selectedDate = await showDatePicker(
          // locale: Locale("br"),
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: lastDate,
        );

        context.read<TaskCreateController>().selectedDate = selectedDate;
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.today),
            const SizedBox(
              width: 8,
            ),
            Selector<TaskCreateController, DateTime?>(
              builder: (context, value, child) {
                if (value != null) {
                  return Text(
                    dateFormat.format(value),
                  );
                } else {
                  return const Text("Selecione uma data");
                }
              },
              selector: (context, controller) => controller.selectedDate,
            ),
          ],
        ),
      ),
    );
  }
}
