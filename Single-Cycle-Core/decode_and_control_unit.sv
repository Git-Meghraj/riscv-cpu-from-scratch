module decode_and_control_unit(	input logic[31:0] input_instruction,
								input logic zero_flag,
								output logic[2:0] alu_operation_sel,
								output logic alu_B_input_sel,
								output logic pc_sel,
								output logic data_mem_wr_rd_sel,
								output logic reg_file_wr_rd_sel,
								output logic[1:0] imm_sel_out,
								output logic[1:0] result_sel,
								input logic clk				
								);
								
logic[6:0] opcode;
logic[2:0] funct3;
logic[6:0] funct7;
logic branch_inp = 1'b0;
logic jump_inp = 1'b0;
//enums
typedef enum logic [2:0] {
    R_TYPE = 3'b000,
    I_TYPE_ALU = 3'b001,
    I_TYPE = 3'b010,
    S_TYPE = 3'b011,
    B_TYPE = 3'b101,
    J_TYPE = 3'b110,
    INVALID_TYPE = 3'b111
} instr_type_t;

typedef enum logic [2:0] {
    ALU_ADD     = 3'b000,
    ALU_SUB     = 3'b001,
    ALU_AND     = 3'b010,
    ALU_OR      = 3'b011,
    ALU_SLT     = 3'b100,
	ALU_BEQ		= 3'b101,
    ALU_INVALID = 3'bxxx
} alu_op_t;


instr_type_t instr_type;
alu_op_t alu_op;

assign opcode  = input_instruction[6:0];
assign funct3  = input_instruction[14:12];
assign funct7  = input_instruction[31:25];

///instruction type decoding based on opcode
always_comb begin
    case (opcode)
        7'b0110011						: instr_type = R_TYPE;       // add, sub, etc.
        7'b0010011						: instr_type = I_TYPE_ALU;       //  addi, etc
        7'b0000011						: instr_type = I_TYPE; 		 // lw,etc.
		7'b0100011						: instr_type = S_TYPE;       // sw, sb, etc.
        7'b1100011						: instr_type = B_TYPE;       // beq, etc.
        7'b1101111						: instr_type = J_TYPE;       // jal, etc.
        default							: instr_type = INVALID_TYPE;
    endcase
end

///control signals generation based on instruction type, funct3 and funct7 
always_comb begin
  case (instr_type)
    R_TYPE: begin
		alu_B_input_sel = 1'b0;		/// select rs2 for alu B 
		reg_file_wr_rd_sel = 1'b1;
		data_mem_wr_rd_sel = 1'b0;
		result_sel = 2'b00;
	    imm_sel_out= 2'bxx;
		branch_inp = 1'b0;
		jump_inp = 1'b0;
		case ({funct3 , funct7})
			{3'b000 , 7'b0000000}: alu_op = ALU_ADD ;
			{3'b000 , 7'b0100000}: alu_op = ALU_SUB ;
			{3'b111 , 7'b0000000}: alu_op = ALU_AND ;
			{3'b110 , 7'b0000000}: alu_op = ALU_OR  ;
			{3'b001 , 7'b0000000}: alu_op = ALU_SLT ;
			default: alu_op = ALU_INVALID;
		endcase
    end
	
    I_TYPE_ALU: begin
	  alu_B_input_sel = 1'b1;		/// select rs2 for alu B 
	  reg_file_wr_rd_sel = 1'b1;
	  data_mem_wr_rd_sel = 1'b0;
	  imm_sel_out 	= 2'b00;	/// select input_value[31:20] and extend sign
      result_sel = 2'b00;
	  branch_inp = 1'b0;
	  jump_inp = 1'b0;
	  	  case (funct3)
        3'b000: alu_op = ALU_ADD;
        3'b111: alu_op = ALU_AND;
        3'b110: alu_op = ALU_OR;
        3'b010: alu_op = ALU_SLT;
        default: alu_op = ALU_INVALID;
      endcase
      
    end

    I_TYPE: begin
	  alu_B_input_sel = 1'b1;		/// select rs2 for alu B 
	  reg_file_wr_rd_sel = 1'b1;
	  data_mem_wr_rd_sel = 1'b0;
	  imm_sel_out 	= 2'b00;	/// select input_value[31:20] and extend sign
      result_sel = 2'b01;
	  branch_inp = 1'b0;
	  jump_inp = 1'b0;
	  alu_op = ALU_ADD;
    end
	
	S_TYPE: begin
	  alu_B_input_sel = 1'b1;		/// select rs2 for alu B 
	  reg_file_wr_rd_sel = 1'b0;
	  data_mem_wr_rd_sel = 1'b1;
	  imm_sel_out 	= 2'b01;
	  result_sel = 2'bxx;
	  branch_inp = 1'b0;
	  jump_inp = 1'b0;
	  alu_op = ALU_ADD;
    end
 
    B_TYPE: begin
		alu_B_input_sel = 1'b0;		/// select rs2 for alu B 
		reg_file_wr_rd_sel = 1'b0;
		data_mem_wr_rd_sel = 1'b0;
		imm_sel_out 	= 2'b10;
		result_sel = 2'bxx;
		branch_inp = 1'b1;
		jump_inp = 1'b0;
		alu_op = ALU_BEQ;
    end
 
	J_TYPE: begin
	    alu_B_input_sel = 1'bx;		/// select rs2 for alu B 
		reg_file_wr_rd_sel = 1'b1;
		data_mem_wr_rd_sel = 1'b0;
		result_sel = 2'b10;
		imm_sel_out 	= 2'b11;
		jump_inp = 1'b1;
		branch_inp = 1'b0;
		alu_op = ALU_INVALID;
    end
    default: begin
    	alu_B_input_sel = 1'b0;		/// select rs2 for alu B 
		reg_file_wr_rd_sel = 1'b0;
		data_mem_wr_rd_sel = 1'b0;
		result_sel = 2'b00;
		imm_sel_out 	= 2'b00;
		jump_inp = 1'b0;
		branch_inp = 1'b0;
		alu_op = ALU_INVALID;
    end
  endcase
end

assign alu_operation_sel = alu_op;
assign pc_sel = ((zero_flag & branch_inp) | jump_inp == 1'b1) ? 1'b1: 1'b0;

endmodule