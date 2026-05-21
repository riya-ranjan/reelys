// Reelys — imu_ble_midi
// Read the onboard LSM6DS3TR-C IMU on the Seeed XIAO nRF52840 Sense at
// ~50 Hz, advertise as a standard BLE MIDI peripheral, and stream each
// axis as a 7-bit MIDI CC. Keep echoing the same CSV to USB serial so
// the imu_serial manual test still works when plugged in.
//
// This sketch is mutually exclusive with imu_ble.ino — they advertise
// the same device name but expose different BLE services. Flash this
// one when you want sound out of Max; reflash imu_ble.ino if you need
// the raw-float Python debug pipeline.
//
// Change detection / hysteresis:
//   The LSM6DS3 is very sensitive — a stationary shoe still produces
//   small jitter in the IMU readings. Sending a CC for every sample
//   would flood Max with ~300 msg/s of mostly-redundant updates. So
//   each CC is only sent when its newly-scaled 7-bit value differs
//   from the last *sent* value by at least CC_DELTA_THRESHOLD LSBs.
//   At rest: near-zero BLE traffic. In motion: bounded at 6 msgs per
//   sample × 50 Hz = 300 msg/s worst case.
//   Tune CC_DELTA_THRESHOLD up if Max still feels jittery, or down
//   (to 1) if small gestures aren't moving the CCs.
//
// Build / upload:
//   Board:     Tools → Board → Seeed nRF52 Boards → "Seeed XIAO nRF52840 Sense"
//   Libraries: - "Seeed Arduino LSM6DS3" via Library Manager (same as imu_ble)
//              - "MIDI Library" by FortySevenEffects via Library Manager  <-- NEW
//                https://github.com/FortySevenEffects/arduino_midi_library
//              The Bluefruit nRF52 library is bundled with the Seeed nRF52
//              board package — no separate install needed.
//   Upload:    Upload (→) in the IDE; double-tap reset if it doesn't enumerate.
//
// Pair on macOS:
//   1. Open Audio MIDI Setup.app → Window → Show MIDI Studio.
//   2. Double-click the "Bluetooth" icon.
//   3. "Reelys-L" should appear in the device list — click "Connect".
//   4. The shoe is now a system-wide MIDI source. Any DAW or Max patch
//      can read its CCs via standard MIDI input.
//
// Verify in Max:
//   With one shoe connected: drop six [ctlin N] objects (N=1..6), each into
//   a number box. Right-click each ctlin → Input → select the shoe's name
//   ("Reelys-L" or "Reelys-R") to avoid crosstalk with other MIDI devices.
//   With both shoes connected: use [ctlin N C] where C is the channel
//   (1 for left, 2 for right) — e.g. [ctlin 1 1] for left ax, [ctlin 1 2]
//   for right ax. Channel filtering is how Max distinguishes the two shoes.
//   Wiggle the shoe — values should update when motion exceeds the
//   hysteresis threshold (default 2 LSB on a 0–127 scale).
//
// BLE protocol:
//   Device name:    "Reelys-L"  (left shoe; right shoe will use "-R")
//   Service UUID:   03B80E5A-EDE8-4B33-A024-BC7BDC5DA0EF  (standard BLE MIDI)
//   Char   UUID:    7772E5DB-3868-4112-A1A9-F2669D106BF3  (standard BLE MIDI)
//   These UUIDs come from Apple's BLE MIDI 1.0 spec — do not invent custom ones.
//
// Shoe identity (build-time switch):
//   Flip the REELYS_SHOE_RIGHT macro near the top of the code from 0 to 1
//   before flashing the *right* shoe. That selects:
//     0 → device name "Reelys-L", MIDI channel 1  (default; left shoe)
//     1 → device name "Reelys-R", MIDI channel 2  (right shoe)
//   CC numbers (1..6) are identical on both shoes; Max distinguishes left
//   vs right by channel. The sketch is otherwise identical between shoes,
//   so any future tweak (hysteresis, sample rate, scaling) lives in one
//   place and applies to both. Remember to flip the macro back to 0 before
//   reflashing the left shoe.
//
// Calibration — tilt-focused:
//   The accel range is clamped to ±1 g, not the full ±16 g the sensor reports.
//   Rationale: gravity projected onto any single axis is always within ±1 g,
//   so for tilt sensing the entire 0..127 CC range is spent on orientation
//   instead of wasted on impact headroom. The tradeoff is that any accel
//   spike above 1 g (heel-strike, stomp) saturates the accel CCs at 0 or 127.
//   This is intentional — stomp / impact handling will widen the range later.
//   Gyro stays at ±2000°/s (still useful as "how fast the shoe is rotating").
//
// MIDI CC mapping (channel 1):
//   CC 1 → ax (accel X, forward)   range ±1 g     mapped to 0..127
//   CC 2 → ay (accel Y, lateral)   range ±1 g     mapped to 0..127
//   CC 3 → az (accel Z, vertical)  range ±1 g     mapped to 0..127
//   CC 4 → gx (gyro X)             range ±2000°/s mapped to 0..127
//   CC 5 → gy (gyro Y)             range ±2000°/s mapped to 0..127
//   CC 6 → gz (gyro Z)             range ±2000°/s mapped to 0..127
//   Stationary, shoe flat: CC1/CC2 ≈ 64, CC3 ≈ 127 (1 g of gravity pins az
//   to the top of the ±1 g range), CC4..6 ≈ 64. Tilting the shoe sweeps
//   CC1/CC2 across the full 0..127 range as the gravity vector rotates.
//
// CSV format (USB serial, one line per sample — unchanged from imu_serial /
// imu_ble, and printed every sample regardless of BLE connection state):
//   timestamp_ms,ax,ay,az,gx,gy,gz

#include <bluefruit.h>
#include <MIDI.h>
#include "LSM6DS3.h"
#include "Wire.h"

// ---------------- Shoe identity (build-time) ----------------

// Flip to 1 before flashing the right shoe; flip back to 0 before flashing
// the left shoe. See the "Shoe identity" block in the header comment.
#define REELYS_SHOE_RIGHT 0

#if REELYS_SHOE_RIGHT
  static const char*   REELYS_DEVICE_NAME = "Reelys-R";
  static const uint8_t MIDI_CHANNEL       = 2;
#else
  static const char*   REELYS_DEVICE_NAME = "Reelys-L";
  static const uint8_t MIDI_CHANNEL       = 1;
#endif

// ---------------- IMU ----------------
static LSM6DS3 imu(I2C_MODE, 0x6A);
static const unsigned long SAMPLE_PERIOD_MS = 20;  // ~50 Hz

// ---------------- MIDI mapping ----------------

// Accel clamp is set to ±1 g — tilt-focused. See the "Calibration" block in
// the header comment for the full rationale and the impact-saturation tradeoff.
static const float   ACCEL_RANGE_G   = 1.0f;
static const float   GYRO_RANGE_DPS  = 2000.0f;
// MIDI_CHANNEL is defined in the "Shoe identity" block above (1 = left, 2 = right).

// CC numbers per IMU axis, in [ax, ay, az, gx, gy, gz] order.
static const uint8_t CC_NUMS[6] = { 1, 2, 3, 4, 5, 6 };

// Hysteresis on the 7-bit CC value — only send when the new scaled value
// has moved at least this many LSBs from the last sent value. 2 LSB on a
// 0..127 scale is ~1.6% of full range, enough to swallow stationary IMU
// jitter while still catching small intentional gestures.
static const int CC_DELTA_THRESHOLD = 2;

// Sentinel 255 is out-of-range for a 7-bit CC, so the first scaled sample
// always exceeds the delta threshold and is sent — that gives Max a baseline.
static uint8_t cc_last[6] = { 255, 255, 255, 255, 255, 255 };

// ---------------- BLE MIDI ----------------

static BLEDis   bledis;
static BLEMidi  blemidi;
MIDI_CREATE_BLE_INSTANCE(blemidi);

// ---------------- helpers ----------------

static void halt(const char* reason) {
  for (;;) {
    Serial.print("[FATAL] ");
    Serial.println(reason);
    delay(1000);
  }
}

// Map a signed float into a 7-bit MIDI CC value with hard clamping.
// 0 maps to 64 (mid-range), ±range_abs maps to 0/127.
static uint8_t scaleToCC(float value, float range_abs) {
  if (value >  range_abs) value =  range_abs;
  if (value < -range_abs) value = -range_abs;
  float normalized = (value + range_abs) / (2.0f * range_abs);  // 0..1
  int cc = (int)(normalized * 127.0f + 0.5f);
  if (cc < 0)   cc = 0;
  if (cc > 127) cc = 127;
  return (uint8_t)cc;
}

static void startAdvertising() {
  Bluefruit.Advertising.addFlags(BLE_GAP_ADV_FLAGS_LE_ONLY_GENERAL_DISC_MODE);
  Bluefruit.Advertising.addTxPower();
  Bluefruit.Advertising.addService(blemidi);
  Bluefruit.ScanResponse.addName();  // name in scan response keeps adv packet under 31 bytes
  Bluefruit.Advertising.restartOnDisconnect(true);
  Bluefruit.Advertising.setInterval(32, 244);   // units of 0.625 ms → 20–152.5 ms
  Bluefruit.Advertising.setFastTimeout(30);
  Bluefruit.Advertising.start(0);               // 0 = advertise forever
}

// ---------------- Arduino entrypoints ----------------

void setup() {
  Serial.begin(115200);
  unsigned long t0 = millis();
  while (!Serial && (millis() - t0) < 2000) {
    delay(10);
  }

  if (imu.begin() != 0) {
    halt("LSM6DS3 init failed");
  }

  // BANDWIDTH_MAX must be set before Bluefruit.begin(). Not strictly required
  // for BLE MIDI's tiny 5-byte packets, but matches imu_ble and gives headroom
  // if all six CCs ever bundle into one connection event during fast motion.
  Bluefruit.configPrphBandwidth(BANDWIDTH_MAX);

  if (!Bluefruit.begin()) {
    halt("Bluefruit init failed");
  }
  Bluefruit.setName(REELYS_DEVICE_NAME);
  Bluefruit.setTxPower(4);  // dBm

  bledis.setManufacturer("Reelys");
  bledis.setModel(REELYS_DEVICE_NAME);
  bledis.begin();

  // MIDI.begin() internally calls blemidi.begin() to register the GATT service.
  // OMNI just controls input filtering — we only send, so it's a no-op for us.
  MIDI.begin(MIDI_CHANNEL_OMNI);

  startAdvertising();

  Serial.println("# Reelys / imu_ble_midi");
  Serial.println("# Streaming IMU over BLE MIDI + USB serial");
  Serial.print  ("# Device name: ");
  Serial.print  (REELYS_DEVICE_NAME);
  Serial.println(" (BLE MIDI peripheral)");
  Serial.println("# Sample rate: ~50 Hz");
  Serial.println("# CC hysteresis: 2 LSB (sends suppressed below threshold)");
  Serial.println("# Units: accel in g, gyro in deg/s");
  Serial.print  ("# CC mapping: CC1=ax CC2=ay CC3=az CC4=gx CC5=gy CC6=gz (ch ");
  Serial.print  (MIDI_CHANNEL);
  Serial.println(")");
  Serial.println("timestamp_ms,ax,ay,az,gx,gy,gz");
}

void loop() {
  unsigned long t = millis();

  float data[6];
  data[0] = imu.readFloatAccelX();
  data[1] = imu.readFloatAccelY();
  data[2] = imu.readFloatAccelZ();
  data[3] = imu.readFloatGyroX();
  data[4] = imu.readFloatGyroY();
  data[5] = imu.readFloatGyroZ();

  // Always print raw CSV to USB serial — independent of BLE state — so the
  // imu_serial manual test still works when plugged in for debugging.
  Serial.print(t);
  for (int i = 0; i < 6; i++) {
    Serial.print(',');
    Serial.print(data[i], 4);
  }
  Serial.println();

  // Stream changed CCs over BLE MIDI when a central is connected and ready.
  if (Bluefruit.connected() && blemidi.notifyEnabled()) {
    const float ranges[6] = {
      ACCEL_RANGE_G, ACCEL_RANGE_G, ACCEL_RANGE_G,
      GYRO_RANGE_DPS, GYRO_RANGE_DPS, GYRO_RANGE_DPS,
    };
    for (int i = 0; i < 6; i++) {
      uint8_t cc_new = scaleToCC(data[i], ranges[i]);
      int delta = (int)cc_new - (int)cc_last[i];
      if (delta < 0) delta = -delta;
      if (delta >= CC_DELTA_THRESHOLD) {
        MIDI.sendControlChange(CC_NUMS[i], cc_new, MIDI_CHANNEL);
        cc_last[i] = cc_new;
      }
    }
  }

  unsigned long elapsed = millis() - t;
  if (elapsed < SAMPLE_PERIOD_MS) {
    delay(SAMPLE_PERIOD_MS - elapsed);
  }
}
