# ⚠️ ATENCIÓN: NO HACER PUSH DIRECTO AL MAIN ⚠️

**¡MUY IMPORTANTE!**

- **🚫 NUNCA HAGAS PUSH DIRECTO A `main`**
- **💡 SIEMPRE TRABAJA EN RAMAS `feature/...` O `develop`**
- **✅ Crea tu rama feature desde `develop`:**



<br> <br>

# 🚀 Guía de Despliegue Flutter — CaffiNet-FrontEnd

**Repositorio:** `https://github.com/1ACC0238-2520-1798-G3-AlguienDijoChamba/AlguienDijoChamba--Front-2.git`

Esta guía cubre todo el proceso para clonar, configurar y ejecutar la aplicación Flutter **AlguienDijoChamba--Front-2**, desde los requisitos previos hasta las buenas prácticas de desarrollo y ramas.

## 1️⃣ Requisitos Previos 🛠️

Antes de comenzar, asegúrate de tener instaladas las siguientes herramientas:

* 🐦 **Flutter SDK:**
    * Descarga e instalación: [flutter.dev](https://flutter.dev/docs/get-started/install)
    * **Crucial:** Añadir la carpeta `flutter/bin` a la variable de entorno **PATH**.
    * Reinicia tu terminal o VS Code después de la instalación.
* 🔧 **VS Code:**
    * Extensiones recomendadas: `Flutter` y `Dart`.
* 💻 **Git:**
    * Necesario para clonar el repositorio y gestionar el control de versiones.
* 📱 **Emulador/Simulador (Opcional):**
    * Android Studio (para emuladores de Android) o Xcode (para simuladores de iOS).


## 2️⃣ Clonar el Repositorio 📥

Abre tu terminal, navega a la carpeta donde deseas guardar el proyecto y ejecuta los siguientes comandos:

```bash
git clone https://github.com/1ACC0238-2520-1798-G3-AlguienDijoChamba/AlguienDijoChamba--Front-2.git

##Si no estas en la carpeta princiapl
cd AlguienDijoChamba--Front-2

```

## 3️⃣ Errores Comunes al Clonar ⚠️

Si el proyecto no se ejecuta inmediatamente después de clonar, podría deberse a:

* ⚠️ **Dependencias no instaladas:** Falta ejecutar `flutter pub get`.
* ⚠️ **Flutter SDK no en el PATH:** El entorno no está configurado correctamente o el SDK no está instalado.
* ⚠️ **Versión de Flutter distinta:** La versión local de Flutter no coincide con la requerida por el proyecto.
* ⚠️ **Archivos generados faltantes:** Archivos de *code generation* que deben ser creados (ej. `build_runner`).

> **Solución:** Ejecutar el comando del Punto 4 (`flutter pub get`) seguido del Punto 5 (`flutter doctor`).


## 4️⃣ Instalar Dependencias 📦

Dentro de la carpeta del proyecto (`AlguienDijoChamba--Front-2`), ejecuta:

```bash
flutter pub get
```

## 5️⃣ Verificar Instalación con Flutter Doctor 🩺

Ejecuta este comando para revisar el estado completo de tu entorno Flutter:

```bash
flutter doctor
```

## 6️⃣ Abrir el Proyecto en VS Code 📂

1.  Abre VS Code.
2.  Ve a `File` -> `Open Folder...`.
3.  Selecciona la carpeta `CaffiNet-FrontEnd`.

> 💡 **Consejo:** VS Code detectará automáticamente las extensiones de Flutter/Dart. En la barra de estado inferior derecha, usa el **Device Selector** para elegir tu emulador o dispositivo físico.

## 7️⃣ Ejecutar el Proyecto ▶️

Con un emulador/dispositivo seleccionado, compila y ejecuta la aplicación:

```bash
flutter run
```

## 8️⃣ Actualizar Dependencias ⬆️

Si necesitas actualizar todos los paquetes a la última versión compatible con las restricciones de tu `pubspec.yaml`, usa:

```bash
flutter pub upgrade
```


## 9️⃣ Crear rama feature desde develop y buenas prácticas

Si ya tienes la rama `develop` en el repositorio, no la crees de nuevo.  
Sigue este flujo:


### Cambiar a la rama develop existente
```bash
git checkout develop
```
### Crear y cambiar a tu rama feature
```bash
git checkout -b feature/nombre-de-la-rama
```
### Subir la rama feature al remoto
```bash
git push -u origin feature/nombre-de-la-rama
```

## 💡 Organización de ramas feature por funcionalidad

```bash
lib/
└── features/
    ├── auth/
    ├── home/
    ├── chat/
    ├── plans&benefits/
    ├── process/
    ├── profile/
    └── search/
```


* **Funcionalidad:** Auth
    * **Rama feature sugerida:** `feature/auth`
    * **Descripción:** Registro, login, sesiones y manejo de usuarios.

* **Funcionalidad:** Home
    * **Rama feature sugerida:** `feature/home`
    * **Descripción:** Página principal, navegación inicial y carga de datos principales.

* **Funcionalidad:** Chat
    * **Rama feature sugerida:** `feature/chat`
    * **Descripción:** Chat, mensajes y notificaciones en tiempo real.

* **Funcionalidad:** Plans & Benefits
    * **Rama feature sugerida:** `feature/plans-benefits`
    * **Descripción:** Gestión de planes, beneficios y suscripciones.

* **Funcionalidad:** Process
    * **Rama feature sugerida:** `feature/process`
    * **Descripción:** Flujos de procesos internos de la app.

* **Funcionalidad:** Profile
    * **Rama feature sugerida:** `feature/profile`
    * **Descripción:** Gestión y edición de perfil de usuario.

* **Funcionalidad:** Search
    * **Rama feature sugerida:** `feature/search`
    * **Descripción:** Funcionalidad de búsqueda de usuarios, productos o contenidos.





<br>

# 📁 Feature: Auth

La feature `auth` se organiza en **tres carpetas principales**, siguiendo la arquitectura limpia (Clean Architecture):  

### Ejemplo:
```bash
lib/
└── features/
     auth/
        ├── data
        |   ├── datasources
        |   ├── models
        |   └── datasources
        ├── domain
        |   ├── entities
        |   ├── repositories
        |   └── usercases
        └── presentation
            ├── blocs
            ├── pages
            └── widgets 
```

---

## 1️⃣ Data

Carpeta responsable de **obtener, almacenar y transformar los datos**.  

**Subcarpetas y archivos:**

- `datasources/`  
  Contiene las fuentes de datos, como APIs o bases de datos.  
  - `auth_remote_data_source.dart` → Obtiene datos del servidor remoto.

- `models/`  
  Define modelos de datos que se usan para mapear información de la API o base de datos.

- `repositories/`  
  Implementa las interfaces definidas en `domain/repositories`.  
  - `auth_repository_impl.dart` → Implementación concreta del repositorio de auth.

---

## 2️⃣ Domain

Carpeta central de la **lógica de negocio**, independiente de frameworks y datos.  

**Subcarpetas y archivos:**

- `entities/`  
  Define las entidades de la aplicación.  
  - `session.dart` → Información de la sesión del usuario.  
  - `user.dart` → Información del usuario.

- `repositories/`  
  Interfaces de repositorios que definen los métodos de acceso a datos.  
  - `auth_repository.dart` → Contrato que implementa `auth_repository_impl`.

- `usecases/`  
  Casos de uso o acciones de la aplicación.  
  - `login_user.dart` → Caso de uso para iniciar sesión.  
  - `register_user.dart` → Caso de uso para registrar un usuario.

---

## 3️⃣ Presentation

Carpeta responsable de **la interfaz de usuario y la gestión del estado**.  

**Subcarpetas y archivos:**

- `blocs/`  
  Contiene la lógica de estado de la UI usando BLoC.  
  - `register_bloc.dart` → Maneja el flujo de registro de usuarios.

- `pages/`  
  Pantallas de la aplicación.  
  - `login_page.dart` → Pantalla de login.  
  - `register_page.dart` → Pantalla de registro.

- `widgets/`  
  Componentes UI reutilizables.  
  - `text_field.dart` → Campo de texto genérico.  
  - `TopBar.dart` → Barra superior de la pantalla.