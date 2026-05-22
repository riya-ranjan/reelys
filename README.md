# Reelys

Reelys are a DIY sonified, light up heely shoe, designed from scratch as part of a capstone project for Stanford CCRMA's MUSIC250A: Physical Interaction Design for Music. 

## Hardware

## Arduino and Python Libraries

For reproducibility, here are the exact versions used. All sketches target the **Seeed XIAO nRF52840 Sense** board.

**Board package** (install via Arduino IDE → Tools → Board → Boards Manager…):

  * **Seeed nRF52 Boards** — v1.1.12.
    Bundles the Adafruit Bluefruit nRF52 BLE stack (`bluefruit.h`) used by both BLE sketches, so no separate Bluefruit install is needed.
    To make the package available in Boards Manager, first add the index URL under **Arduino IDE → Settings → Additional boards manager URLs**:
    `https://files.seeedstudio.com/arduino/package_seeeduino_boards_index.json`

**Libraries** (install via Arduino IDE → Tools → Manage Libraries…):

  * **Seeed Arduino LSM6DS3** — v2.0.5. Driver for the onboard LSM6DS3TR-C IMU.
    https://github.com/Seeed-Studio/Seeed_Arduino_LSM6DS3
  * **MIDI Library** by Francois Best / lathoub — v5.0.2. Wraps Bluefruit's `BLEMidi` transport so the standard `MIDI.sendControlChange(...)` API works over BLE.

**Python (laptop side, debug listener only)** — pinned in `requirements.txt`:

  * **bleak** ≥0.21. Cross-platform BLE client used by `tools/ble_listener.py` to read the custom characteristic exposed by `imu_ble`. Install with `pip install -r requirements.txt`.

## Usage
