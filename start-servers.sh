#!/bin/bash

# Colores para la salida
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Iniciando el entorno de desarrollo para YaDice!...${NC}"

# --- Validar que package.json existe en el directorio actual ---
if [ ! -f "package.json" ]; then
    echo -e "${RED}Error: 'package.json' no encontrado en el directorio actual. Asegúrate de ejecutar este script desde la raíz del proyecto del bot.${NC}"
    exit 1
fi

# --- Paso 1: Instalar dependencias de Node.js si es necesario ---
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}Directorio 'node_modules' no encontrado. Ejecutando 'npm install'...${NC}"
    npm install
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: Falló la instalación de dependencias con 'npm install'. Abortando.${NC}"
        exit 1
    fi
    echo -e "${GREEN}Dependencias instaladas correctamente.${NC}"
else
    echo -e "${GREEN}Dependencias de Node.js ya están instaladas.${NC}"
fi

# --- Paso 2: Generar certificados SSL si es necesario ---
CERT_DIR="certs"
KEY_FILE="$CERT_DIR/key.pem"
CERT_FILE="$CERT_DIR/cert.pem"

if [ ! -f "$KEY_FILE" ] || [ ! -f "$CERT_FILE" ]; then
    echo -e "${YELLOW}Certificados SSL no encontrados. Generando nuevos certificados con OpenSSL...${NC}"
    mkdir -p $CERT_DIR
    openssl req -x509 -newkey rsa:4096 -keyout $KEY_FILE -out $CERT_FILE -sha256 -days 365 -nodes -subj "/C=XX/ST=State/L=City/O=YaDice/OU=Dev/CN=localhost"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: Falló la generación de certificados con OpenSSL. Abortando.${NC}"
        exit 1
    fi
    echo -e "${GREEN}Certificados generados correctamente en el directorio '$CERT_DIR'.${NC}"
else
    echo -e "${GREEN}Certificados SSL ya existen.${NC}"
fi

# --- Paso 3: Exportar variables de entorno y lanzar servidores ---
export HTTPS_KEY_PATH=$KEY_FILE
export HTTPS_CERT_PATH=$CERT_FILE

echo -e "\n${YELLOW}Lanzando servidores en segundo plano...${NC}"

# Lanzar el servidor del bot de Next.js (requiere HTTPS)
npm run dev > bot-server.log 2>&1 &
BOT_PID=$!
echo -e "-> Servidor del Bot (Next.js) iniciado con PID ${BOT_PID}. Log en 'bot-server.log'."

# Lanzar el servidor para el sitio web estático
npx serve website-1 > website-server.log 2>&1 &
WEB_PID=$!
echo -e "-> Servidor del Sitio Web (Estático) iniciado con PID ${WEB_PID}. Log en 'website-server.log'."

# --- Paso 4: Mostrar información al usuario ---
sleep 5 # Dar tiempo a los servidores para que inicien y muestren sus puertos

echo -e "\n${GREEN}=======================================================${NC}"
echo -e "${GREEN}¡Entorno de desarrollo listo!${NC}"
echo -e "\n-> 🤖 ${YELLOW}Bot de Voz (Next.js) debería estar corriendo en:${NC} https://localhost:3000"
echo -e "-> 🌐 ${YELLOW}Sitio Web Estático debería estar corriendo en:${NC} http://localhost:3001 (o el puerto que 'serve' haya elegido)"
echo -e "\nPara ver los logs en tiempo real, puedes usar:"
echo -e "   tail -f bot-server.log"
echo -e "   tail -f website-server.log"
echo -e "\n${YELLOW}Para detener los servidores, ejecuta el siguiente comando:${NC}"
echo -e "   kill ${BOT_PID} ${WEB_PID}"
echo -e "${GREEN}=======================================================${NC}\n"