enum MessageType { WARNING, INFO, ERROR, SUCCESS }

class Constants {
  static const List<String> productTypes = [
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
  static const List<String> productCategories = [
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
}
