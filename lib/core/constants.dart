// 1️⃣ Usar 10.0.2.2 cuando estás usando un emulador Android.
//    Esto funciona porque el emulador no puede usar "localhost" directamente.
//    10.0.2.2 apunta al localhost de tu PC desde el emulador.

// 2️⃣ Usar tu IPv4 local cuando estás usando un dispositivo físico como Chrome(web-javascript)
//    conectado a la misma red Wi-Fi que tu PC.
//
//    Cómo obtener tu IPv4 local en Windows:
//    1. Presiona Win + R, escribe "cmd" y presiona Enter.
//    2. En la consola, escribe `ipconfig` y presiona Enter.
//    3. Busca el adaptador de red que estás usando (Wi-Fi o Ethernet).
//    4. Localiza "Dirección IPv4" o "IPv4 Address".
//       Ejemplo: 192.168.1.10
//    5. Esa es la dirección que debes poner en tu BASE_URL para el dispositivo físico.
//
//    Nota: Tu dispositivo móvil debe estar conectado a la misma red Wi-Fi.


const String BASE_URL = 'http://10.0.2.2:5000/api/v1';