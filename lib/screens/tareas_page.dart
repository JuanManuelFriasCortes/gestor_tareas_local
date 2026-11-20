import 'dart:async';

import 'package:flutter/material.dart';
import '../data/base_datos.dart';
import '../models/tarea.dart';

class TareasPage extends StatefulWidget {
  const TareasPage({super.key, required this.baseDatos});

  final BaseDatos baseDatos;

  @override
  State<TareasPage> createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {
  final TextEditingController _tituloController = TextEditingController();
  StreamSubscription<List<Tarea>>? _suscripcion;

  List<Tarea> _tareas = [];

  @override
  void initState() {
    super.initState();
    // Se consulta aquí y no en build(): el Stream avisa cuando la tabla cambia.
    _suscripcion = widget.baseDatos.observarTareas().listen(
      (tareas) => setState(() => _tareas = tareas),
      onError: (_) => _mostrarMensaje('No se pudieron cargar las tareas'),
    );
  }

  void _agregarTarea() {
    _guardar(() => widget.baseDatos.agregarTarea(_tituloController.text));
    _tituloController.clear();
  }

  void _alternarCompletada(Tarea tarea, bool completada) {
    _guardar(() => widget.baseDatos.cambiarEstado(tarea.id, completada));
  }

  Future<void> _editarTarea(Tarea tarea) async {
    String titulo = tarea.titulo;
    final nuevoTitulo = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar tarea'),
        content: TextFormField(
          initialValue: tarea.titulo,
          autofocus: true,
          onChanged: (valor) => titulo = valor,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, titulo),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (nuevoTitulo != null) {
      _guardar(() => widget.baseDatos.editarTitulo(tarea.id, nuevoTitulo));
    }
  }

  void _eliminarTarea(Tarea tarea) {
    _guardar(() => widget.baseDatos.eliminarTarea(tarea.id));
  }

  // Ejecuta una operación de la base y avisa si algo falla.
  Future<void> _guardar(Future<void> Function() operacion) async {
    try {
      await operacion();
    } on ArgumentError catch (e) {
      _mostrarMensaje(e.message);
    } catch (_) {
      _mostrarMensaje('No se pudo guardar el cambio');
    }
  }

  void _mostrarMensaje(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  @override
  void dispose() {
    // Liberar recursos: dejar de escuchar el Stream y cerrar la base.
    _suscripcion?.cancel();
    widget.baseDatos.close();
    _tituloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestor de tareas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Nueva tarea',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _agregarTarea,
              icon: const Icon(Icons.add),
              label: const Text('Agregar tarea'),
            ),
            const SizedBox(height: 12),
            const Text('Mis tareas', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Expanded(
              child: _tareas.isEmpty
                  ? const Center(child: Text('Todavía no hay tareas guardadas'))
                  : ListView.builder(
                      itemCount: _tareas.length,
                      itemBuilder: (context, index) {
                        final tarea = _tareas[index];
                        return Card(
                          child: ListTile(
                            leading: Checkbox(
                              value: tarea.completada,
                              onChanged: (valor) {
                                if (valor != null) {
                                  _alternarCompletada(tarea, valor);
                                }
                              },
                            ),
                            title: Text(tarea.titulo),
                            subtitle: Text('ID: ${tarea.id}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: 'Editar',
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _editarTarea(tarea),
                                ),
                                IconButton(
                                  tooltip: 'Eliminar',
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => _eliminarTarea(tarea),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
