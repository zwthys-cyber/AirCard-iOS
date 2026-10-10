#!/usr/bin/env python3
"""Check the packaged device binary, minimum OS, signature, and entitlements."""
import pathlib
import plistlib
import struct
import subprocess
import sys
import tempfile
import zipfile

with tempfile.TemporaryDirectory() as temporary:
    with zipfile.ZipFile(sys.argv[1]) as archive:
        assert archive.testzip() is None, "Corrupt IPA"
        archive.extractall(temporary)
    applications = list(pathlib.Path(temporary, "Payload").glob("*.app"))
    assert len(applications) == 1, "Expected one application"
    application = applications[0]
    info = plistlib.loads((application / "Info.plist").read_bytes())
    assert info["MinimumOSVersion"] == "17.0", info["MinimumOSVersion"]
    binary = application / info["CFBundleExecutable"]
    data = binary.read_bytes()
    header = struct.unpack_from("<8I", data)
    assert header[0] == 0xFEEDFACF and header[1] == 0x0100000C, "Expected arm64 Mach-O"
    offset = 32
    found_version = False
    for _ in range(header[4]):
        command, size = struct.unpack_from("<II", data, offset)
        if command in (0x32, 0x25):
            version = struct.unpack_from("<I", data, offset + (12 if command == 0x32 else 8))[0]
            assert version <= 0x00110000, f"Mach-O minimum OS exceeds 17.0: {version:#x}"
            found_version = True
        offset += size
    assert found_version, "Missing Mach-O deployment target"
    subprocess.run(["codesign", "--verify", "--strict", str(application)], check=True)
    signature = subprocess.run(["codesign", "--display", "--entitlements", ":-", str(binary)], check=True, capture_output=True)
    entitlements = plistlib.loads(signature.stdout)
    for key in ("platform-application", "com.apple.private.security.no-sandbox", "com.apple.private.security.storage.AppDataContainers"):
        assert entitlements.get(key) is True, f"Missing entitlement: {key}"
    print(f"Verified: {info['CFBundleIdentifier']}, arm64, iOS 17.0, signed with TrollStore entitlements")
