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

---

## Despliegue en Producción (Manual)

Esta guía describe cómo desplegar el sitio web estático y el agente virtual de Next.js en un servidor de producción.

### Requisitos Previos

1.  **Servidor Linux:** (Ej. Ubuntu, CentOS).
2.  **Node.js y npm:** Instalados en el servidor.
3.  **NGINX:** Instalado como servidor web.
4.  **PM2:** Instalado globalmente para gestionar la aplicación Node.js.
    ```bash
    sudo npm install pm2 -g
    ```

### Pasos de Despliegue

#### 1. Preparar la Aplicación

Primero, clona el repositorio en tu servidor y navega a la raíz del proyecto. Luego, instala las dependencias y construye la aplicación de Next.js para producción.

```bash
# Instalar dependencias del proyecto
npm install

# Construir la aplicación de Next.js para producción
npm run build
```

#### 2. Iniciar el Agente Virtual con PM2

Usaremos PM2 para ejecutar la aplicación de Next.js en segundo plano y asegurarnos de que se reinicie automáticamente si falla. El archivo `ecosystem.config.js` ya está configurado para esto.

```bash
# Iniciar la aplicación usando el archivo de configuración
pm2 start ecosystem.config.js
```

Puedes verificar que la aplicación está corriendo con `pm2 list` o `pm2 status`.

#### 3. Configurar NGINX

NGINX actuará como un proxy inverso. Servirá los archivos del sitio web estático directamente y redirigirá todo el tráfico de la ruta `/demo` a la aplicación de Next.js que se está ejecutando en el puerto 3000.

1.  **Copia el archivo de configuración de ejemplo** a la carpeta de sitios disponibles de NGINX.
    ```bash
    sudo cp nginx.conf.example /etc/nginx/sites-available/yadice
    ```

2.  **Edita el archivo de configuración** para ajustar tu dominio y la ruta al proyecto.
    ```bash
    sudo nano /etc/nginx/sites-available/yadice
    ```
    -   Reemplaza `your_domain.com` con tu nombre de dominio real.
    -   Reemplaza `/path/to/your/project/root` con la ruta absoluta a la raíz de este proyecto.

3.  **Activa la nueva configuración** creando un enlace simbólico.
    ```bash
    sudo ln -s /etc/nginx/sites-available/yadice /etc/nginx/sites-enabled/
    ```
    *Nota: Si ya existe un enlace `default`, puede que necesites eliminarlo (`sudo rm /etc/nginx/sites-enabled/default`).*

4.  **Verifica que la sintaxis de NGINX es correcta.**
    ```bash
    sudo nginx -t
    ```

5.  **Recarga NGINX** para aplicar los cambios.
    ```bash
    sudo systemctl reload nginx
    ```

### ¡Listo!

Tu sitio web debería estar disponible en tu dominio, y la demo del agente virtual en `http://tu_dominio.com/demo`.

### Comandos Útiles

-   **Ver logs de la aplicación:** `pm2 logs yadice-virtual-agent`
-   **Reiniciar la aplicación:** `pm2 restart yadice-virtual-agent`
-   **Detener la aplicación:** `pm2 stop yadice-virtual-agent`
-   **Guardar la configuración de PM2** para que se reinicie al iniciar el servidor: `pm2 save`
