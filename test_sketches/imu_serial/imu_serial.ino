// Reelys — imu_serial
// Read the onboard LSM6DS3TR-C IMU on the Seeed XIAO nRF52840 Sense
// at ~50 Hz and stream CSV samples over USB serial.
//
// Build / upload:
//   Board:    Tools → Board → Seeed nRF52 Boards → "Seeed XIAO nRF52840 Sense"
//             (the Sense variant — the non-Sense board has no IMU)
//   Library:  "Seeed Arduino LSM6DS3" via Library Manager
//   Port:     Tools → Port → the XIAO's port (double-tap reset to enter the
//             UF2 bootloader if it doesn't show up)
//   Upload:   click Upload (→) in the IDE
//
// Observe:
//   Tools → Serial Monitor, baud 115200.
//
// Output format (one line per sample):
//   timestamp_ms,ax,ay,az,gx,gy,gz
//   accel in g, gyro in deg/s

#include "LSM6DS3.h"
#include "Wire.h"

// I2C address of the LSM6DS3TR-C as wired on the XIAO nRF52840 Sense.
static LSM6DS3 imu(I2C_MODE, 0x6A);

static const unsigned long SAMPLE_PERIOD_MS = 20;  // ~50 Hz

static void halt(const char* reason) {
  for (;;) {
    Serial.print("[FATAL] ");
    Serial.println(reason);
    delay(1000);
  }
}

void setup() {
  Serial.begin(115200);

  // Give a USB host up to ~2s to attach, but don't block forever:
  // the board must still run when not tethered.
  unsigned long t0 = millis();
  while (!Serial && (millis() - t0) < 2000) {
    delay(10);
  }

  if (imu.begin() != 0) {
    halt("LSM6DS3 init failed");
  }

  Serial.println("# Reelys / Heelys Sonic");
  Serial.println("# Phase 1: IMU -> USB serial");
  Serial.println("# Sample rate: ~50 Hz");
  Serial.println("# Units: accel in g, gyro in deg/s");
  Serial.println("timestamIp_ms,ax,ay,az,gx,gy,gz");
}

void loop() {
  unsigned long t = millis();

  float ax = imu.readFloatAccelX();
  float ay = imu.readFloatAccelY();
  float az = imu.readFloatAccelZ();
  float gx = imu.readFloatGyroX();
  float gy = imu.readFloatGyroY();
  float gz = imu.readFloatGyroZ();

  Serial.print(t);
  Serial.print(',');
  Serial.print(ax, 4);
  Serial.print(',');
  Serial.print(ay, 4);
  Serial.print(',');
  Serial.print(az, 4);
  Serial.print(',');
  Serial.print(gx, 4);
  Serial.print(',');
  Serial.print(gy, 4);
  Serial.print(',');
  Serial.println(gz, 4);

  unsigned long elapsed = millis() - t;
  if (elapsed < SAMPLE_PERIOD_MS) {
    delay(SAMPLE_PERIOD_MS - elapsed);
  }
}
