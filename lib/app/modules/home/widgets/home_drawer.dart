import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/auth/auth_provider.dart';
import 'package:todo_list_provider/app/core/ui/messages.dart';
import 'package:todo_list_provider/app/core/ui/theme_extensions.dart';
import 'package:todo_list_provider/app/modules/home/home_controller.dart';
import 'package:todo_list_provider/app/repositories/tasks/tasks_repository.dart';
import 'package:todo_list_provider/app/services/user/user_service.dart';

class HomeDrawer extends StatelessWidget {
  final nameVN = ValueNotifier<String>("");
  HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration:
                BoxDecoration(color: context.primaryColor.withAlpha(70)),
            child: Row(
              children: [
                Selector<AuthProvider, String>(
                  builder: (_, value, __) {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(value),
                      radius: 30,
                    );
                  },
                  selector: (context, authProvider) {
                    return authProvider.user?.photoURL ?? "";
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Selector<AuthProvider, String>(
                      builder: (_, value, __) {
                        return Text(
                          value,
                          style: context.textTheme.subtitle2,
                        );
                      },
                      selector: (context, authProvider) {
                        return authProvider.user?.displayName ??
                            "Nome não informado";
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text("Alterar nome"),
                      content: TextField(
                        autocorrect: true,
                        onChanged: (value) => nameVN.value = value,
                      ),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text(
                              "Cancelar",
                              style: TextStyle(color: Colors.grey),
                            )),
                        TextButton(
                            onPressed: () async {
                              final nameValue = nameVN.value;
                              if (nameValue.isEmpty) {
                                Messages.of(context)
                                    .showError("Por favor insira um Nome");
                              } else {
                                await context
                                    .read<UserService>()
                                    .updateDisplayName(nameValue);
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text("Salvar")),
                      ],
                    );
                  });
            },
            title: const Text("Alterar nome"),
          ),
          ListTile(
            onTap: () {
              context.read<TasksRepository>().deletAllTasks();
              context.read<AuthProvider>().logout();
            },
            title: const Text("Sair"),
          ),
        ],
      ),
    );
  }
}
