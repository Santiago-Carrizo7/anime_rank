# AnimeRank
Una aplicación móvil personal desarrollada en Flutter para buscar anime y gestionar tu lista de seguimiento de manera local.

## Características
- **Búsqueda de Anime**: Integración con la API pública Jikan (MyAnimeList) v4 para buscar anime por título.
- **Seguimiento Local**: Almacena tus anime en una base de datos SQLite local.
- **Gestión de Estados**: Tres estados para clasificar tu progreso: *Watched*, *To Watch* y *Dropped*.
- **Interfaz Oscura**: Tema oscuro diseñado para una experiencia visual agradable.

## Tecnologías
- **Flutter**: Framework de desarrollo multiplataforma.
- **Provider**: Gestión de estado.
- **sqflite**: Base de datos SQLite local.
- **http**: Consumo de la API REST de Jikan.
- **cached_network_image**: Cacheo de imágenes para un rendimiento óptimo.

## Requisitos Previos
- Flutter SDK 3.x
- Dart 3.x
- Dispositivo o emulador con Android/iOS/Linux/Windows/macOS

## Instalación
1. **Clona el repositorio**
   ```bash
   git clone <url-del-repositorio>
   cd anime_rank
2. Instala las dependencias
      flutter pub get
   
3. Ejecuta la aplicación
      flutter run
   
Estructura del Proyecto
lib/
├── main.dart              # Punto de entrada
├── models/                # Modelos de datos
├── providers/             # Proveedores de estado
├── routes/                # Rutas de navegación
├── screens/               # Pantallas principales
├── services/              # Servicios (API y Base de datos)
├── theme/                 # Configuración del tema
└── widgets/               # Componentes reutilizables


Licencia
Este proyecto es de uso personal.