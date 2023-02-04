// ignore_for_file: dead_code

enum TaskFilterEnum {
  today,
  tomorrrow,
  week,
}

extension TaskFilterDescription on TaskFilterEnum {
  String get description {
    switch (this) {
      case TaskFilterEnum.today:
        return "DE HOJE";
        break;
      case TaskFilterEnum.tomorrrow:
        return "DE AMANHÃ";
        break;
      case TaskFilterEnum.week:
        return "DA SEMANA";
        break;
    }
  }
}
