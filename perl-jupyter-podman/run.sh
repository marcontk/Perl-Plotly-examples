#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="perl-jupyter"
CONTEXT_DIR="."
PORT_LOCAL="${PORT_LOCAL:-8888}"     # puedes exportar PORT_LOCAL=8890
PORT_CONTAINER=8888
DO_BUILD="${DO_BUILD:-1}"            # export DO_BUILD=0 para no reconstruir
ENGINE="${ENGINE:-}"                 # export ENGINE=podman para forzar podman

# Detectar motor si no viene por ENV
if [[ -z "${ENGINE}" ]]; then
  if command -v podman >/dev/null 2>&1; then
    ENGINE=podman
  elif command -v docker >/dev/null 2>&1; then
    ENGINE=docker
  else
    echo "❌ No se encontró docker ni podman." >&2; exit 1
  fi
fi

echo "🐋 Motor: $ENGINE"
echo "🌐 Puerto host: $PORT_LOCAL  → contenedor: $PORT_CONTAINER"

# Build opcional
if [[ "$DO_BUILD" = "1" ]]; then
  echo "🛠️  Construyendo imagen $IMAGE_NAME ..."
  "$ENGINE" build -t "$IMAGE_NAME" -f Containerfile "$CONTEXT_DIR"
else
  echo "⏭️  Saltando build (DO_BUILD=0)"
fi

# Comprobar puerto ocupado
if lsof -i TCP:"$PORT_LOCAL" -sTCP:LISTEN >/dev/null 2>&1; then
  echo "⚠️  El puerto $PORT_LOCAL está en uso. Cambia PORT_LOCAL o cierra el proceso."
  exit 1
fi

# Ejecutar Jupyter
echo "🚀 Abriendo Jupyter en http://localhost:$PORT_LOCAL (Ctrl+C para detener)"
"$ENGINE" run --rm \
  -p "${PORT_LOCAL}:${PORT_CONTAINER}" \
  -v "$PWD:/home/jovyan/work" \
  "$IMAGE_NAME" \
  sh -lc "jupyter lab --no-browser --ip=0.0.0.0 --allow-root \
          --ServerApp.token='' --ServerApp.password='' \
          --LabApp.default_url=/lab/tree"