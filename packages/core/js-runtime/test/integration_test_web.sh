# https://github.com/flutter/flutter/wiki/Running-Flutter-Driver-tests-with-Web
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

fvm flutter config --enable-web
git clone https://github.com/flutter/web_installers.git
cd web_installers/packages/web_drivers/
fvm flutter pub get

# Find chrome driver version at following link:
# https://chromedriver.chromium.org/downloads
dart lib/web_driver_installer.dart chromedriver --driver-version="103.0.5060.53" &

sleep 5

cd $SCRIPT_DIR
fvm flutter drive --driver=$SCRIPT_DIR/driver/integration_test.dart \
  --target=$SCRIPT_DIR/integration_test/integration_test.dart \
  -d web-server --browser-name=chrome
