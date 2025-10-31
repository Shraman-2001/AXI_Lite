# AXI Lite Verilog Implementation

This repository provides a Verilog implementation of the AXI4-Lite protocol, a lightweight subset of the AMBA AXI4 interface targeted for simple memory-mapped communication in FPGA and ASIC designs.

## Features

- Compliant with AXI4-Lite protocol specification
- Separate read and write channels with VALID/READY handshaking
- Modular Verilog code for easy integration
- Includes example testbenches for simulation and verification
- Supports typical AXI Lite operations including single transaction read and write

## About AXI4-Lite

AXI4-Lite is designed for low-throughput control register access and status monitoring interfaces. It uses a simplified handshake mechanism allowing easy connectivity between processors and peripheral modules. It consists of five channels: Write Address, Write Data, Write Response, Read Address, and Read Data, each with independent handshaking signals.

## Usage

To use this AXI Lite implementation in your design:

1. Clone this repository.
2. Import the Verilog source files from the `/src` directory.
3. Include corresponding testbenches from `/tb` for simulation.
4. Integrate the AXI Lite master or slave modules into your FPGA or ASIC design.
5. Simulate or synthesize using tools such as Xilinx Vivado, ModelSim, or Synopsys.

## How It Works

The AXI Lite slave module receives address and data from the master with VALID/READY handshaking. It acknowledges transactions by asserting READY, latches data internally, and sends appropriate write responses. Read transactions are handled similarly through separate channels.

## Example

A typical write transaction sequence involves:

- Master asserts `AWVALID` and `WVALID` with address and data respectively.
- Slave asserts `AWREADY` and `WREADY` when ready to accept.
- Upon handshake completion, the slave processes data and generates a write response.

The provided testbenches demonstrate this flow in detail.
