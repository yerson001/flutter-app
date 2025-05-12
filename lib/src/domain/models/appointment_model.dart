class AppointmentModel {
  final String id;
  final String dni;
  final String apellido;
  final String nombre;
  final String telefono;
  final String horaInicio;
  final String horaFin;
  final String lugar;
  final int edad;
  final String enfermedad;
  final int numero;
  final String tratamiento;
  final double costo;
  final String observaciones;

  AppointmentModel({
    required this.id,
    required this.dni,
    required this.apellido,
    required this.nombre,
    this.telefono = " ",
    required this.horaInicio,
    required this.horaFin,
    this.lugar = " ",
    this.edad = 0,
    this.enfermedad = " ",
    this.numero = 1,
    this.tratamiento = " ",
    this.costo = 0.0,
    this.observaciones = " ",
  });

  factory AppointmentModel.fromList(List<String> row) {
    return AppointmentModel(
      id: row[0],
      dni: row[1],
      apellido: row[2],
      nombre: row[3],
      telefono: row[4],
      horaInicio: row[5],
      horaFin: row[6],
      lugar: row[7],
      edad: int.tryParse(row[8]) ?? 0,
      enfermedad: row[9],
      numero: int.tryParse(row[10]) ?? 0,
      tratamiento: row[11],
      costo: double.tryParse(row[12]) ?? 0.0,
      observaciones: row[13],
    );
  }
}
