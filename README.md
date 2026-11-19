Gestor de tareas local con SQLite

App de Flutter que guarda tareas en una base de datos SQLite dentro del propio dispositivo, sin internet ni servidor.

Tecnología elegida: Drift con drift_flutter. Se eligió porque funciona en móvil, escritorio y web con el mismo código. En web usa SQLite compilado a WebAssembly.

Tabla tareas:
- id: número entero que se asigna solo (llave primaria autoincremental). Con él se identifica cada tarea para editarla, marcarla o borrarla.
- titulo: texto, obligatorio.
- completada: 0 si está pendiente y 1 si está completada.

Cómo correrla:
flutter pub get
flutter test
flutter run -d chrome
flutter run -d windows
flutter run -d <id del celular>

Para web, la carpeta web/ ya trae sqlite3.wasm y drift_worker.js, descargados del release drift-2.35.4 de GitHub (la misma versión de drift que usa el proyecto).
Para Windows hace falta Visual Studio con "Desarrollo para el escritorio con C++" y correr el comando desde una terminal de administrador o con el Modo de desarrollador activado.

Plataformas probadas: Android (Samsung Galaxy A55), Windows 11 y Chrome.

Pruebas P1 a P6: pasaron en las tres plataformas (P6 solo aplica a web, probada en Chrome en http://localhost:8080).

Pruebas automáticas (flutter test):
- La pantalla inicial se muestra sin errores.
- Rechaza títulos vacíos o solo con espacios y no guarda nada.
- Agrega, edita, cambia estado y elimina una tarea en la base.
