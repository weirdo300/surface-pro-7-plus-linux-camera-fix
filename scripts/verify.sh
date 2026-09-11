#!/usr/bin/env bash

set -u

echo "=== Surface Pro 7+ Linux Camera Verification ==="
echo

echo "=== SYSTEM ==="
uname -a
echo
cat /etc/os-release | grep -E '^(NAME|VERSION|VERSION_ID)='
echo

echo "=== KERNEL ==="
uname -r
echo

echo "=== SECURE BOOT ==="
if command -v mokutil >/dev/null 2>&1; then
    mokutil --sb-state
else
    echo "mokutil not installed"
fi
echo

echo "=== IPU6 PCI DEVICE ==="
lspci -nn | grep -Ei 'multimedia|ipu6|9a19' || true
echo

echo "=== INT3472 MODULE ==="
if modinfo intel_skl_int3472_discrete >/dev/null 2>&1; then
    modinfo intel_skl_int3472_discrete | grep -E '^(filename|srcversion|vermagic|signer):'
else
    echo "intel_skl_int3472_discrete module not found"
fi
echo

echo "=== LOADED CAMERA MODULES ==="
lsmod | grep -E 'intel_ipu6|ipu_bridge|ov5693|ov8865|ov7251|int3472' || true
echo

echo "=== CAMERA DEVICES ==="
if command -v v4l2-ctl >/dev/null 2>&1; then
    v4l2-ctl --list-devices || true
else
    echo "v4l2-ctl not installed"
fi
echo

echo "=== LIBCAMERA ==="
if command -v cam >/dev/null 2>&1; then
    cam --version
    echo
    cam --list
else
    echo "cam not installed"
fi
echo

echo "=== INT3472 POWER1 / DVDD ==="
dmesg | grep -Ei 'INT3472:01|POWER1|type 0x08|con_id=dvdd|register_regulator' | tail -n 30 || true
echo

echo "=== OV8865 ==="
dmesg | grep -Ei 'ov8865|dw9719' | tail -n 30 || true
echo

echo "=== OV5693 ==="
dmesg | grep -Ei 'ov5693' | tail -n 30 || true
echo

echo "=== OV7251 ==="
dmesg | grep -Ei 'ov7251' | tail -n 30 || true
echo

echo "=== VERIFICATION COMPLETE ==="
