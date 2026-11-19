import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_tareas_local/data/base_datos.dart';

void main() {
  late BaseDatos baseDatos;

  setUp(() => baseDatos = BaseDatos(NativeDatabase.memory()));
  tearDown(() => baseDatos.close());

  test('Rechaza títulos vacíos o solo con espacios', () async {
    expect(() => baseDatos.agregarTarea(''), throwsArgumentError);
    expect(() => baseDatos.agregarTarea('   '), throwsArgumentError);
    expect(await baseDatos.observarTareas().first, isEmpty);
  });

  test('Agrega, edita, cambia estado y elimina en la base', () async {
    await baseDatos.agregarTarea('Estudiar');
    var tarea = (await baseDatos.observarTareas().first).single;

    await baseDatos.editarTitulo(tarea.id, 'Estudiar SQLite');
    await baseDatos.cambiarEstado(tarea.id, true);
    tarea = (await baseDatos.observarTareas().first).single;
    expect(tarea.titulo, 'Estudiar SQLite');
    expect(tarea.completada, isTrue);

    await baseDatos.eliminarTarea(tarea.id);
    expect(await baseDatos.observarTareas().first, isEmpty);
  });
}
