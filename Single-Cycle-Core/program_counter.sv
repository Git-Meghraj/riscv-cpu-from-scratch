module program_counter(	input logic [31:0] next_addr,
						input logic clk,
						input logic rst,
						output logic [31:0] curr_addr
						);

	always_ff@(posedge clk) begin
		if(~rst) begin
		curr_addr <= 32'h00001000;
		end
		else begin
		curr_addr <= next_addr;
		end
	end
		
endmodule