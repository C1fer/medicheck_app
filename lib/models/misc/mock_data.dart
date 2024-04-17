import 'package:medicheck/models/incidente.dart';

import '../aseguradora.dart';
import '../cobertura_grupo.dart';
import '../establecimiento.dart';
import '../plan.dart';
import '../producto.dart';
import '../regimen.dart';
import '../tipo_producto.dart';

import '../cobertura.dart';
import '../cobertura_subgrupo.dart';

class MockData {
  static TipoProducto productType =
      TipoProducto(id: 15, nombre: "Material Sanitario");
  static GrupoCobertura coverageGroup =
      GrupoCobertura(id: 1, nombre: "Prevencion Cancer Cervico-Uterino");
  static SubGrupoCobertura coverageSubGroup = SubGrupoCobertura(
      idSubGrupo: 10,
      nombre: "Prevención y Promoción",
      idGrupoNavigation: coverageGroup);

  static Aseguradora insurer = Aseguradora(
      idAseguradora: 1,
      nombre: "ARS Senasa",
      direccion: "C. ASAD",
      telefono: null,
      correo: null,
      sitioWeb: null,
      fechaRegistro: DateTime.parse("2024-04-10T12:34:00"));
  static Regimen planRegimen = Regimen(id: 1, descripcion: "SUBSIDIADO");

  static Plan plan = Plan(
      idPlan: 1,
      descripcion: "Plan Básico de Salud",
      fechaRegistro: DateTime.parse("2024-04-10T12:34:00"),
      idAseguradoraNavigation: insurer,
      idRegimenNavigation: planRegimen);
  static Producto product = Producto(
      idProducto: 1,
      nombre: "MATERIAL GASTABLE",
      fechaRegistro: "2024-04-10T12:34:00",
      CUPS: "0",
      isPDSS: true,
      idTipoProductoNavigation: productType);

  static Cobertura coverage = Cobertura(
      idCobertura: 4529,
      porcentaje: 100,
      fechaVencimiento: null,
      fechaRegistro: DateTime.parse("2024-04-10T12:34:00"),
      isPDSS: true,
      nivelAtencion1: true,
      nivelAtencion2: true,
      nivelAtencion3: true,
      coberturaTope: 1,
      cuotaAfiliadoTope: 1,
      idSubGrupoNavigation: coverageSubGroup,
      idPlanNavigation: plan,
      idProductoNavigation: product);

  static Establecimiento establishment = Establecimiento(
      idEstablecimiento: 1,
      nombre: "Clinica Tamarez Espina",
      categoria: "CENTRO_MEDICO",
      direccion: "CHARLES DE GAULLE ANTES DE INVIVIENDA, SANTO DOMINGO",
      telefono: "809-534-3093",
      correo: null,
      latitud: 0.0,
      longitud: 0.0,
      googlePlaceID: "",
      fechaRegistro: DateTime.parse("2024-04-10T12:34:00"));

  static Incidente incident = Incidente(
      idIncidente: 1,
      descripcion:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ex purus, tincidunt ut laoreet non, congue cursus ligula. Curabitur dapibus lobortis leo. Praesent tempor varius scelerisque. Sed sed tellus convallis, rhoncus dui eget, facilisis velit. Aenean vel lacus consectetur, porta dolor nec, porttitor tortor. ",
      estado: "ABIERTO",
      fechaIncidente: null,
      fechaRegistro: DateTime.parse("2024-04-10T12:34:00"),
      establecimientoNavigation: establishment,
      planNavigation: null,
      productoNavigation: product,
      usuarioNavigation: null);
}
