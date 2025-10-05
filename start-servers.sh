#!/bin/bash

# --- Guía de Despliegue para YaDice! ---
#
# Este script te guiará a través del proceso de despliegue del sitio web de YaDice!
# y el agente virtual de Next.js en un entorno de producción.
#
# Requisitos previos:
# 1. Un servidor con Node.js y npm instalados.
# 2. NGINX instalado como servidor web/proxy inverso.
# 3. PM2 instalado globalmente para gestionar la aplicación Node.js (`npm install pm2 -g`).

# Colores para la salida
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${GREEN}=====================================================${NC}"
echo -e "${GREEN}  Guía de Despliegue de Producción para YaDice!      ${NC}"
echo -e "${GREEN}=====================================================${NC}"

echo -e "\nSigue estos pasos para desplegar la aplicación:"

# --- Paso 1: Instalar Dependencias ---
echo -e "\n${CYAN}Paso 1: Instalar las dependencias del proyecto${NC}"
echo "---------------------------------------------------"
echo "Este comando instalará todas las librerías de Node.js necesarias."
echo -e "${YELLOW}Comando a ejecutar:${NC} npm install"
read -p "Presiona Enter para continuar después de ejecutar el comando..."

# --- Paso 2: Construir la Aplicación Next.js ---
echo -e "\n${CYAN}Paso 2: Construir la aplicación del agente virtual para producción${NC}"
echo "------------------------------------------------------------------"
echo "Este comando compilará y optimizará la aplicación de Next.js."
echo -e "${YELLOW}Comando a ejecutar:${NC} npm run build"
read -p "Presiona Enter para continuar después de ejecutar el comando..."

# --- Paso 3: Iniciar la Aplicación con PM2 ---
echo -e "\n${CYAN}Paso 3: Iniciar el agente virtual con PM2${NC}"
echo "------------------------------------------------"
echo "Usaremos PM2 para ejecutar la aplicación en segundo plano y gestionarla."
echo -e "${YELLOW}Comando a ejecutar:${NC} pm2 start ecosystem.config.js"
echo -e "\nPara verificar que la aplicación está corriendo, puedes usar:"
echo -e "${YELLOW}pm2 list${NC} o ${YELLOW}pm2 status${NC}"
read -p "Presiona Enter para continuar después de ejecutar el comando..."

# --- Paso 4: Configurar NGINX ---
echo -e "\n${CYAN}Paso 4: Configurar NGINX como proxy inverso${NC}"
echo "------------------------------------------------"
echo "NGINX servirá el sitio estático y redirigirá el tráfico de /demo a la aplicación."
echo "1. Copia nuestro archivo de configuración de ejemplo a NGINX:"
echo -e "   ${YELLOW}sudo cp nginx.conf.example /etc/nginx/sites-available/yadice${NC}"
echo "2. Edita el archivo para ajustar tu dominio y la ruta del proyecto:"
echo -e "   ${YELLOW}sudo nano /etc/nginx/sites-available/yadice${NC}"
echo "   (Reemplaza 'your_domain.com' y '/path/to/your/project/root')"
echo "3. Activa la configuración creando un enlace simbólico:"
echo -e "   ${YELLOW}sudo ln -s /etc/nginx/sites-available/yadice /etc/nginx/sites-enabled/${NC}"
echo "4. Verifica que la configuración de NGINX no tenga errores:"
echo -e "   ${YELLOW}sudo nginx -t${NC}"
echo "5. Si todo está bien, recarga NGINX para aplicar los cambios:"
echo -e "   ${YELLOW}sudo systemctl reload nginx${NC}"
read -p "Presiona Enter para continuar después de ejecutar el comando..."

# --- Paso 5: Finalización ---
echo -e "\n${GREEN}=====================================================${NC}"
echo -e "${GREEN}¡Despliegue completado!${NC}"
echo -e "=====================================================${NC}"
echo -e "\nTu sitio web debería estar disponible en tu dominio (ej. http://your_domain.com)."
echo -e "La demo del agente virtual estará en la ruta /demo."
echo -e "\n${CYAN}Comandos útiles de PM2:${NC}"
echo -e "-> Ver logs en tiempo real: ${YELLOW}pm2 logs yadice-virtual-agent${NC}"
echo -e "-> Detener la aplicación:   ${YELLOW}pm2 stop yadice-virtual-agent${NC}"
echo -e "-> Reiniciar la aplicación: ${YELLOW}pm2 restart yadice-virtual-agent${NC}"
echo -e "-> Eliminar la aplicación:  ${YELLOW}pm2 delete yadice-virtual-agent${NC}"
echo ""