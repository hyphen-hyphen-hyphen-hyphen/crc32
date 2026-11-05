# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, FallingEdge


@cocotb.test()
async def test_project(dut):
	dut._log.info("Start")

	clock = Clock(dut.clk, 20, unit="ns")
	cocotb.start_soon(clock.start())

	dut._log.info("Reset")
	dut.ena.value = 1
	dut.ui_in.value = 0
	dut.uio_in.value = 0
	dut.rst_n.value = 0
	await ClockCycles(dut.clk, 10)
	await FallingEdge(dut.clk)
	dut.rst_n.value = 1

	dut._log.info("Test project behavior")

	bits = []
	for byte in b"123456789":
		for i in range(8):
			bits.append((byte >> i) & 1)
	assert len(bits) == 72
    done = 1


	out = 0
	for n in range(32):
		await FallingEdge(dut.clk)
		out |= int(dut.uo_out.value[0]) << n

	dut._log.info(f"CRC = {out:08X}")
	assert out == 0xCBF43926, f"CRC mismatch: {out:08X}"
