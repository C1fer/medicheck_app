import 'establecimiento.dart';

class GooglePlace {
  Establecimiento establecimiento;
  String? photoUri;
  double? rating;
  double distance;

  GooglePlace(this.establecimiento, this.photoUri, this.rating, this.distance);

}
