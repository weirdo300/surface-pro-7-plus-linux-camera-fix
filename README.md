# Surface Pro 7+ Linux Camera Fix

Tested camera support for the Microsoft Surface Pro 7+ on Linux.

This repository documents a working configuration for the integrated
OV8865 rear camera and OV5693 front camera using the Intel IPU6 camera
pipeline and libcamera SoftISP.

The rear-camera fix addresses an INT3472 ACPI POWER1 GPIO resource
(type `0x08`) which must be exposed to the OV8865 sensor as the `dvdd`
digital supply.

## Hardware

- Microsoft Surface Pro 7+
- SKU: `Surface_Pro_7+_1960`
- Intel Core i5-1135G7
- Intel IPU6
- Front camera: OV5693
- Rear camera: OV8865
- IR camera: OV7251

## Tested software

- Linux Mint 22.3
- Ubuntu 24.04 base
- Linux kernel: `6.19.8-surface-3`
- libcamera: `0.7.1`
- Secure Boot: enabled

## Rear camera problem

The OV8865 rear camera initially failed during initialization with
I2C remote I/O errors (`-121`).

The INT3472 ACPI device exposed GPIO type `0x08`, corresponding to
the POWER1 resource. The existing driver did not expose this resource
to the sensor as `dvdd`, causing the OV8865 digital supply to resolve
to a dummy regulator.

The required mapping is:

    INT3472 POWER1 (0x08)
            |
            v
          dvdd
            |
            v
         OV8865
            |
            v
          DW9719
            |
            v
          IPU6
            |
            v
    libcamera / SoftISP

## Validation

The fix was tested on a physical Surface Pro 7+.

After installing the signed INT3472 module and rebooting:

- Secure Boot remained enabled.
- The modified INT3472 module loaded successfully.
- INT3472 POWER1 (`0x08`) was detected.
- POWER1 was registered with `con_id=dvdd`.
- The OV8865 successfully instantiated its DW9719 VCM.
- Both front and rear cameras were enumerated by libcamera.
- The rear camera produced 100/100 frames.
- Rear capture completed with exit code `0`.
- Capture rate was approximately 15 fps.
- The rear camera continued to work after a full reboot.
- No manual `media-ctl` configuration was required for the successful
  libcamera test.

## Front camera

The front OV5693 camera was separately validated using the Surface
OV5693/IPU6 camera support and libcamera SoftISP.

The front camera is intentionally not modified by the rear-camera
INT3472 fix documented here.

## Important

This repository is a test/reference repository for the Surface Pro 7+
hardware described above. It is not intended to replace the upstream
Linux or linux-surface implementation.

The INT3472 POWER1 support has also been developed upstream. Users
should prefer an upstream kernel containing the relevant support when
available.

## Status

### Rear camera

**WORKING**

### Front camera

**WORKING**

### IR camera

**Not resolved by this repository**

The OV7251 IR sensor remains a separate issue involving its own
power/regulator initialization.

## Reproduction

See:

- `docs/testing.md`
- `docs/upstream.md`
- `scripts/verify.sh`


## License

This project is licensed under the MIT License. See `LICENSE` for details.
