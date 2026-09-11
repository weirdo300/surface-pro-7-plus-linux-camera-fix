# Upstream status

The INT3472 POWER1 GPIO type (`0x08`) support required for the Surface
Pro 7+ rear OV8865 camera has been developed for upstream Linux.

The relevant upstream change maps POWER1 to the `dvdd` regulator
connection used by the camera sensor and adds the corresponding
INT3472 GPIO type handling.

This repository documents the implementation and validation on a
Surface Pro 7+ running Linux kernel `6.19.8-surface-3`.

The upstream implementation should be preferred once available in
the kernel used by the system.

This repository should therefore be treated as a reproducibility and
hardware-validation reference rather than a permanent fork of the
kernel driver.
