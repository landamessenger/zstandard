import importlib.util
import json
import os
import pathlib
import subprocess
import tempfile
import unittest
from unittest.mock import Mock, patch


path = pathlib.Path(__file__).parents[1] / "start_ios_simulator.py"
spec = importlib.util.spec_from_file_location("start_ios_simulator", path)
simulator = importlib.util.module_from_spec(spec)
spec.loader.exec_module(simulator)
RUNTIME = "com.apple.CoreSimulator.SimRuntime.iOS-27-0"
KIND = "com.apple.CoreSimulator.SimDeviceType.iPhone-16"
EXISTING = "AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA"
CREATED = "BBBBBBBB-BBBB-BBBB-BBBB-BBBBBBBBBBBB"


class SimulatorTests(unittest.TestCase):
    def prepare(self, folder):
        return patch.dict(os.environ, {"GITHUB_RUN_ID": "12", "GITHUB_RUN_ATTEMPT": "1", "GITHUB_JOB": "ios", "GITHUB_OUTPUT": str(pathlib.Path(folder) / "output")})

    @patch.object(simulator.subprocess, "run")
    def test_booted_personal_device_is_only_used_as_type_metadata(self, command):
        devices = {"devices": {RUNTIME: [{"name": "iPhone 16", "deviceTypeIdentifier": KIND, "isAvailable": True, "state": "Booted", "udid": EXISTING}]}}
        command.side_effect = [Mock(stdout=json.dumps(devices)), Mock(stdout=CREATED), Mock(), Mock()]
        with tempfile.TemporaryDirectory() as folder, self.prepare(folder):
            simulator.start()
            self.assertEqual((pathlib.Path(folder) / "output").read_text(), f"device-id={CREATED}\n")
        self.assertEqual(command.call_args_list[1].args[0][-2:], [KIND, RUNTIME])
        self.assertEqual(command.call_args_list[2].args[0], ["xcrun", "simctl", "boot", CREATED])
        self.assertNotIn(EXISTING, str(command.call_args_list))

    @patch.object(simulator.subprocess, "run", return_value=Mock(stdout='{"devices": {}}'))
    def test_missing_ios_runtime_fails_before_creating_a_device(self, command):
        with self.assertRaisesRegex(RuntimeError, "installed iOS runtime"):
            simulator.start()
        self.assertEqual(command.call_count, 1)

    @patch.object(simulator.subprocess, "run")
    def test_failed_boot_preserves_created_device_id_for_cleanup(self, command):
        devices = {"devices": {RUNTIME: [{"name": "iPhone 16", "deviceTypeIdentifier": KIND, "isAvailable": True}]}}
        command.side_effect = [Mock(stdout=json.dumps(devices)), Mock(stdout=CREATED), subprocess.CalledProcessError(1, "boot")]
        with tempfile.TemporaryDirectory() as folder, self.prepare(folder):
            with self.assertRaises(subprocess.CalledProcessError):
                simulator.start()
            self.assertEqual((pathlib.Path(folder) / "output").read_text(), f"device-id={CREATED}\n")


if __name__ == "__main__":
    unittest.main()
