import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/notifier/default_listener_notifier.dart';
import 'package:todo_list_provider/app/core/ui/theme_extensions.dart';
import 'package:todo_list_provider/app/core/widget/todo_list_fild.dart';
import 'package:todo_list_provider/app/core/widget/todo_list_logo.dart';
import 'package:todo_list_provider/app/modules/auth/register/register_controller.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formkey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _confirmPasswordEC = TextEditingController();

  @override
  void dispose() {
    _emailEC.dispose();
    _passwordEC.dispose();
    _confirmPasswordEC.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    var modelSnackLoaderListener = DefaultListenerNotifier(
      changeNotifier: context.read<RegisterController>(),
    );
    modelSnackLoaderListener.listener(
      context: context,
      sucessCallback: (notifier, listenerInstance) {
        listenerInstance.dispose();
      },
      errorCallback: (notifier, listenerInstance) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Todo List",
              style: TextStyle(
                fontSize: 10,
                color: context.primaryColor,
              ),
            ),
            Text(
              "Cadastro",
              style: TextStyle(fontSize: 15, color: context.primaryColor),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, //& Desabilita o botão voltar padrao
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: ClipOval(
            child: Container(
              color: context.primaryColor.withAlpha(20),
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back_ios_outlined,
                size: 20,
                color: context.primaryColor,
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width * .5,
            child: const FittedBox(
              fit: BoxFit.fitHeight,
              child: TodoListLogo(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  TodoListFild(
                    controller: _emailEC,
                    label: "E-mail",
                    // type: TextInputType.emailAddress,
                    validator: Validatorless.multiple([
                      Validatorless.required("E-mail obrigátório"),
                      Validatorless.email("Email inválido"),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  TodoListFild(
                    controller: _passwordEC,
                    label: "Senha",
                    obscureText: true,
                    validator: Validatorless.multiple([
                      Validatorless.required("Senha obrigatória"),
                      Validatorless.min(
                          6, "Senha deve ter pelo menos 6 caracteres"),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  TodoListFild(
                    controller: _confirmPasswordEC,
                    label: "Confirme sua senha",
                    obscureText: true,
                    validator: Validatorless.multiple([
                      Validatorless.required("Confirmar senha obrigatório"),
                      Validatorless.compare(_passwordEC, "Senhas diferentes")
                    ]),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        final formValid =
                            _formkey.currentState?.validate() ?? false;
                        if (formValid) {
                          final email = _emailEC.text;
                          final password = _passwordEC.text;
                          context
                              .read<RegisterController>()
                              .registerUser(email, password);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text("Salvar"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
