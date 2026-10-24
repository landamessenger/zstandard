"""Execute the real read-only admission script before any checkout or write."""
import os
from pathlib import Path
import subprocess
import unittest

import yaml

ROOT = Path(__file__).resolve().parents[3]
WORKFLOW = yaml.load((ROOT / '.github/workflows/hotfix_workflow.yml').read_text(), Loader=yaml.BaseLoader)
SCRIPT = WORKFLOW['jobs']['validate']['steps'][0]['with']['script']


class HotfixRefTests(unittest.TestCase):
    def admit(self, ref, tree='hotfix'):
        env = {key: value for key, value in os.environ.items()
               if key in ['PATH', 'LD_LIBRARY_PATH', 'SYSTEMROOT']}
        env.update(MODE='prepare', OPERATION_ID='', VERSION='1.2.3', ISSUE='1',
                   TITLE='Fixture', CHANGELOG='Fixture', HOTFIX_REF=ref, HOTFIX_TREE=tree)
        return subprocess.run(['node', '-e',
                               'globalThis.core={setFailed:(message)=>{console.error(message);process.exitCode=1;}};\n' + SCRIPT],
                              env=env, capture_output=True, text=True, timeout=10)

    def test_matching_default_and_custom_hotfix_refs_are_accepted(self):
        for tree in ['hotfix', 'maintenance/hotfix']:
            with self.subTest(tree=tree):
                result = self.admit(f'refs/heads/{tree}/1.2.3', tree)
                self.assertEqual(result.returncode, 0, result.stderr)

    def test_protected_tag_and_wrong_version_refs_are_rejected(self):
        for ref in ['refs/heads/master', 'refs/heads/develop',
                    'refs/tags/v1.2.3', 'refs/heads/hotfix/1.2.2']:
            with self.subTest(ref=ref):
                result = self.admit(ref)
                self.assertNotEqual(result.returncode, 0, ref)
                self.assertIn('matching hotfix branch', result.stderr)


if __name__ == '__main__':
    unittest.main()
