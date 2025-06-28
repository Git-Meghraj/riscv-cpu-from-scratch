module hazard_unit (
    input  logic [4:0] rf_rs1,
    input  logic [4:0] rf_rs2,
    input  logic [4:0] rf_rs1_reg,
    input  logic [4:0] rf_rs2_reg,
    input  logic [4:0] rf_rd_reg,
    input  logic [4:0] rf_rd_reg_2,  // MEM stage destination register
    input  logic [4:0] rf_rd_reg_3,  // WB stage destination register
    input  logic rf_reg_file_wr_rd_sel_reg_2, // MEM stage write enable
    input  logic rf_reg_file_wr_rd_sel_reg_3, // WB stage write enable
    output logic [1:0] alu1_operandA_forward_sel,
    output logic [1:0] alu1_operandB_forward_sel,
	output logic stall_decode_stg,
	output logic stall_fetch_stg,
	output logic flush_decode_stg,
	output logic flush_execute_stg,
	input logic  dm_result_sel_reg,
	input logic pc_sel
);

logic lw_stall_sig = 0;

	always_comb begin
		// --- FORWARDING FOR RS1 ---
		if ((rf_rs1_reg == rf_rd_reg_2) & rf_reg_file_wr_rd_sel_reg_2 & (rf_rs1_reg != 0) ) begin
			alu1_operandA_forward_sel = 2'b10; // MEM
		end
		else if ((rf_rs1_reg == rf_rd_reg_3) & rf_reg_file_wr_rd_sel_reg_3 & (rf_rs1_reg != 5'd0)  ) begin
			alu1_operandA_forward_sel = 2'b01; // WB
		end
		else begin
			alu1_operandA_forward_sel = 2'b00; // No forwarding
		end
	
		// --- FORWARDING FOR RS2 ---
		if ((rf_rs2_reg == rf_rd_reg_2) & rf_reg_file_wr_rd_sel_reg_2 & (rf_rs2_reg != 0) ) begin
			alu1_operandB_forward_sel = 2'b10; // MEM
		end
		else if ((rf_rs2_reg == rf_rd_reg_3) & rf_reg_file_wr_rd_sel_reg_3 & (rf_rs2_reg != 5'd0)  ) begin
			alu1_operandB_forward_sel = 2'b01; // WB
		end
		else begin
			alu1_operandB_forward_sel = 2'b00; // No forwarding
		end
	end
	
	// --- Load-Use Hazard Stall Detection ---
    always_comb begin
		//Stalling when lw hazard
        lw_stall_sig = dm_result_sel_reg & ((rf_rs1 == rf_rd_reg) | (rf_rs2 == rf_rd_reg));
	
        stall_fetch_stg  = lw_stall_sig;
        stall_decode_stg = lw_stall_sig;
		
		//Flushing when a branching or when lw stalls the pipeline
        flush_decode_stg  = pc_sel;
        flush_execute_stg = pc_sel | lw_stall_sig;
    end
	
	
endmodule