# Toolchain prefix
RISCV_PREFIX = riscv64-unknown-elf-

AS = $(RISCV_PREFIX)as
LD = $(RISCV_PREFIX)ld
OBJDUMP = $(RISCV_PREFIX)objdump

# Files
ASM = program.s
OBJ = program.o
ELF = program.elf
DISASM = program.disasm

.PHONY: all clean

all: $(ELF) $(DISASM)

$(OBJ): $(ASM)
	$(AS) -o $@ $<

$(ELF): $(OBJ)
	$(LD) -o $@ $<

$(DISASM): $(OBJ)
	$(OBJDUMP) -d $< > $@

clean:
	del /Q $(OBJ) $(ELF) $(DISASM)  # For Windows cmd
