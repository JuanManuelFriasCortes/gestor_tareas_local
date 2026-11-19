import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/tarea.dart';

part 'base_datos.g.dart';

// Tabla tareas. Drift devuelve cada fila como el modelo Tarea.
@UseRowClass(Tarea)
class Tareas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get titulo => text()();
  BoolColumn get completada => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [Tareas])
class BaseDatos extends _$BaseDatos {
  // Sin argumento abre la base del dispositivo; las pruebas pasan una en memoria.
  BaseDatos([QueryExecutor? conexion])
      : super(conexion ?? driftDatabase(name: 'gestor_tareas'));

  @override
  int get schemaVersion => 1;

  Stream<List<Tarea>> observarTareas() => select(tareas).watch();

  Future<void> agregarTarea(String titulo) =>
      into(tareas).insert(TareasCompanion.insert(titulo: validar(titulo)));

  Future<void> editarTitulo(int id, String titulo) =>
      (update(tareas)..where((t) => t.id.equals(id)))
          .write(TareasCompanion(titulo: Value(validar(titulo))));

  Future<void> cambiarEstado(int id, bool completada) =>
      (update(tareas)..where((t) => t.id.equals(id)))
          .write(TareasCompanion(completada: Value(completada)));

  Future<void> eliminarTarea(int id) =>
      (delete(tareas)..where((t) => t.id.equals(id))).go();

  // Rechaza títulos vacíos o solo con espacios.
  static String validar(String titulo) {
    if (titulo.trim().isEmpty) {
      throw ArgumentError('El título no puede estar vacío');
    }
    return titulo.trim();
  }
}
