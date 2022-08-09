SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

fvm flutter drive --driver=$SCRIPT_DIR/driver/integration_test.dart \
  --target=$SCRIPT_DIR/integration_test/integration_test.dart \
  -d macos
