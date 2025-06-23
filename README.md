# Remote Database 📡

Paquete para el manejo de bases de datos remotas.

## Instalación 💻

Instalar a través del archivo `pubspec.yaml` añadiendo la dependencia:

```yaml
dependencies:
  remote_database:
    git:
      url: https://gitlab.com/nballari/remote_database.git
      ref: main
```

---

## Uso 📖

Este paquete proporciona una interfaz para hacer consultas a una base de datos remota. En particular Supabase.

### Ejemplo de uso

```dart
import 'package:remote_database/remote_database.dart';

void main() async {

    const supabaseUrl = 'https://your-supabase-url.supabase.co';
    const supabaseAnnonKey = 'your-supabase-anon-key';

    // Inicializar el servicio de base de datos remota
    final supabase = await RemoteDatabaseService.init(
        supabaseUrl: supabaseUrl,
        supabaseAnnonKey: supabaseAnnonKey,
    );

    // Obtener un registro específico de la base de datos
    final remoteDatabase = RemoteDatabase(
        client: supabase.client,
    );

    final responseEither = await remoteDatabase.selectSingle(
        table: 'users',
        data: {
            'user_id': '12345',
        },
        columns: 'id, name, email',
    );
}


```
