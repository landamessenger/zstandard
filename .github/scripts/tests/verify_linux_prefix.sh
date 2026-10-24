#!/bin/bash
set -euo pipefail
export RUNNER_TEMP="$(mktemp -d)"
export GITHUB_ENV="$RUNNER_TEMP/env" GITHUB_PATH="$RUNNER_TEMP/path"
export ANDROID=false DESKTOP=true COVERAGE=true ARM64=true BROWSER=true
before="$(sha256sum /var/lib/dpkg/status)"
bash /contract/action.sh
while IFS= read -r line; do export "$line"; done < "$GITHUB_ENV"
while IFS= read -r directory; do export PATH="$directory:$PATH"; done < "$GITHUB_PATH"
clang --version | head -1
cmake --version | head -1
ninja --version
lcov --version | grep -E "LCOV version [0-9]"
[[ "$(printf '1+1\n' | bc)" == 2 ]]
printf 'TN:\nSF:lib/probe.dart\nDA:1,1\nDA:2,0\nLF:2\nLH:1\nend_of_record\n' > "$RUNNER_TEMP/lcov.info"
lcov --rc function_coverage=0 --extract "$RUNNER_TEMP/lcov.info" 'lib/*' -o "$RUNNER_TEMP/lcov-lib.info"
lcov --rc function_coverage=0 --summary "$RUNNER_TEMP/lcov-lib.info" 2>&1 | grep '50.0%'
printf '#include <gtk/gtk.h>\nint main(void){return gtk_get_major_version()!=3;}\n' > "$RUNNER_TEMP/probe.c"
prefix="${ZSTANDARD_LCOV_BIN%/usr/bin}"
# Cross/Android profiles must never inject host headers into another sysroot.

gcc -isystem "$prefix/usr/include" -isystem "$prefix/usr/include/x86_64-linux-gnu" "$RUNNER_TEMP/probe.c" -L"$prefix/usr/lib/x86_64-linux-gnu" $(PKG_CONFIG_SYSROOT_DIR="$prefix" PKG_CONFIG_PATH="$prefix/usr/lib/x86_64-linux-gnu/pkgconfig:$prefix/usr/share/pkgconfig" pkg-config --cflags --libs gtk+-3.0) -o "$RUNNER_TEMP/probe"
"$RUNNER_TEMP/probe"
printf '#include <stdio.h>\nint main(void){return puts("cross")<0;}\n' > "$RUNNER_TEMP/cross.c"
env -u CPATH -u LIBRARY_PATH -u PKG_CONFIG_PATH -u PKG_CONFIG_SYSROOT_DIR -u CMAKE_PREFIX_PATH aarch64-linux-gnu-gcc "$RUNNER_TEMP/cross.c" -o "$RUNNER_TEMP/cross"
readelf -h "$RUNNER_TEMP/cross" | grep AArch64
# Download the same stable Chrome for Testing channel as the Web jobs. The
# container has no host socket or privileged namespace; no-sandbox is confined
# to this isolated fixture, never added to the actual browser test workflow.
if [[ ! -r /etc/ssl/certs/ca-certificates.crt ]]; then
  cat "$prefix/usr/share/ca-certificates/mozilla/"*.crt > "$RUNNER_TEMP/ca-certificates.crt"
  export CURL_CA_BUNDLE="$RUNNER_TEMP/ca-certificates.crt"
fi
curl --fail --silent --show-error --location --max-time 30 https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE_STABLE -o "$RUNNER_TEMP/chrome-version"
chrome_version="$(cat "$RUNNER_TEMP/chrome-version")"
[[ "$chrome_version" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]
curl --fail --silent --show-error --location --max-time 180 "https://storage.googleapis.com/chrome-for-testing-public/$chrome_version/linux64/chrome-linux64.zip" -o "$RUNNER_TEMP/chrome.zip"
unzip -q "$RUNNER_TEMP/chrome.zip" -d "$RUNNER_TEMP"
chrome="$RUNNER_TEMP/chrome-linux64/chrome"
if ldd "$chrome" | grep 'not found'; then
  echo 'Chrome has unresolved private runtime dependencies.' >&2
  exit 1
fi
timeout --foreground 60s "$chrome" --headless --no-sandbox --disable-dev-shm-usage --dump-dom 'data:text/html,<title>rootless-browser-pass</title>' > "$RUNNER_TEMP/browser.html" 2> "$RUNNER_TEMP/browser.log"
grep '<title>rootless-browser-pass</title>' "$RUNNER_TEMP/browser.html"
[[ "$(sha256sum /var/lib/dpkg/status)" == "$before" ]]
printf 'ROOTLESS_FIXTURE_PASS uid=%s host_dpkg_unchanged=true gtk_compile=true coverage_tools=true arm64_cross_compile=true browser_launch=true\n' "$(id -u)"
