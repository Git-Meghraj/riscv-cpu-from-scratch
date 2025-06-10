module ALU(
    input  logic  [31:0] inp_A, 
    input  logic  [31:0] inp_B,
    input  logic [2:0]  sel,
    output logic  [31:0] result,
    output logic        zero_flag
);
    always_comb begin
            // Default assignments
        result = 32'sd0;
        zero_flag = 1'b0;
        case(sel)
            3'b000: result = inp_A + inp_B;             // ADD
            3'b001: result = inp_A - inp_B;             // SUB
            3'b010: result = inp_A & inp_B;             // AND
            3'b011: result = inp_A | inp_B;             // OR
            3'b100: result = (inp_A < inp_B) ? 32'd1 : 32'd0; // SLT
			3'b101: begin
					result = inp_A - inp_B;
					zero_flag = (inp_A == inp_B);   //beq
					end
            default: result = 32'hDEADBEEF;             // Default case
        endcase

        // Set zero_flag based on the result
       // zero_flag = (result == 32'd0) ? 1'b1 : 1'b0;
    end
endmodule
