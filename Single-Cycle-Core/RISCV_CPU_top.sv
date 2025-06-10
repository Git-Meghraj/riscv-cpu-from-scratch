module RISCV_CPU_top(	input logic clk_125mhz,
                        output logic led
		    );




logic rst;	
	
logic clk = 1'b0;					
logic [3:0]clk_divider = 4'd0;	
logic [3:0]reset_counter = 4'd0;	
//program_counter signals
logic [31:0] pc_muxed_nxt_addr= 32'd0;
wire [31:0] pc_curr_addr;
logic pc_sel;

//instruction_memory signals
logic [31:0] i_mem_rd_data ;

wire [4:0] rf_rs1;
wire [4:0] rf_rs2;
wire [4:0] rf_rd;
logic rf_reg_file_wr_rd_sel;
logic  [31:0] rf_read_data ;
logic  [31:0] rf_read_data2;
logic led_sig;
assign led = led_sig;
assign rf_rs1 =  i_mem_rd_data[19:15];
assign rf_rs2 =  i_mem_rd_data[24:20];
assign rf_rd  =  i_mem_rd_data[11:7];


//  clk_wiz_0 clk_wizard
//   (
//    // Clock out ports
//    .clk_out1(clk),     // output clk_out1
//   // Clock in ports
//    .clk_in1(clk_125mhz)); 

//sign_extender signals
logic  [31:0] se_extended_imm;
logic [1:0]se_imm_sel;

//ALU signals
logic  [31:0] alu1_result;
logic alu1_src_sel;
logic zero_flag;
logic[2:0] alu1_op_sel;
logic  [31:0]  alu1_operandA;
logic  [31:0]  alu1_operandB;

assign alu1_operandA = rf_read_data;

//data_memory signals
logic  [31:0] dm_read_data;
logic [1:0] dm_result_sel;
logic  [31:0] write_back_sig;
logic dm_data_mem_wr_rd_sel;


program_counter pc(.next_addr(pc_muxed_nxt_addr),.curr_addr(pc_curr_addr),.clk(clk),.rst(rst));

instruction_memory i_mem(.read_address(pc_curr_addr), .read_data(i_mem_rd_data));

sign_extender se(.input_value(i_mem_rd_data),.sign_extended_value(se_extended_imm),.imm_sel(se_imm_sel));

register_file rf(	.clk(clk),
					.wr_rd_en(rf_reg_file_wr_rd_sel),
					.write_port(write_back_sig), //write back from the data_memory 
					.addr_wr(rf_rd),
					.addr_rd_port1(rf_rs1),
					.addr_rd_port2(rf_rs2),
					.read_port_1(rf_read_data),
					.read_port_2(rf_read_data2),
					.led(led_sig)
					);

ALU alu1(.inp_A(alu1_operandA), .inp_B(alu1_operandB), .sel(alu1_op_sel), .result(alu1_result),.zero_flag(zero_flag));

data_memory dm(.clk(clk),.rst(rst),.wr_rd_en(dm_data_mem_wr_rd_sel),.write_data(rf_read_data2),.addr(alu1_result),.read_data(dm_read_data));

decode_and_control_unit dcu(.clk(clk),.input_instruction(i_mem_rd_data),.alu_operation_sel(alu1_op_sel),.pc_sel(pc_sel),.data_mem_wr_rd_sel(dm_data_mem_wr_rd_sel),
							.alu_B_input_sel(alu1_src_sel),.imm_sel_out(se_imm_sel),.zero_flag(zero_flag),.reg_file_wr_rd_sel(rf_reg_file_wr_rd_sel),.result_sel(dm_result_sel)) ;

//clk divider circuit
always_ff @(posedge clk_125mhz) begin
    if (clk_divider == 4'b0010) begin
        clk <= ~clk;  
        clk_divider <= 4'd0;
    end
    else begin
        clk_divider <= clk_divider + 1;
    end
end

always_ff @(posedge clk) begin

    if (reset_counter < 4'b1111) begin
        rst <= 0;  // keep reset active
        reset_counter <= reset_counter + 1;
    end
    else begin
        rst <= 1;  // deassert reset after 5 cycles
        reset_counter <= reset_counter;
    end
end

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
		if(dm_result_sel == 2'b00)
			write_back_sig = alu1_result ;
		else if (dm_result_sel == 2'b01)
			write_back_sig = dm_read_data;	
		else if (dm_result_sel == 2'b10)
			write_back_sig = pc_curr_addr + 32'h00000004;
		else
			write_back_sig = 32'hDEADBEEF;
end

endmodule