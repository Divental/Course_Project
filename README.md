# CRC16 Checksum Calculator in Assembly (EMU8086)

This project implements a CRC16 checksum calculator written entirely in Assembly language for the EMU8086 emulator. The goal of this project is to demonstrate low-level bitwise operations and checksum calculation mechanisms as part of a course project.

## Description

The program performs a CRC16 (Cyclic Redundancy Check) calculation on a given block of data using 16-bit register logic and bitwise manipulation. The result is presented as a two-byte checksum, which can be used to verify data integrity in embedded or communication systems.

## Features

* Written in pure Assembly for EMU8086
* Processes byte-by-byte input for CRC calculation
* Produces a 16-bit checksum (CRC16 standard)
* Stores result in two variables: crc_h (high byte) and crc_l (low byte)
* Displays checksum on screen in hexadecimal format (e.g., 1234)

## Purpose

This project was developed as part of a course assignment to explore:

* Bitwise operations in Assembly
* Data integrity checking via CRC
* Manual memory/register handling
* Low-level understanding of how checksums work

## Requirements

* EMU8086 emulator (or compatible Intel 8086 environment)

## CRC16 Algorithm Reference

This implementation is based on the standard CRC16 algorithm, using polynomial 0x0A001 (or equivalent), and is commonly used in:

* Serial communication (Modbus)
* File transfer protocols
* Embedded system firmware
  
## License
This project is licensed under the Apache License Version 2.0. See LICENSE for details.

## Contact
For questions, contact yuriibalandyuk@gmail.com or open an issue in the repository.

