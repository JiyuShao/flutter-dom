# https://github.com/flutter/flutter/wiki/Running-Flutter-Driver-tests-with-Web
trap "exit" INT TERM ERR
trap "kill 0" EXIT

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

cd $SCRIPT_DIR
flutter config --enable-web

if [ ! -d "$SCRIPT_DIR/web_installers" ]; then
  git clone https://github.com/flutter/web_installers.git
  cd web_installers/packages/web_drivers/
  flutter pub get
fi

# Find chrome driver version at following link:
# https://chromedriver.chromium.org/downloads
cd $SCRIPT_DIR/web_installers/packages/web_drivers/
dart lib/web_driver_installer.dart chromedriver --driver-version="103.0.5060.53" &

sleep 5

cd $SCRIPT_DIR
flutter drive --driver=test/driver/integration_test.dart \
  --target=test/integration_test/integration_test.dart \
  -d web-server --browser-name=chrome --no-headless
wait
