enum MessageType { WARNING, INFO, ERROR, SUCCESS }

class Constants {
  static const List<String> productCategories = [
    'CARDIOLOGIA',
    'CIRUGIA',
    'DERMATOLOGIA',
    'EMERGENCIA',
    'HEMATOLOGIA',
    'INFECTOLOGIA',
    'GASTROENTEROLOGIA',
    'ODONTOLOGIA',
    'ORTOPEDIA'
  ];
  static const List<String> productTypes = [
    'ANALITICA',
    'CONSULTA',
    'MEDICAMENTO',
    'PROCEDIMIENTO'
  ];

  static const List<String> incidentStatuses = [
    'CREADO',
    'EN_REVISION',
    'CERRADO',
  ];
  static const List<String> establishmentTypes = [
    'CENTRO_MEDICO',
    'FARMACIA',
    'LABORATORIO',
  ];

  static Map<String, String> productTypeIcons = {
  'ANALITICA': "assets/icons/analitic.svg",
  'CONSULTA': "assets/icons/appointment.svg",
  'MEDICAMENTO': "assets/icons/pill.svg",
  'PROCEDIMIENTO': "assets/icons/procedure.svg"
  };
}

enum incidentStatus {ABIERTO, REVISION, CERRADO}

enum itemsViewMode {LIST, GRID}