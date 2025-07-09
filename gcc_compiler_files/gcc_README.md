# GCC RISC-V Assembly Build Files

This repository contains assembly source files and a Makefile for building RISC-V programs using the `riscv64-unknown-elf-gcc` toolchain.

---

## Overview

- The assembly code is written in `.s` files.
- The Makefile assembles, links, and disassembles the program using the RISC-V GNU toolchain.
- Target architecture: RV32I (`-march=rv32i`), ABI: ILP32 (`-mabi=ilp32`).

---

## Prerequisites

- Install the RISC-V GNU toolchain (`riscv64-unknown-elf-*` tools).
- Available on Linux, Windows, and macOS.
- Ensure `riscv64-unknown-elf-as`, `riscv64-unknown-elf-ld`, and `riscv64-unknown-elf-objdump` are in your system PATH.

---

## Build Instructions

1. Clone this repository:
   ```bash
   git clone <repo-url>
   cd gcc_compiler_files

2. If you use windows, alternatively you can run the commands manually in your Command Prompt or PowerShell (one by one):
riscv64-unknown-elf-as -o program.o program.s
riscv64-unknown-elf-ld -o program.elf program.o
riscv64-unknown-elf-objdump -d program.o > program.disasm


