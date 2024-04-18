import 'establecimiento.dart';

class GooglePlace {
  Establecimiento establecimiento;
  String? photoUri;
  double? rating;
  double distance;

  GooglePlace({required this.establecimiento, this.photoUri, this.rating,  required this.distance});

}
