module instruction_memory (
    input  logic [31:0] read_address,
    output logic [31:0] read_data
);
    logic [31:0] instr_mem [0:31];  // 32-word instruction memory
    parameter logic [31:0] start_address = 32'h00001000;

    initial begin
        instr_mem[0] = 32'h6A000513;  //addi x10, x0, 100000    // delay counter
        instr_mem[1] = 32'h00100593;  //addi x11, x0, 1         // initial LED value = 1
		instr_mem[2] = 32'h0000406F;  //jal  x0, -8             // loop: jump back to delay line
		//instr_mem[2] = 32'hFE3F806F;  //jal  x0, -8             // loop: jump back to delay line
        //instr_mem[2] = 32'hFFF00613;  //addi x12, x0, -1        // decrement constant
        instr_mem[3] = 32'h6A000693;  //addi x13, x0, 100000    // reload delay

        instr_mem[4] = 32'hFFF50513;  //addi x10, x10, -1       // delay loop start
        instr_mem[5] = 32'h10050463;  //beq  x10, x0, +8        // if delay over, skip jump
        instr_mem[6] = 32'hFE3F81BF;  //jal  x0, -8             // loop: jump back to delay line

        instr_mem[7] = 32'hFFF58593;  //addi x11, x11, -1       // toggle x11 (1→0)
        instr_mem[8] = 32'h10058463;  //beq  x11, x0, +8        // if x11==0, skip next
        instr_mem[9] = 32'h00100593;  //addi x11, x0, 1         // else x11 = 1
 
        instr_mem[10] = 32'h00068513;  //addi x10, x13, 0        // reload delay counter
        instr_mem[11] = 32'hFFFDC06F;  //jal  x0, -36            // jump to delay loop
    end


    always_comb begin
        read_data = instr_mem[(read_address - start_address) >> 2];
    end
endmodule
