module instruction_memory (
    input  logic [31:0] read_address,
    output logic [31:0] read_data
);
    logic [31:0] instr_mem [63:0];  // 32-word instruction memory
    parameter logic [31:0] start_address = 32'h00000000;


     initial begin
	//00000000 <_start>:
		instr_mem[0] = 32'h00100713;  //addi x14 x0 1
        instr_mem[1] = 32'h00100593;  //addi x11 x0 1
		
    //00000008 <loop_outermost>:
		instr_mem[2] = 32'h3e800513;  //addi x10 x0 1000
		instr_mem[3] = 32'h3e800613;  //addi x12 x0 1000
		
	//00000010 <loop_inner>:
		instr_mem[4] = 32'hfff60613;  //addi x12 x12 -1  
		instr_mem[5] = 32'h00060463;  //beq x12 x0 8 <end_inner>
		instr_mem[6] = 32'hff9ff06f;  //jal x0 -8 <loop_inner>
                                      
	//0000001c <end_inner>:
		instr_mem[7] = 32'h3e800613;  //addi x10 x10 -1
		instr_mem[8] = 32'hfff50513;  //addi x10 x10 -1
		instr_mem[9] = 32'h00050463;  //beq x10 x0 8 <end_outer>
		instr_mem[10] = 32'hfedff06f; //jal x0 -20 <loop_inner>
                                      
	//00000028 <end_outer>:           
		instr_mem[11] = 32'h3e800513; //addi x14 x14 -1
		instr_mem[12] = 32'hfff70713; //addi x14 x14 -1
		instr_mem[13] = 32'h00070463; //beq x14 x0 8 <toggle>
		instr_mem[14] = 32'hfd9ff06f; //jal x0 -40 <loop_outermost>
                                      
	//00000034 <toggle>:              
		instr_mem[15] = 32'hfff58593; //addi x11 x11 -1
		instr_mem[16] = 32'h00100713; //addi x14 x0 1
		
	// repeat	
		instr_mem[17] = 32'h3e800513; //addi x10 x0 1000
		instr_mem[18] = 32'h3e800613; //addi x12 x0 1000
									
	//00000044 <loop_inner2>:         
		instr_mem[19] = 32'hfff60613; //addi x12 x12 -1
		instr_mem[20] = 32'h00060463; //beq x12 x0 8 <end_inner2>
		instr_mem[21] = 32'hff9ff06f; //jal x0 -8 <loop_inner2>
									
	//00000050 <end_inner2>:          
		instr_mem[22] = 32'h3e800613; //addi x10 x10 -1
		instr_mem[23] = 32'hfff50513; //addi x10 x10 -1
		instr_mem[24] = 32'h00050463; //beq x10 x0 8 <end_outer2>
		instr_mem[25] = 32'hfe9ff06f; //jal x0 -20 <loop_inner2>
									
	//0000005c <end_outer2>:          
		instr_mem[26] = 32'h3e800513; //addi x14 x14 -1
		instr_mem[27] = 32'hfff70713; //addi x14 x14 -1
		instr_mem[28] = 32'hf80708e3; //beq x14 x0 -96 <_start>
		instr_mem[29] = 32'hfd1ff06f; //jal x0 -32 <loop_inner2>
	end
	
    always_comb begin
        read_data = instr_mem[read_address[31: 2]]; //word aligned
    end
endmodule
