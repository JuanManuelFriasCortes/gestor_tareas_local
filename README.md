Gestor de tareas local con SQLite

App de Flutter que guarda tareas en una base de datos SQLite dentro del propio dispositivo, sin internet ni servidor.

Tecnología elegida: Drift con drift_flutter. Se eligió porque funciona en Android, iOS, Windows, Linux, macOS y web con el mismo código. En web usa SQLite compilado a WebAssembly.

Tabla tareas:
- id: número entero que se asigna solo (llave primaria autoincremental). Con él se identifica cada tarea para editarla, marcarla o borrarla.
- titulo: texto, obligatorio.
- completada: 0 si está pendiente y 1 si está completada.

Cómo correrla:
flutter pub get
flutter test
flutter run -d chrome

Se va a probar en web (Chrome) y Android. Las demás plataformas están contempladas en el diseño, pero no se probarán.
