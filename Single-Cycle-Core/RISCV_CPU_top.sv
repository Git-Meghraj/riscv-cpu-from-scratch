module RISCV_CPU_top(	input logic clk,
						input logic rst,
						);
//program_counter signals
logic [31:0] pc_muxed_nxt_addr;
logic [31:0] pc_curr_addr;
logic pc_sel;

//instruction_memory signals
logic [31:0] i_mem_rd_data;

//register_file signals
//addr_rd_port1 i.e rs1 bits = 19:15 of i_mem_rd_data
//addr_rd_port2 i.e rs2 bits = 24:20 of i_mem_rd_data
//addr_wr i.e rd bits = 11:7 of i_mem_rd_data
logic [4:0] rf_rs1;
logic [4:0] rf_rs2;
logic [4:0] rf_rd;
assign rf_rs1 = i_mem_rd_data[19:15]; //provides address for readport1 of register_file.
assign rf_rs2 = i_mem_rd_data[24:20]; //provides address for readport2 of register_file.
assign rf_rd = i_mem_rd_data[11:7] //provides address writeport of register_file

//sign_extender signals
logic[31:0] se_extended_imm;
logic se_imm_sel;


//ALU signals
logic[31:0] alu1_result;
logic alu1_src_sel;
logic[31:0] alu1_operandA;
logic[31:0] alu1_operandB;

assign alu1_operandA = rf_read_data;

//data_memory signals
logic[31:0] dm_read_data;
logic result_sel;
logic[31:0] write_back_sig;


program_counter pc(next_addr(pc_muxed_nxt_addr),curr_addr(pc_curr_addr),clk(clk),rst(rst));

instruction_memory i_mem(read_address(pc_curr_addr), read_data(i_mem_rd_data));

sign_extender se(input_value(i_mem_rd_data),sign_extended_value(se_extended_imm),imm_sel(se_imm_sel));

register_file rf(	clk(clk),
					rst(rst),
					wr_rd_en(),
					write_port(write_back_sig), //write back from the data_memory 
					addr_wr(),
					addr_rd_port1(rf_rs1),
					addr_rd_port2(rf_rs2),
					read_port_1(rf_read_data),
					read_port_2(rf_read_data2)
					);

ALU alu1(inp_A(alu1_operandA), inp_B(alu1_operandB), sel(), result(alu1_result));

data_memory dm(clk(clk),rst(rst),wr_rd_en(),write_data(rf_read_data2),addr(alu1_result),read_data(dm_read_data));


//multiplexing blocks
always_comb begin
		if(pc_sel)
			pc_muxed_nxt_addr = pc_curr_addr + se_extended_imm;
		else
			pc_muxed_nxt_addr = pc_curr_addr + 32'h00000004;
end

//alu
always_comb begin
		if(alu1_src_sel)
			alu1_operandB = se_extended_imm;
		else
			alu1_operandB = rf_read_data2;	
end

//result
always_comb begin
		if(result_sel)
			write_back_sig = dm_read_data;
		else
			write_back_sig = alu1_result;	
end