#!/bin/bash
set -euo pipefail
export RUNNER_TEMP="$(mktemp -d)"
export GITHUB_ENV="$RUNNER_TEMP/env" GITHUB_PATH="$RUNNER_TEMP/path"
export ANDROID=true DESKTOP=true COVERAGE=true ARM64=true
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
gcc "$RUNNER_TEMP/probe.c" $(pkg-config --cflags --libs gtk+-3.0) -o "$RUNNER_TEMP/probe"
"$RUNNER_TEMP/probe"
printf 'int main(void){return 0;}\n' > "$RUNNER_TEMP/cross.c"
aarch64-linux-gnu-gcc "$RUNNER_TEMP/cross.c" -o "$RUNNER_TEMP/cross"
readelf -h "$RUNNER_TEMP/cross" | grep AArch64
[[ "$(sha256sum /var/lib/dpkg/status)" == "$before" ]]
printf 'ROOTLESS_FIXTURE_PASS uid=%s host_dpkg_unchanged=true gtk_compile=true coverage_tools=true arm64_cross_compile=true\n' "$(id -u)"
