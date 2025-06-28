module RISCV_CPU_top(	input logic clk_125mhz,
                        output logic led
		    );
logic clk;
logic rst= 1'b0;						
logic [3:0]reset_counter = 4'd0;	
//program_counter signals
logic [31:0] pc_muxed_nxt_addr= 32'd0;
logic [31:0] pc_curr_addr;
logic pc_sel;
logic [31:0] pc_plus4;
//instruction_memory signals
logic [31:0] i_mem_rd_data ;

//register_file signals

logic [4:0] rf_rs1;
logic [4:0] rf_rs2;
logic [4:0] rf_rd;
logic rf_reg_file_wr_rd_sel;
logic [31:0] rf_read_data ;
logic [31:0] rf_read_data2;

//sign_extender signals
logic [31:0] se_extended_imm;
logic [1:0]se_imm_sel;

//ALU signals
logic[31:0] alu1_result;
logic alu1_src_sel;
logic zero_flag;
logic[2:0] alu1_op_sel;
logic[31:0] alu1_operandA;
logic[31:0] alu1_operandB;

//data_memory signals
logic[31:0] dm_read_data = 32'd0;
logic [1:0] dm_result_sel;
logic[31:0] write_back_sig;
logic dm_data_mem_wr_rd_sel;

//dcu signals
logic branch;
logic jump;

//harzard unit signals
logic [1:0]alu1_operandB_forward_sel;
logic [1:0]alu1_operandA_forward_sel;
logic [4:0] rf_rs1_reg;
logic [4:0] rf_rs2_reg;

//pipelining signals
logic [31:0] i_mem_rd_data_reg ;
logic [31:0] rf_read_data_reg;
logic [31:0] rf_read_data2_reg;
logic [31:0] rf_read_data2_reg_2;
logic [31:0] se_extended_imm_reg;
logic [31:0] pc_curr_addr_reg;
logic [31:0] pc_curr_addr_reg_2;
logic [4:0] rf_rd_reg;
logic [4:0] rf_rd_reg_2;
logic [4:0] rf_rd_reg_3;
logic rf_reg_file_wr_rd_sel_reg;
logic rf_reg_file_wr_rd_sel_reg_2;
logic rf_reg_file_wr_rd_sel_reg_3;
logic [1:0] dm_result_sel_reg = 2'b00;
logic [1:0] dm_result_sel_reg_2;
logic [1:0] dm_result_sel_reg_3;
logic dm_data_mem_wr_rd_sel_reg;
logic dm_data_mem_wr_rd_sel_reg_2;
logic jump_reg = 0;
logic branch_reg = 0;
logic alu1_src_sel_reg;
logic[2:0] alu1_op_sel_reg;
logic [31:0] pc_plus4_reg;
logic [31:0] pc_plus4_reg_2;
logic [31:0] pc_plus4_reg_3;
logic [31:0] pc_plus4_reg_4;
logic stall_decode_stg;
logic stall_fetch_stg;
logic flush_decode_stg;
logic flush_execute_stg;
logic[31:0] alu1_result_reg;
logic[31:0] alu1_result_reg_2;
logic[31:0] dm_read_data_reg;
logic[31:0] forward_alu1_operandB_reg;
logic[31:0] forward_alu1_operandB;

assign clk = clk_125mhz;

program_counter pc(.next_addr(pc_muxed_nxt_addr),.curr_addr(pc_curr_addr),.clk(clk),.rst(rst),.stall_fetch_stg(stall_fetch_stg));

//addr_rd_port1 i.e rs1 bits = 19:15 of i_mem_rd_data
//addr_rd_port2 i.e rs2 bits = 24:20 of i_mem_rd_data
//addr_wr i.e rd bits = 11:7 of i_mem_rd_data
assign rf_rs1 = (rst == 1'b0) ? 5'd0 : i_mem_rd_data_reg[19:15];//provides address for readport1 of register_file.
assign rf_rs2 = (rst == 1'b0) ? 5'd0 : i_mem_rd_data_reg[24:20];//provides address for readport2 of register_file.
assign rf_rd  = (rst == 1'b0) ? 5'd0 : i_mem_rd_data_reg[11:7]; //provides address writeport of register_file


instruction_memory i_mem(.read_address(pc_curr_addr), .read_data(i_mem_rd_data));
//pipeline registering for decode
always_ff @(posedge clk) begin
	if (rst == 1'b0) begin
		i_mem_rd_data_reg 	<= 32'd0;
		pc_curr_addr_reg 	<= 32'd0;
		pc_plus4_reg 		<= 32'd0;
	end
	else if (flush_decode_stg == 1'b1) begin
		i_mem_rd_data_reg 	<= 32'd0;
		pc_curr_addr_reg 	<= 32'd0;
		pc_plus4_reg 		<= 32'd0;
	end
	else if (stall_decode_stg != 1) begin
		i_mem_rd_data_reg 	<= i_mem_rd_data;
		pc_curr_addr_reg 	<= pc_curr_addr;
		pc_plus4_reg 		<= pc_plus4;
	end
end


sign_extender se(.input_value(i_mem_rd_data_reg),.sign_extended_value(se_extended_imm),.imm_sel(se_imm_sel));

register_file rf(	.clk(clk),
					.wr_rd_en(rf_reg_file_wr_rd_sel_reg_3),
					.write_port(write_back_sig), 
					.addr_wr(rf_rd_reg_3),
					.addr_rd_port1(rf_rs1),
					.addr_rd_port2(rf_rs2),
					.read_port_1(rf_read_data),
					.read_port_2(rf_read_data2),
					.led(led)
					);
					
decode_and_control_unit dcu(.clk(clk),.input_instruction(i_mem_rd_data_reg),.alu_operation_sel(alu1_op_sel),.data_mem_wr_rd_sel(dm_data_mem_wr_rd_sel),
							.alu_B_input_sel(alu1_src_sel),.jump(jump),.branch(branch),.imm_sel_out(se_imm_sel),.reg_file_wr_rd_sel(rf_reg_file_wr_rd_sel),.result_sel(dm_result_sel)) ;

//pipeline registering for execute
always_ff @(posedge clk) begin
	if (rst == 1'b0) begin
		rf_read_data_reg 			<= 32'd0;
		rf_read_data2_reg 			<= 32'd0;
		se_extended_imm_reg 		<= 32'd0;
		pc_curr_addr_reg_2 			<= 32'd0;
		pc_plus4_reg_2 				<= 32'd0;
		rf_rd_reg					<= 5'd0;
		
		// control signals
		rf_reg_file_wr_rd_sel_reg 	<= 1'b0;
		dm_result_sel_reg 			<= 2'b00;
		dm_data_mem_wr_rd_sel_reg 	<= 1'b0;
		jump_reg 					<= 1'b0;
		branch_reg 					<= 1'b0;
		alu1_src_sel_reg			<= 1'b0;
		alu1_op_sel_reg             <= 3'd0;
		
		// hazard unit
		rf_rs1_reg					<= 5'd0;
		rf_rs2_reg				    <= 5'd0;

	end else if (flush_execute_stg == 1'b1) begin
		rf_read_data_reg 			<= 32'd0;
		rf_read_data2_reg 			<= 32'd0;
		se_extended_imm_reg 		<= 32'd0;
		pc_curr_addr_reg_2 			<= 32'd0;
		pc_plus4_reg_2 				<= 32'd0;
		rf_rd_reg					<= 5'd0;

		// control signals
		rf_reg_file_wr_rd_sel_reg 	<= 1'b0;
		dm_result_sel_reg 			<= 2'b00;
		dm_data_mem_wr_rd_sel_reg 	<= 1'b0;
		jump_reg 					<= 1'b0;
		branch_reg 					<= 1'b0;
		alu1_src_sel_reg			<= 1'b0;
		alu1_op_sel_reg             <= 3'd0;

		// hazard unit
		rf_rs1_reg					<= 5'd0;
		rf_rs2_reg				    <= 5'd0;

	end else begin
		rf_read_data_reg 			<= rf_read_data;
		rf_read_data2_reg 			<= rf_read_data2;
		se_extended_imm_reg 		<= se_extended_imm;
		pc_curr_addr_reg_2 			<= pc_curr_addr_reg;
		pc_plus4_reg_2 				<= pc_plus4_reg;
		rf_rd_reg					<= rf_rd;

		// control signals
		rf_reg_file_wr_rd_sel_reg 	<= rf_reg_file_wr_rd_sel;
		dm_result_sel_reg 			<= dm_result_sel;
		dm_data_mem_wr_rd_sel_reg 	<= dm_data_mem_wr_rd_sel;
		jump_reg 					<= jump;
		branch_reg 					<= branch;
		alu1_src_sel_reg			<= alu1_src_sel;
		alu1_op_sel_reg             <= alu1_op_sel;  

		// hazard unit
		rf_rs1_reg					<= rf_rs1;
		rf_rs2_reg				    <= rf_rs2;
	end
end


assign pc_sel = ((zero_flag & branch_reg) | jump_reg == 1'b1) ? 1'b1: 1'b0;
//assign pc_sel = (zero_flag & branch_reg) | jump_reg;

ALU alu1(.inp_A(alu1_operandA), .inp_B(alu1_operandB), .sel(alu1_op_sel_reg), .result(alu1_result),.zero_flag(zero_flag));
//pipeline registering for memory
always_ff @(posedge clk) begin
	if (rst == 1'b0) begin
		alu1_result_reg 				<= 32'd0;
		forward_alu1_operandB_reg 		<= 32'd0;
		pc_plus4_reg_3 					<= 32'd0;
		rf_rd_reg_2						<= 5'd0;

		rf_reg_file_wr_rd_sel_reg_2 	<= 1'b0;
		dm_result_sel_reg_2 			<= 2'b00;
		dm_data_mem_wr_rd_sel_reg_2 	<= 1'b0;
	end else begin
		alu1_result_reg 				<= alu1_result;
		forward_alu1_operandB_reg 		<= forward_alu1_operandB;
		pc_plus4_reg_3 					<= pc_plus4_reg_2;
		rf_rd_reg_2						<= rf_rd_reg;

		rf_reg_file_wr_rd_sel_reg_2 	<= rf_reg_file_wr_rd_sel_reg;
		dm_result_sel_reg_2 			<= dm_result_sel_reg;
		dm_data_mem_wr_rd_sel_reg_2 	<= dm_data_mem_wr_rd_sel_reg;
	end
end


data_memory dm(.clk(clk),.rst(rst),.wr_rd_en(dm_data_mem_wr_rd_sel_reg_2),.write_data(forward_alu1_operandB_reg)
				,.addr(alu1_result_reg),.read_data(dm_read_data));
//pipeline registering for writeback
always_ff @(posedge clk) begin
	if (rst == 1'b0) begin
		alu1_result_reg_2 				<= 32'd0;
		dm_read_data_reg 				<= 32'd0;
		pc_plus4_reg_4 					<= 32'd0;
		rf_rd_reg_3						<= 5'd0;

		rf_reg_file_wr_rd_sel_reg_3 	<= 1'b0;
		dm_result_sel_reg_3 			<= 2'b00;
	end else begin
		alu1_result_reg_2 				<= alu1_result_reg;
		dm_read_data_reg 				<= dm_read_data;
		pc_plus4_reg_4 					<= pc_plus4_reg_3;
		rf_rd_reg_3						<= rf_rd_reg_2;

		rf_reg_file_wr_rd_sel_reg_3 	<= rf_reg_file_wr_rd_sel_reg_2;
		dm_result_sel_reg_3 			<= dm_result_sel_reg_2;
	end
end


hazard_unit hu(.rf_rs1(rf_rs1),.rf_rs2(rf_rs2),.rf_rd_reg(rf_rd_reg),
				.dm_result_sel_reg(dm_result_sel_reg[0]),
				.rf_rs1_reg(rf_rs1_reg),.rf_rs2_reg(rf_rs2_reg),
				.alu1_operandA_forward_sel(alu1_operandA_forward_sel),
				.alu1_operandB_forward_sel(alu1_operandB_forward_sel),.rf_rd_reg_2(rf_rd_reg_2),.rf_rd_reg_3(rf_rd_reg_3),
				.rf_reg_file_wr_rd_sel_reg_2(rf_reg_file_wr_rd_sel_reg_2),
				.rf_reg_file_wr_rd_sel_reg_3(rf_reg_file_wr_rd_sel_reg_3),
				.stall_decode_stg (stall_decode_stg),
				.stall_fetch_stg  (stall_fetch_stg),
				.flush_decode_stg (flush_decode_stg),
				.flush_execute_stg(flush_execute_stg),
				.pc_sel(pc_sel)
				);

always_ff @(posedge clk) begin

    if (reset_counter < 4'b1010) begin
        rst <= 0;  // keep reset active
        reset_counter <= reset_counter + 1;
    end
    else begin
        rst <= 1;  // deassert reset after 5 cycles
        reset_counter <= reset_counter;
    end
end


assign pc_plus4 = pc_curr_addr + 32'h00000004;


always_comb begin
		if(pc_sel)
			 pc_muxed_nxt_addr <= pc_curr_addr_reg_2 + se_extended_imm_reg;
		  else
			 pc_muxed_nxt_addr <= pc_plus4;
end



//alu
always_comb begin
		if(alu1_src_sel_reg)
			alu1_operandB = se_extended_imm_reg;
		else
			alu1_operandB = forward_alu1_operandB;	
end

//result

always_comb begin
    case (dm_result_sel_reg_3)
        2'b00: write_back_sig = alu1_result_reg_2;
        2'b01: write_back_sig = dm_read_data_reg;
        2'b10: write_back_sig = pc_plus4_reg_4;
        default: write_back_sig = 32'hDEADBEEF;
    endcase
end


// muxes for forwarding via control signals from hazard unit

always_comb begin
    case(alu1_operandA_forward_sel)
        2'b00: alu1_operandA = rf_read_data_reg;
        2'b01: alu1_operandA = write_back_sig; // from WB
        2'b10: alu1_operandA = alu1_result_reg; // from MEM
        default: alu1_operandA = 32'hDEADBEEF;
    endcase
end

always_comb begin
    case(alu1_operandB_forward_sel)
        2'b00: forward_alu1_operandB = rf_read_data2_reg;
        2'b01: forward_alu1_operandB = write_back_sig;
        2'b10: forward_alu1_operandB = alu1_result_reg;
        default: forward_alu1_operandB = 32'hDEADBEEF;
    endcase
end

//ila_for_signals ila(.clk(clk),
  //  .probe0(rst), // input wire [0:0]  probe0  
	//.probe1(led), // input wire [0:0]  probe1 
	//.probe2(alu1_result), // input wire [31:0]  probe2 
	//.probe3(i_mem_rd_data), // input wire [31:0]  probe3 
	//.probe4(pc_curr_addr), // input wire [31:0]  probe4 
	//.probe5(pc_muxed_nxt_addr), // input wire [31:0]  probe5 
	//.probe6(write_back_sig), // input wire [31:0]  probe6)
	//.probe7(reset_counter)
//);        

endmodule