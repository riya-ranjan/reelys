// Reelys — imu_ble
// Read the onboard LSM6DS3TR-C IMU on the Seeed XIAO nRF52840 Sense
// at ~50 Hz, stream samples over BLE as notifications, and keep
// echoing the same CSV to USB serial (so the imu_serial manual test
// still works when plugged in).
//
// Build / upload:
//   Board:    Tools → Board → Seeed nRF52 Boards → "Seeed XIAO nRF52840 Sense"
//   Library:  "Seeed Arduino LSM6DS3" via Library Manager.
//             The Bluefruit nRF52 library is bundled with the board package
//             — no separate install needed.
//   Upload:   Upload (→) in the IDE; double-tap reset if it doesn't enumerate.
//
// Observe:
//   - USB:    Tools → Serial Monitor, baud 115200. Same CSV format as imu_serial.
//   - BLE:    nRF Connect on phone → scan → "Reelys-L" should appear.
//             Connect, expand the custom service, enable notifications on the
//             characteristic to see 24-byte payloads stream in.
//   - Laptop: tools/ble_listener.py (added in the next step).
//
// BLE protocol:
//   Device name:        "Reelys-L"  (left shoe; right shoe will use "-R")
//   Service UUID:       9E6647DB-3EEC-42B6-8349-A95113E65082
//   Char   UUID:        AE7799DA-9123-45D5-84F9-20B5C3F7F6F4
//   Char   properties:  NOTIFY (no read/write)
//   Payload:            24 bytes = 6 IEEE 754 floats, little-endian, in order
//                       ax, ay, az, gx, gy, gz
//                       accel in g, gyro in deg/s
//
// CSV format (USB serial, one line per sample):
//   timestamp_ms,ax,ay,az,gx,gy,gz

#include <bluefruit.h>
#include "LSM6DS3.h"
#include "Wire.h"

// ---------------- IMU ----------------

static LSM6DS3 imu(I2C_MODE, 0x6A);
static const unsigned long SAMPLE_PERIOD_MS = 20;  // ~50 Hz

// ---------------- BLE ----------------

// 128-bit UUIDs in little-endian (wire) byte order — i.e. the textual
// UUID with its bytes reversed. The "human" UUIDs are in the header
// comment above. Don't edit one without updating the other.

// Service: 9E6647DB-3EEC-42B6-8349-A95113E65082
static const uint8_t SERVICE_UUID[16] = {
  0x82, 0x50, 0xE6, 0x13, 0x51, 0xA9, 0x49, 0x83,
  0xB6, 0x42, 0xEC, 0x3E, 0xDB, 0x47, 0x66, 0x9E
};

// Characteristic: AE7799DA-9123-45D5-84F9-20B5C3F7F6F4
static const uint8_t IMU_CHAR_UUID[16] = {
  0xF4, 0xF6, 0xF7, 0xC3, 0xB5, 0x20, 0xF9, 0x84,
  0xD5, 0x45, 0x23, 0x91, 0xDA, 0x99, 0x77, 0xAE
};

static BLEService        imuService(SERVICE_UUID);
static BLECharacteristic imuChar(IMU_CHAR_UUID);

// ---------------- helpers ----------------

static void halt(const char* reason) {
  for (;;) {
    Serial.print("[FATAL] ");
    Serial.println(reason);
    delay(1000);
  }
}

static void startAdvertising() {
  Bluefruit.Advertising.addFlags(BLE_GAP_ADV_FLAGS_LE_ONLY_GENERAL_DISC_MODE);
  Bluefruit.Advertising.addTxPower();
  Bluefruit.Advertising.addService(imuService);
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

  // Must be set before Bluefruit.begin(). Default ATT MTU is 23, which leaves
  // only 20 bytes for notification payloads — our 24-byte payload gets
  // truncated. BANDWIDTH_MAX bumps the peripheral MTU to 247 so notifications
  // can carry the full 24 bytes once the central negotiates upward.
  Bluefruit.configPrphBandwidth(BANDWIDTH_MAX);

  if (!Bluefruit.begin()) {
    halt("Bluefruit init failed");
  }
  Bluefruit.setName("Reelys-L");
  Bluefruit.setTxPower(4);  // dBm

  imuService.begin();

  imuChar.setProperties(CHR_PROPS_NOTIFY);
  imuChar.setPermission(SECMODE_OPEN, SECMODE_NO_ACCESS);
  imuChar.setFixedLen(24);  // 6 floats
  imuChar.begin();

  startAdvertising();

  Serial.println("# Reelys / imu_ble");
  Serial.println("# Streaming IMU over BLE + USB serial");
  Serial.println("# Device name: Reelys-L");
  Serial.println("# Sample rate: ~50 Hz");
  Serial.println("# Units: accel in g, gyro in deg/s");
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

  if (Bluefruit.connected()) {
    imuChar.notify(data, sizeof(data));
  }

  Serial.print(t);
  for (int i = 0; i < 6; i++) {
    Serial.print(',');
    Serial.print(data[i], 4);
  }
  Serial.println();

  unsigned long elapsed = millis() - t;
  if (elapsed < SAMPLE_PERIOD_MS) {
    delay(SAMPLE_PERIOD_MS - elapsed);
  }
}
