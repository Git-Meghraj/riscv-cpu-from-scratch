module decode_and_control_unit(	input logic[31:0] input_instruction,
								
								);
								
logic[6:0] opcode;
logic[2:0] funct3;
logic[6:0] funct7;

assign opcode  = input_instruction[6:0];
assign funct3  = input_instruction[14:12];
assign funct7  = input_instruction[31:25];

