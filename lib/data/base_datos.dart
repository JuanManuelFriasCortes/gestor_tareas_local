import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/tarea.dart';

part 'base_datos.g.dart';

/// Tabla `tareas`. @UseRowClass hace que Drift devuelva cada fila
/// directamente como el modelo [Tarea] que ya venía en el proyecto.
@UseRowClass(Tarea)
class Tareas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get titulo => text()();
  BoolColumn get completada => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [Tareas])
class BaseDatos extends _$BaseDatos {
  /// Sin argumentos abre la base persistente del dispositivo.
  /// Las pruebas pasan otra conexión (por ejemplo, una base en memoria).
  BaseDatos([QueryExecutor? conexion]) : super(conexion ?? _abrirConexion());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _abrirConexion() {
    return driftDatabase(name: 'gestor_tareas');
  }

  /// SELECT reactivo: emite la lista otra vez cada que la tabla cambia.
  Stream<List<Tarea>> observarTareas() {
    return (select(tareas)..orderBy([(t) => OrderingTerm.asc(t.id)])).watch();
  }

  /// INSERT. Rechaza títulos vacíos o hechos solo de espacios.
  Future<int> agregarTarea(String titulo) {
    final limpio = titulo.trim();
    if (limpio.isEmpty) {
      throw ArgumentError('El título no puede estar vacío');
    }
    return into(tareas).insert(TareasCompanion.insert(titulo: limpio));
  }
}
