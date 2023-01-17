import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/notifier/default_listener_notifier.dart';
import 'package:todo_list_provider/app/core/ui/messages.dart';
import 'package:todo_list_provider/app/core/widget/todo_list_fild.dart';
import 'package:todo_list_provider/app/core/widget/todo_list_logo.dart';
import 'package:todo_list_provider/app/modules/auth/login/login_controller.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _emailFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    DefaultListenerNotifier(changeNotifier: context.read<LoginController>())
        .listener(
      context: context,
      everVoidCallback: ((notifier, listenerInstance) {
        if (notifier is LoginController) {
          if (notifier.hasInfo) {
            Messages.of(context).showInfo(notifier.infoMessage!);
          }
        }
      }),
      sucessCallback: (notifier, listenerInstance) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              minWidth: constraints.maxWidth,
            ),
            child: IntrinsicHeight(
              //& Tela tenha o maximo possivel que o column vai definir muito utilizado em listview
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const FittedBox(
                    fit: BoxFit.fitHeight,
                    child: TodoListLogo(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          TodoListFild(
                            label: "E-mail",
                            focusNode: _emailFocus,
                            autoCorret: true,
                            type: TextInputType.emailAddress,
                            controller: _emailEC,
                            validator: Validatorless.multiple([
                              Validatorless.required("E-mail Obrigatório"),
                              Validatorless.email("E-mail inválido")
                            ]),
                          ),
                          const SizedBox(height: 20),
                          TodoListFild(
                            label: "Senha",
                            obscureText: true,
                            controller: _passwordEC,
                            validator: Validatorless.multiple([
                              Validatorless.required("Senha Obrigatória"),
                              Validatorless.min(6,
                                  "Senha deve conter pelo menos 6 caracteres")
                            ]),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    if (_emailEC.text.isNotEmpty) {
                                      //recuperar senha
                                      context
                                          .read<LoginController>()
                                          .forgotPassword(_emailEC.text);
                                    } else {
                                      _emailFocus.requestFocus();
                                      Messages.of(context).showError(
                                          "Digite um e-mail para recuperar a senha");
                                    }
                                  },
                                  child: const Text("Esqueceu sua senha?")),
                              ElevatedButton(
                                onPressed: () {
                                  final fomrValid =
                                      _formkey.currentState?.validate() ??
                                          false;
                                  if (fomrValid) {
                                    final email = _emailEC.text;
                                    final password = _passwordEC.text;
                                    context
                                        .read<LoginController>()
                                        .login(email, password);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text("Login"),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xfff0f3f7),
                        border: Border(
                          top: BorderSide(
                            width: 2,
                            color: Colors.grey.withAlpha(50),
                          ),
                        ),
                      ),
                      child: Column(children: [
                        const SizedBox(height: 30),
                        SignInButton(
                          Buttons.Google,
                          text: "Continue com o Google",
                          padding: const EdgeInsets.all(5),
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          onPressed: () {
                            context.read<LoginController>().googleLogin();
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Não tem conta?"),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed("/register");
                              },
                              child: const Text("Cadastre-se"),
                            ),
                          ],
                        )
                      ]),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    ));
  }
}
