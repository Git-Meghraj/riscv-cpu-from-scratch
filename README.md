# riscv-core-systemverilog
A clean, from-scratch implementation of a basic RISC-V CPU core using SystemVerilog for FPGA prototyping.
This repository supports a basic subset of the RV32I instruction set, including at least one instruction from each major instruction type (R, I, S, B, U, J).

The project includes a simple LED blink demo using memory-mapped I/O on the PYNQ-Z2 FPGA board, showcasing how custom CPUs can interact with hardware peripherals.

🔧 Key Features:

Basic RISC-V instruction support (subset of RV32I)

Modular and synthesizable SystemVerilog design

LED blink demo via memory-mapped I/O (PYNQ-Z2 board)

Includes testbenches for verification

Great for learning, simulation, and FPGA prototyping

📌 Coming Soon:
A pipelined version of the processor is currently under development and will be released in the future.
