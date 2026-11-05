![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

# CRC32

This is a CRC32 project made in verilog

## Usage

Feed your input into the data pin, LSB first, starting on the first clock edge after reset is inactive. \
When youve fed the entire input, set done high and read your output from the first clock edge after done, LSB first. \
Both input and output is done serially, at one bit per clock.

## Testing

The project can be tested by compiling and simulating the
```
src/project.v
test/tb_standalone.v
```
files. If the simulation prints "PASS", then the correct CRC32 checksum was output. \
If instead the simulation prints "FAIL", then that was not the case.

## About

### General

This CRC32 implementation was made using verilog, using the TinyTapeout project template. \
You can view a render of the generated chip layout [here](https://hyphen-hyphen-hyphen-hyphen.github.io/crc32/)

### What is verilog?

[Verilog](https://verilog.com/) is an HDL. \ HDL stands for hardware description language, and they are used for describing electronic circuits.

### What is CRC32?

CRC stands for cyclic redundancy check, and it generates a checksum for detecting errors in data transmission. \
The 32 means the calculated checksum is 32 bits. \
Its used in stuff like ZIP, Ethernet and PNG.
