#!/bin/bash

set -exo pipefail

# shellcheck disable=SC2153
SERVER_EXECUTABLE="$SERVER_DIR/RustDedicated"

export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$SERVER_DIR/RustDedicated_Data/Plugins:$SERVER_DIR/RustDedicated_Data/Plugins/x86_64"

shutdown_handler() {
  echo "Quit request received, shutting down gracefully..."

  echo '{"Message":"global.quit"}' | websocat -1 "ws://127.0.0.1:$RCON_PORT/${RCON_PASSWORD:-RCONPASSWORD}" >/dev/null || exit 1

  wait $SERVER_PID
  exit $?
}

trap shutdown_handler SIGINT SIGTERM

STARTUP_ARGS=(
  "-batchmode"
  "-logfile" "$LOGFILE"
  "+server.port" "$PORT"
  "+query.port" "$QUERY_PORT"
  "+rcon.port" "$RCON_PORT"
  "+app.port" "$COMPANIONAPP_PORT"
  "+rcon.password" "${RCON_PASSWORD:-RCONPASSWORD}"
  "+server.identity" "$SERVER_IDENTITY"
)

shopt -s nocasematch

if [[ $NOSTEAM == "true" || $NOSTEAM == "1" ]]; then
  STARTUP_ARGS+=("-nosteam")
fi

case $NETWORK_MODE in
"raknet")
  STARTUP_ARGS+=("-raknet")
  ;;
"swnet")
  STARTUP_ARGS+=("-swnet")
  ;;
"sdrnet")
  STARTUP_ARGS+=("-sdrnet")
  ;;
*)
  echo "Invalid network mode: $NETWORK_MODE"
  exit 1
  ;;
esac

if [[ $NETWORK_SINGLETHREADED == "true" || $NETWORK_SINGLETHREADED == "1" ]]; then
  STARTUP_ARGS+=("-nonetworkthread")
fi

case $SERVER_OCCLUSION_MODE in
"full") ;;
"norocks")
  STARTUP_ARGS+=("-disable-server-occlusion-rocks")
  ;;
"none")
  STARTUP_ARGS+=("-disable-server-occlusion")
  ;;
*)
  echo "Invalid occlusion mode: $SERVER_OCCLUSION_MODE"
  exit 1
  ;;
esac

if [[ $NOPERF == "false" || $NOPERF == "0" ]]; then
  STARTUP_ARGS+=("-perf")
fi

if [[ $RCON_PRINT == "true" || $RCON_PRINT == "1" ]]; then
  STARTUP_ARGS+=("+rcon.print" "1")
fi

exec "$SERVER_EXECUTABLE" \
  "${STARTUP_ARGS[@]}" \
  "$@" &

SERVER_PID=$!

wait "$SERVER_PID"
