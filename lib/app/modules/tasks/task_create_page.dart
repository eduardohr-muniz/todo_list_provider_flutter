import 'package:flutter/material.dart';
import 'package:todo_list_provider/app/core/notifier/default_listener_notifier.dart';
import 'package:todo_list_provider/app/core/ui/theme_extensions.dart';
import 'package:todo_list_provider/app/core/widget/todo_list_fild.dart';
import 'package:todo_list_provider/app/modules/tasks/task_create_controller.dart';
import 'package:todo_list_provider/app/modules/tasks/widgets/calendar_button.dart';
import 'package:validatorless/validatorless.dart';

class TaskCreatePage extends StatefulWidget {
  final TaskCreateController _controller;

  const TaskCreatePage({
    Key? key,
    required TaskCreateController controller,
  })  : _controller = controller,
        super(key: key);

  @override
  State<TaskCreatePage> createState() => _TaskCreatePageState();
}

class _TaskCreatePageState extends State<TaskCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionEc = TextEditingController();

  @override
  void initState() {
    super.initState();
    DefaultListenerNotifier(changeNotifier: widget._controller).listener(
        context: context,
        sucessCallback: (notifier, listenerInstance) {
          listenerInstance.dispose();
          Navigator.pop(context);
        });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionEc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close),
            color: Colors.black,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: context.primaryColor,
        onPressed: () {
          final formvalid = _formKey.currentState?.validate() ?? false;
          if (formvalid) {
            widget._controller.save(_descriptionEc.text);
          }
        },
        label: const Text(
          "Salvar task",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Criar task",
                  style: context.titleStyle.copyWith(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 30),
                TodoListFild(
                  label: "",
                  controller: _descriptionEc,
                  validator: Validatorless.required("Descrição obrigatória."),
                ),
                const SizedBox(height: 20),
                CalendarButton(),
              ],
            ),
          )),
    );
  }
}
