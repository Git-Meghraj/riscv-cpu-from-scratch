# RISC-V CPU from Scratch

A clean, from-scratch implementation of a basic RISC-V CPU core using SystemVerilog for FPGA prototyping.  
This repository supports a basic subset of the **RV32I** instruction set, including at least one instruction from each major instruction type (R, I, S, B, U, J).

The project includes a simple LED blink demo using memory-mapped I/O on the **PYNQ-Z2 FPGA** board, showcasing how custom CPUs can interact with hardware peripherals.

---

🔧 **Key Features**

- ✅ Basic RISC-V instruction support (subset of RV32I)
- ✅ Modular and synthesizable SystemVerilog design
- ✅ LED blink demo via memory-mapped I/O (PYNQ-Z2 board)
- ✅ Includes testbenches for simulation and debugging
- ✅ Great for learning, experimentation, and FPGA prototyping

---

🚀 **Now Live: 5-Stage Pipelined Version**

The wait is over! In addition to the single-cycle core, this repository now includes a **five-stage pipelined RISC-V CPU** featuring:

- ✅ Classic 5-stage pipeline (IF, ID, EX, MEM, WB)
- ✅ Hazard detection and forwarding units
- ✅ Flush and stall logic for control and data hazards
- ✅ Improved throughput and reduced CPI
- ✅ Runs the same LED blink demo with enhanced performance

The pipelined version has been verified in simulation using a toggle test: a register connected to an LED toggles using an assembly program. The assembly was compiled using **RISC-V GCC**, then translated into hex and loaded into instruction memory.

---

📁 **Repository Structure**

/Single-Cycle-Core/ # Single-cycle CPU core and testbench
/Five-Staged-Pipelined-Core/ # New pipelined core with hazard logic
/common/ # Shared components and instruction formats
README.md

---

📌 **License & Contribution**

These cores are **open-source and free to use**. Experiment, adapt, and learn!  
For questions or contributions, feel free to connect or raise issues.
