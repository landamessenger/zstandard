"""Exercise SDK provisioning from a tools-only runner without starting a device."""
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

SCRIPT = Path(__file__).resolve().parents[1] / 'run_android_emulator_ci.sh'


class AndroidProvisioningTests(unittest.TestCase):
    def exercise(self, install_fails):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            sdk = root / 'sdk'
            tools = sdk / 'cmdline-tools/latest/bin'
            tools.mkdir(parents=True)
            trace = root / 'trace'
            manager = tools / 'sdkmanager'
            manager.write_text('''#!/bin/bash
set -eu
if [[ "$1" == --licenses ]]; then exit 0; fi
printf 'install\\n' >> "$TRACE"
if [[ "$INSTALL_FAILS" == true ]]; then exit 42; fi
mkdir -p "$ANDROID_SDK_ROOT/platform-tools" "$ANDROID_SDK_ROOT/emulator"
printf '#!/bin/bash\\nexit 0\\n' > "$ANDROID_SDK_ROOT/platform-tools/adb"
printf '#!/bin/bash\\nexit 0\\n' > "$ANDROID_SDK_ROOT/emulator/emulator"
chmod +x "$ANDROID_SDK_ROOT/platform-tools/adb" "$ANDROID_SDK_ROOT/emulator/emulator"
''')
            avd = tools / 'avdmanager'
            avd.write_text('#!/bin/bash\nprintf "avd\\n" >> "$TRACE"\nexit 43\n')
            manager.chmod(0o755)
            avd.chmod(0o755)
            env = os.environ.copy()
            env.update(HOME=str(root), ANDROID_HOME=str(sdk), ANDROID_SDK_ROOT=str(sdk),
                       PATH=str(tools) + ':/usr/bin:/bin', TRACE=str(trace),
                       INSTALL_FAILS=str(install_fails).lower())
            result = subprocess.run(['bash', str(SCRIPT), 'true'], env=env,
                                    text=True, capture_output=True, timeout=10)
            return result, trace.read_text() if trace.exists() else ''

    def test_tools_only_sdk_is_provisioned_before_emulator_validation(self):
        result, trace = self.exercise(False)
        self.assertEqual(result.returncode, 43, result.stdout + result.stderr)
        self.assertEqual(trace, 'install\navd\n')
        self.assertNotIn('executable is missing', result.stderr)

    def test_install_failure_stops_before_avd_or_device_creation(self):
        result, trace = self.exercise(True)
        self.assertEqual(result.returncode, 42, result.stdout + result.stderr)
        self.assertEqual(trace, 'install\n')


if __name__ == '__main__':
    unittest.main()
