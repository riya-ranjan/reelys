#!/usr/bin/env python3
"""Reelys — BLE listener.

Connects to the Reelys-L BLE peripheral (firmware: test_sketches/imu_ble),
subscribes to the IMU notify characteristic, and prints CSV samples to stdout
in the same format the sketch dumps to USB serial:

    timestamp_ms,ax,ay,az,gx,gy,gz

where timestamp_ms is the host's monotonic clock at the moment the packet was
received, accel is in g, and gyro is in deg/s.

BLE protocol (must match the firmware):
    Device name:        Reelys-L
    Service UUID:       9e6647db-3eec-42b6-8349-a95113e65082
    Char   UUID:        ae7799da-9123-45d5-84f9-20b5c3f7f6f4
    Payload:            24 bytes = 6 little-endian IEEE 754 floats in order
                        ax, ay, az, gx, gy, gz

Usage (from repo root):
    pip install -r requirements.txt
    python tools/ble_listener.py                 # auto-scan for "Reelys-L"
    python tools/ble_listener.py --name Reelys-R # scan for a different name
    python tools/ble_listener.py --address AA:BB:CC:DD:EE:FF
"""

import argparse
import asyncio
import struct
import sys
import time

from bleak import BleakClient, BleakScanner

DEFAULT_NAME = "Reelys-L"
IMU_CHAR_UUID = "ae7799da-9123-45d5-84f9-20b5c3f7f6f4"
PAYLOAD_STRUCT = struct.Struct("<6f")  # 6 little-endian floats, 24 bytes
SCAN_TIMEOUT_S = 10.0


def on_sample(_sender, data: bytearray) -> None:
    if len(data) != PAYLOAD_STRUCT.size:
        print(
            f"# WARN unexpected payload size: {len(data)} bytes",
            file=sys.stderr,
        )
        return
    ax, ay, az, gx, gy, gz = PAYLOAD_STRUCT.unpack(data)
    t_ms = int(time.monotonic() * 1000)
    print(f"{t_ms},{ax:.4f},{ay:.4f},{az:.4f},{gx:.4f},{gy:.4f},{gz:.4f}")


async def find_address(name: str) -> str:
    print(f"# scanning for '{name}' (up to {SCAN_TIMEOUT_S:.0f}s)…", file=sys.stderr)
    device = await BleakScanner.find_device_by_name(name, timeout=SCAN_TIMEOUT_S)
    if device is None:
        raise SystemExit(f"# error: device '{name}' not found")
    return device.address


async def run(address: str) -> None:
    print(f"# connecting to {address}", file=sys.stderr)
    async with BleakClient(address) as client:
        print("# connected; subscribing to IMU characteristic", file=sys.stderr)
        await client.start_notify(IMU_CHAR_UUID, on_sample)
        print("timestamp_ms,ax,ay,az,gx,gy,gz")
        try:
            while client.is_connected:
                await asyncio.sleep(1.0)
        finally:
            await client.stop_notify(IMU_CHAR_UUID)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__.split("\n", 1)[0])
    target = parser.add_mutually_exclusive_group()
    target.add_argument(
        "--name",
        default=DEFAULT_NAME,
        help=f"BLE local name to scan for (default: {DEFAULT_NAME})",
    )
    target.add_argument(
        "--address",
        help="BLE MAC address to connect to directly, skipping scan",
    )
    args = parser.parse_args()

    try:
        address = args.address or asyncio.run(find_address(args.name))
        asyncio.run(run(address))
    except KeyboardInterrupt:
        print("\n# interrupted", file=sys.stderr)


if __name__ == "__main__":
    main()
