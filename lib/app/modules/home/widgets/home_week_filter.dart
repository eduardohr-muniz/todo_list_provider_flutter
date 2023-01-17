import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/ui/theme_extensions.dart';
import 'package:todo_list_provider/app/models/task_filter_enum.dart';
import 'package:todo_list_provider/app/modules/home/home_controller.dart';

class HomeWeekFilter extends StatelessWidget {
  const HomeWeekFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: context.select<HomeController, bool>(
          (value) => value.filterSelected == TaskFilterEnum.week),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            "DIA DA SEMANA",
            style: context.titleStyle,
          ),
          SizedBox(height: 10),
          SizedBox(
              height: 100,
              child: Selector<HomeController, DateTime>(
                  builder: (context, value, child) {
                    return DatePicker(
                      value,
                      locale: "pt-BR",
                      initialSelectedDate: value,
                      selectionColor: context.primaryColor,
                      selectedTextColor: Colors.white,
                      daysCount: 7,
                      monthTextStyle: const TextStyle(fontSize: 10),
                      dateTextStyle: const TextStyle(fontSize: 16),
                      dayTextStyle: const TextStyle(fontSize: 13),
                      onDateChange: (date) {
                        context.read<HomeController>().filterByDay(date);
                      },
                    );
                  },
                  selector: (context, controller) =>
                      controller.initialDateOfWweek ?? DateTime.now())),
        ],
      ),
    );
  }
}
