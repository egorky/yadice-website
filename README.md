# Repositorio del Proyecto YaDice!

Este repositorio contiene dos componentes principales:

1.  **Bot de Voz con IA (`/`)**: Una aplicación Next.js que alimenta el bot de voz conversacional.
2.  **Sitio Web Corporativo (`/`)**: Un sitio web estático que sirve como la cara pública de la empresa YaDice!.

## Entorno de Desarrollo Unificado

Para facilitar el desarrollo y las pruebas locales, se ha creado un script que levanta ambos servicios (el bot y el sitio web) simultáneamente.

### Requisitos

*   Node.js y npm
*   OpenSSL (generalmente preinstalado en sistemas Linux y macOS)

### Instrucciones de Arranque

1.  **Asegúrate de estar en la raíz del repositorio.**
2.  **Dale permisos de ejecución al script** (solo necesitas hacerlo una vez):
    ```bash
    chmod +x start-servers.sh
    ```
3.  **Ejecuta el script:**
    ```bash
    ./start-servers.sh
    ```

El script se encargará de:
*   Instalar las dependencias de Node.js si es necesario.
*   Generar certificados SSL para el servidor del bot si no existen.
*   Lanzar ambos servidores en segundo plano.

Una vez ejecutado, podrás acceder a:
*   **Bot de Voz (Next.js)**: `https://localhost:3000`
*   **Sitio Web Estático**: `http://localhost:3001` (o el puerto que se indique en la terminal)

Para detener los servidores, ejecuta el comando que el propio script te proporcionará al finalizar.

---

## Visualización del Sitio Web (Manual)

Si solo deseas ver el sitio web estático sin levantar el bot, puedes hacerlo de las siguientes maneras:

### 1. Localmente (sin servidor)

Puedes abrir el archivo `website-1/index.html` directamente en tu navegador web.

### 2. Con un servidor de desarrollo local

Si tienes Node.js instalado, puedes usar el paquete `serve`:
```bash
npx serve ./
```
Esto levantará el sitio en una URL local, típicamente `http://localhost:3001`.
