#!/usr/bin/env bash
set -euo pipefail

driver_pid=''
browser_directory=''
cleanup() {
  if [ -n "$driver_pid" ]; then
    kill "$driver_pid" 2>/dev/null || true
    wait "$driver_pid" 2>/dev/null || true
  fi
  if [ -n "$browser_directory" ]; then
    rm -rf -- "$browser_directory"
  fi
}
trap cleanup EXIT

# setup-chrome strips the .app suffix from its macOS cache directory. Chrome
# prints its version there but cannot create the instrumented WebDriver session.
# Keep the shared cache untouched and restore the bundle name in a private copy.
if [ "$(uname -s)" = Darwin ]; then
  chrome_bundle="${CHROME_EXECUTABLE%/Contents/MacOS/*}"
  if [ ! -d "$chrome_bundle/Contents" ]; then
    echo 'Expected a macOS Chrome app bundle.' >&2
    exit 1
  fi
  case "$chrome_bundle" in
    *.app) ;;
    *)
      browser_directory="$(mktemp -d "$RUNNER_TEMP/zstandard-chrome.XXXXXX")"
      /bin/cp -R "$chrome_bundle" "$browser_directory/Chrome for Testing.app"
      CHROME_EXECUTABLE="$browser_directory/Chrome for Testing.app/Contents/MacOS/${CHROME_EXECUTABLE##*/}"
      ;;
  esac
fi

driver_log="$(mktemp "$RUNNER_TEMP/zstandard-chromedriver.XXXXXX")"
"$CHROMEDRIVER_EXECUTABLE" --port=0 > "$driver_log" 2>&1 &
driver_pid=$!

driver_port=''
for attempt in {1..100}; do
  driver_port="$(sed -nE 's/.*ChromeDriver was started successfully on port ([0-9]+).*/\1/p' "$driver_log" | tail -n 1)"
  if [ -n "$driver_port" ]; then
    break
  fi
  if ! kill -0 "$driver_pid" 2>/dev/null; then
    cat "$driver_log" >&2
    exit 1
  fi
  sleep 0.1
done
if [ -z "$driver_port" ]; then
  cat "$driver_log" >&2
  echo 'ChromeDriver did not become ready within 10 seconds.' >&2
  exit 1
fi

result=0
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/zstandard_web_integration_test.dart \
  --driver-port="$driver_port" \
  --chrome-binary="$CHROME_EXECUTABLE" \
  -d web-server || result=$?
if [ "$result" -ne 0 ]; then
  tail -n 50 "$driver_log" >&2
fi
exit "$result"
