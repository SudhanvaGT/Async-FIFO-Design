# Asynchronous FIFO Design using Verilog and Xilinx Vivado

## Project Overview

This project implements an **Asynchronous FIFO (First-In-First-Out)** for reliable data transfer between two independent clock domains.

The design was developed using **Verilog HDL** and implemented and analyzed using **Xilinx Vivado**.

**RTL Design → CDC → Functional Verification → Synthesis → Implementation → Timing Analysis → Power Analysis**

## FIFO Specifications

| Parameter | Value |
|---|---|
| Data Width | 8 bits |
| FIFO Depth | 16 entries |
| Write Clock | 100 MHz |
| Read Clock | 80 MHz |
| Write Clock Period | 10 ns |
| Read Clock Period | 12.5 ns |
| Reset | Asynchronous |
| BRAM Used | 0 |

## Architecture

The FIFO contains:

- FIFO Memory
- Write Pointer
- Read Pointer
- Gray-Code Conversion
- Write-to-Read Clock Synchronizer
- Read-to-Write Clock Synchronizer
- Empty Detection Logic
- Full Detection Logic

### Clock Domain Crossing

The write and read sides operate on independent clocks.

Pointer transfer follows:

**Binary Pointer → Gray-Code Pointer → 2-Stage Synchronizer → Destination Clock Domain**

Gray coding is used because only one bit changes between consecutive pointer values, reducing the possibility of inconsistent multi-bit pointer sampling during clock-domain crossing.

## Project Structure

```text
Async-FIFO-Design
│
├── rtl
│   ├── async_fifo.v
│   ├── fifo_memory.v
│   ├── write_pointer.v
│   ├── read_pointer.v
│   ├── synchronizer.v
│   ├── empty_logic.v
│   └── full_logic.v
│
├── simulation
│   └── async_fifo_tb.v
│
├── constraints
│   └── <XDC constraint file>
│
├── results
│   ├── simulation.png
│   ├── utilization.png
│   ├── timing.png
│   └── power.png
│
└── README.md
```

## RTL Modules

- **`async_fifo.v`** — Top-level FIFO module.
- **`fifo_memory.v`** — FIFO storage memory.
- **`write_pointer.v`** — Write pointer and Gray-code generation.
- **`read_pointer.v`** — Read pointer and Gray-code generation.
- **`synchronizer.v`** — Two-stage pointer synchronization.
- **`empty_logic.v`** — FIFO empty detection.
- **`full_logic.v`** — FIFO full detection.

## Functional Verification

The FIFO was verified using a dedicated Verilog testbench.

- **Total Tests:** 25
- **Passed:** 25
- **Failed:** 0

```text
========================================
FINAL TEST RESULT
========================================
PASS COUNT = 25
FAIL COUNT = 0

****************************************
ALL TESTS PASSED!
ASYNC FIFO VERIFIED
****************************************
```

![Simulation Result](results/simulation.png)

## FPGA Resource Utilization

| Resource | Utilization |
|---|---:|
| Slice LUTs | 26 |
| Slice Registers | 58 |
| Slices | 18 |
| LUT as Logic | 18 |
| LUT as Memory | 8 |
| BRAM | 0 |
| BUFGCTRL | 2 |
| Bonded IOB | 23 |

![Resource Utilization](results/utilization.png)

## Timing Analysis

| Timing Parameter | Result |
|---|---:|
| Write Clock | 100 MHz |
| Read Clock | 80 MHz |
| WNS | +6.611 ns |
| TNS | 0.000 ns |
| WHS | +0.166 ns |
| THS | 0.000 ns |
| Failing Endpoints | 0 |

The implemented design satisfied the specified timing constraints with no reported setup or hold timing violations.

![Timing Analysis](results/timing.png)

## Power Analysis

Power was analyzed using both vectorless estimation and simulation-derived switching activity.

### Vectorless Estimate

- Total On-Chip Power: **73 mW**
- Dynamic Power: **3 mW**
- Device Static Power: **70 mW**
- Confidence: Low

### SAIF-Based Estimate

Simulation activity was captured using a **SAIF file** and used for power estimation.

- Total On-Chip Power: **71 mW**
- Dynamic Power: approximately **1 mW**
- Device Static Power: **70 mW**
- Confidence: Medium

The SAIF-based analysis provides a power estimate based on the switching activity observed during functional simulation.

![Power Analysis](results/power.png)

## Complete Design Flow

```text
Verilog RTL
     ↓
Functional Simulation
     ↓
CDC Architecture
     ↓
Synthesis
     ↓
Implementation
     ↓
Resource Utilization
     ↓
Timing Analysis
     ↓
Power Analysis
     ↓
Final FPGA Design
```

## Key Results

### Functional Verification
- ✅ 25/25 tests passed
- ✅ 0 functional failures

### Implementation
- ✅ 26 LUTs
- ✅ 58 Registers
- ✅ 18 Slices
- ✅ 0 BRAM

### Timing
- ✅ WNS = +6.611 ns
- ✅ WHS = +0.166 ns
- ✅ 0 timing violations

### Power
- ✅ Total Power = 71 mW
- ✅ Dynamic Power ≈ 1 mW
- ✅ SAIF-based activity analysis

## Tools Used

- **Verilog HDL**
- **Xilinx Vivado**
- **Vivado XSim**
- **FPGA Synthesis**
- **FPGA Implementation**
- **SAIF-based Power Analysis**

## Key Concepts Demonstrated

- Asynchronous FIFO
- Clock Domain Crossing (CDC)
- Gray-Code Counters
- Pointer Synchronization
- Metastability Reduction
- Dual-clock FIFO Memory
- FIFO Full/Empty Detection
- RTL Simulation
- FPGA Synthesis
- FPGA Implementation
- Static Timing Analysis
- Power Estimation

## Future Improvements

- Parameterized FIFO depth and width
- More extensive randomized verification
- SystemVerilog assertions
- Formal verification
- Production-grade full/empty flag generation
- FPGA block RAM implementation for larger FIFO depths
- Dedicated CDC verification

## Project Status

**Completed ✅**

The asynchronous FIFO was successfully designed, simulated, synthesized, implemented, and analyzed using Xilinx Vivado.

## Author

**Sudhanva Thite**

3rd Year Electronics and Communication Engineering

Interested in VLSI, RTL Design, FPGA, and Semiconductor Design

## Keywords

`VLSI` `Verilog` `RTL Design` `FPGA` `Vivado` `Asynchronous FIFO` `CDC` `Clock Domain Crossing` `Gray Code` `Digital Design` `Synthesis` `Timing Analysis` `Power Analysis`
