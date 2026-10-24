"""Run the shared preparation commands with real Dart metadata tools.

Only the Emscripten compiler is replaced by a deterministic artifact producer;
the existing Web CI separately rebuilds and verifies the canonical Wasm.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

import yaml

ROOT = Path(__file__).resolve().parents[3]
ACTION = yaml.safe_load((ROOT / '.github/actions/prepare-package-release/action.yml').read_text())
PACKAGES = ['zstandard', 'zstandard_android', 'zstandard_cli', 'zstandard_ios',
            'zstandard_linux', 'zstandard_macos', 'zstandard_native',
            'zstandard_platform_interface', 'zstandard_web', 'zstandard_windows']


class PackagePreparationTests(unittest.TestCase):
    def setUp(self):
        self.folder = tempfile.TemporaryDirectory()
        self.addCleanup(self.folder.cleanup)
        self.workspace = Path(self.folder.name)
        files = ['CHANGELOG.md', '.github/scripts/update_versions.dart',
                 'scripts/check_pub_metadata.dart', 'zstandard_native/src/zstd/zstd.h',
                 'zstandard_ios/ios/zstandard_ios/Package.swift',
                 'zstandard_macos/macos/zstandard_macos/Package.swift',
                 'zstandard_ios/ios/zstandard_ios.podspec',
                 'zstandard_macos/macos/zstandard_macos.podspec']
        files += [f'{package}/{name}' for package in PACKAGES
                  for name in ['pubspec.yaml', 'README.md', 'CHANGELOG.md', 'LICENSE']]
        for file in files:
            target = self.workspace / file
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(ROOT / file, target)
        build = self.workspace / 'scripts/build_web_wasm.sh'
        build.write_text('''set -eu
for folder in zstandard_web/blob zstandard_web/example/web zstandard/example/web; do
  mkdir -p "$folder"
  printf 'fixture-js' > "$folder/zstd.js"
  printf 'fixture-wasm' > "$folder/zstd.wasm"
done
''')
        subprocess.run(['git', 'init', '-q', str(self.workspace)], check=True)

    def prepare(self, resume=False):
        inputs = {'version': '9.8.7', 'title': 'Fixture',
                  'changelog': 'Literal $(touch unexpected) text'}
        for step in ACTION['runs']['steps']:
            if 'run' not in step or (resume and 'if' in step):
                continue
            env = {key: value for key, value in os.environ.items()
                   if key in ['PATH', 'LD_LIBRARY_PATH', 'SYSTEMROOT']}
            env['HOME'] = self.folder.name
            for key, value in step.get('env', {}).items():
                for name, content in inputs.items():
                    value = value.replace('${{ inputs.' + name + ' }}', content)
                if '${{' not in value:
                    env[key] = value
            result = subprocess.run(['bash', '-e', '-o', 'pipefail', '-c', step['run']],
                                    cwd=self.workspace, env=env, text=True,
                                    capture_output=True, timeout=60)
            if result.returncode:
                return result
        return result

    def test_prepares_all_packages_and_validates_real_metadata(self):
        result = self.prepare()
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn('10 packages', result.stdout)
        for package in PACKAGES:
            self.assertIn('version: 9.8.7', (self.workspace / package / 'pubspec.yaml').read_text())
            self.assertEqual((self.workspace / package / 'CHANGELOG.md').read_bytes(),
                             (self.workspace / 'CHANGELOG.md').read_bytes())
        self.assertFalse((self.workspace / 'unexpected').exists())
        self.assertFalse((self.workspace / 'zstandard_cli/pubspec_overrides.yaml').exists())

    def test_repeat_preparation_is_idempotent(self):
        self.assertEqual(self.prepare().returncode, 0)
        before = (self.workspace / 'CHANGELOG.md').read_bytes()
        self.assertEqual(self.prepare().returncode, 0)
        self.assertEqual(before, (self.workspace / 'CHANGELOG.md').read_bytes())

    def test_resume_rejects_corrupt_artifacts_without_rewriting_them(self):
        self.assertEqual(self.prepare().returncode, 0)
        broken = self.workspace / 'zstandard/example/web/zstd.wasm'
        broken.write_bytes(b'broken')
        self.assertNotEqual(self.prepare(resume=True).returncode, 0)
        self.assertEqual(broken.read_bytes(), b'broken')


if __name__ == '__main__':
    unittest.main()
