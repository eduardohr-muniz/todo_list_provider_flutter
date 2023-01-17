import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:todo_list_provider/app/core/notifier/default_listener_notifier.dart';
import 'package:todo_list_provider/app/core/ui/theme_extensions.dart';
import 'package:todo_list_provider/app/models/task_filter_enum.dart';
import 'package:todo_list_provider/app/modules/home/home_controller.dart';
import 'package:todo_list_provider/app/modules/home/widgets/home_drawer.dart';
import 'package:todo_list_provider/app/modules/home/widgets/home_filters.dart';
import 'package:todo_list_provider/app/modules/home/widgets/home_header.dart';
import 'package:todo_list_provider/app/modules/home/widgets/home_tasks.dart';
import 'package:todo_list_provider/app/modules/home/widgets/home_week_filter.dart';
import 'package:todo_list_provider/app/modules/tasks/tasks_module.dart';

class HomePage extends StatefulWidget {
  final HomeController _homeController;
  const HomePage({super.key, required HomeController homeController})
      : _homeController = homeController;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    DefaultListenerNotifier(changeNotifier: widget._homeController).listener(
      context: context,
      sucessCallback: (notifier, listenerInstance) {
        listenerInstance.dispose();
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget._homeController.loadTotalTasks();
      widget._homeController.findTasks(filter: TaskFilterEnum.today);
    });
  }

  Future<void> _goToCreatetask(BuildContext context) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation =
              CurvedAnimation(parent: animation, curve: Curves.easeInQuad);
          return ScaleTransition(
            scale: animation,
            alignment: Alignment.bottomRight,
            child: child,
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) {
          return TasksModule().getPage("/task/create", context);
        },
      ),
    );
    widget._homeController.refreshPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem<bool>(
                  onTap: () {
                    widget._homeController.showOrHideFinishTask();
                  },
                  value: false,
                  child: Text(widget._homeController.showFinishingTasks
                      ? "Esconder Tarefas Concluidas"
                      : "Mostrar Tarefas Concluidas"),
                ),
                PopupMenuItem<bool>(
                  onTap: () {
                    widget._homeController.showOnlyFinishTask();
                  },
                  value: false,
                  child: const Text("Somente Tasks concluidas"),
                ),
              ],
              icon: const Icon(
                Icons.filter_alt_outlined,
                color: Colors.black,
              ),
            )
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _goToCreatetask(context),
        backgroundColor: context.primaryColor,
        child: const Icon(Icons.add),
      ),
      backgroundColor: const Color(0xfffafbfe),
      drawer: HomeDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.minHeight,
                minWidth: constraints.minWidth,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: IntrinsicHeight(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    HomeHeader(),
                    HomeFilters(),
                    HomeWeekFilter(),
                    HomeTasks(),
                    SizedBox(
                      height: 50,
                    )
                  ],
                )),
              ),
            ),
          );
        },
      ),
    );
  }
}
