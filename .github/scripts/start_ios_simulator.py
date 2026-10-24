"""Create a fresh CI simulator without reusing or stopping personal devices."""

import json
import os
import subprocess
import uuid


def start():
    result = subprocess.run(
        ["xcrun", "simctl", "list", "devices", "available", "--json"],
        check=True, capture_output=True, text=True, timeout=30,
    )
    candidates = []
    for runtime, devices in json.loads(result.stdout).get("devices", {}).items():
        if not runtime.startswith("com.apple.CoreSimulator.SimRuntime.iOS-"):
            continue
        for device in devices:
            kind = device.get("deviceTypeIdentifier", "")
            if device.get("isAvailable") and kind.startswith("com.apple.CoreSimulator.SimDeviceType.iPhone-"):
                candidates.append((runtime, kind, device.get("name")))
    if not candidates:
        raise RuntimeError("Xcode needs an available iPhone simulator and its installed iOS runtime.")
    preferred = os.environ.get("ZSTANDARD_IOS_DEVICE", "iPhone 16")
    runtime, kind, _ = next((item for item in candidates if item[2] == preferred), candidates[0])
    name = "zstandard-{}-{}-{}-{}".format(
        os.environ["GITHUB_RUN_ID"], os.environ["GITHUB_RUN_ATTEMPT"],
        os.environ["GITHUB_JOB"], uuid.uuid4().hex[:8],
    )
    created = subprocess.run(
        ["xcrun", "simctl", "create", name, kind, runtime],
        check=True, capture_output=True, text=True, timeout=30,
    )
    device_id = str(uuid.UUID(created.stdout.strip())).upper()
    # Record ownership before boot so an interrupted boot can still be cleaned up.
    with open(os.environ["GITHUB_OUTPUT"], "a", encoding="utf-8") as output:
        output.write(f"device-id={device_id}\n")
    subprocess.run(["xcrun", "simctl", "boot", device_id], check=True, timeout=30)
    subprocess.run(["xcrun", "simctl", "bootstatus", device_id, "-b"], check=True, timeout=120)


if __name__ == "__main__":
    start()
