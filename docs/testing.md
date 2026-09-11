# Testing

## Environment

Hardware:

- Microsoft Surface Pro 7+
- Intel Core i5-1135G7
- Intel IPU6
- OV8865 rear camera
- OV5693 front camera

Software:

- Linux Mint 22.3
- Ubuntu 24.04 base
- Linux kernel `6.19.8-surface-3`
- libcamera `0.7.1`
- Secure Boot enabled

## Rear camera validation

The rear camera was tested after a complete reboot without manually
configuring the media topology.

Command:

    cam \
      --camera '\_SB_.PC00.I2C3.CAMR' \
      --capture=100 \
      --metadata

Observed result:

- 100 frames captured
- every frame reported `bytesused: 31961088`
- approximately 15 fps
- exit code `0`

The test therefore verified the complete path:

    OV8865 -> IPU6 -> libcamera -> SoftISP

## Power-resource validation

After reboot the kernel reported:

    GPIO type 0x08 detected
    con_id=dvdd
    register_regulator returned: 0

The OV8865 driver subsequently reported:

    Instantiated dw9719 VCM

No OV8865 `-121` initialization failure was observed after the
POWER1/dvdd fix.

## Reboot persistence

The system was rebooted after installation of the signed module.

After reboot:

- kernel remained `6.19.8-surface-3`
- Secure Boot remained enabled
- the modified INT3472 module was loaded
- POWER1 was mapped to `dvdd`
- the OV8865 VCM instantiated
- libcamera detected the rear camera
- 100/100 rear frames were captured successfully

## Notes

The media topology and CSI2 formats may appear at their default state
immediately after boot. libcamera configures the required pipeline
when the camera is opened.

No permanent `media-ctl` configuration was therefore added.
