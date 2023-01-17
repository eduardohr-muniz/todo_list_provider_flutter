import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_provider/app/core/database/sqlite_connection_factory.dart';

class SqliteAdmConnection with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final connection = SqliteConnectionFactory();

    switch (state) {
      case AppLifecycleState.resumed: // Aplicativo aberto em tela
        break;

      case AppLifecycleState.inactive: // Clique na bolinha do meio
      case AppLifecycleState
          .paused: // Atendeu alguma ligação ou outro app abriu por cima
      case AppLifecycleState.detached: // Matou o app
        connection.closeConnection();
        break;
    }

    super.didChangeAppLifecycleState(state);
  }
}
