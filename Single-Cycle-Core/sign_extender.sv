module sign_extender ( 	input logic [31:0] input_value,
						input logic[1:0] imm_sel,
						output logic [31:0] sign_extended_value
						);

always_comb begin
	case(imm_sel) 
	// replicate and concat operators used for extension
	2'b00 :	sign_extended_value = { {20{input_value[31]}}, input_value[31:20] }; 
	2'b01 :	sign_extended_value = { {20{input_value[31]}}, input_value[31:25], input_value[11:7]}; 
	2'b10 :	sign_extended_value = { {20{input_value[31]}}, input_value[7], input_value[30:25], input_value[11:8], 1'b0}; 
	2'b11 :	sign_extended_value = { {12{input_value[31]}}, input_value[19:12], input_value[20], input_value[30:21], 1'b0};
	endcase	
end

endmodule 