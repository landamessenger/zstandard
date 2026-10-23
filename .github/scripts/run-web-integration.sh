#!/usr/bin/env bash
set -euo pipefail

driver_log="$(mktemp "$RUNNER_TEMP/zstandard-chromedriver.XXXXXX")"
"$CHROMEDRIVER_EXECUTABLE" --port=0 > "$driver_log" 2>&1 &
driver_pid=$!
cleanup() {
  kill "$driver_pid" 2>/dev/null || true
  wait "$driver_pid" 2>/dev/null || true
}
trap cleanup EXIT

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

flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/zstandard_web_integration_test.dart \
  --driver-port="$driver_port" \
  --chrome-binary="$CHROME_EXECUTABLE" \
  -d web-server
