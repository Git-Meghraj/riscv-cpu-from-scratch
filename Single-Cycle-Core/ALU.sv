module ALU(	input logic[31:0] inp_A, 
			input logic[31:0] inp_B,
			input logic [2:0] sel,
			output logic[31:0] result,
			output logic zero_flag
			);
logic zero_flg = 1'b0;	
assign zero_flag = zero_flg;		
always_comb begin
	case(sel)
		3'b000: result = inp_A + inp_B; //add
		3'b001: result = inp_A - inp_B; //subtract
		3'b010: result = inp_A & inp_B; //AND
		3'b011: result = inp_A | inp_B; //OR
		3'b101: begin zero_flg = ((inp_A - inp_B)== 32'd0) ? 1'b1 : 1'b0; 
				result = (inp_A < inp_B) ? 32'd1 : 32'd0;
				end //Set Less Than SLT (1 if the first operand is less than the second, otherwise sets it to 0)
		default : result = 32'hDEADBEEF;	
	endcase
end
endmodule