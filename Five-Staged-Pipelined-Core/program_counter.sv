module program_counter(	input logic [31:0] next_addr,
						input logic clk,
						input logic rst,
						output logic [31:0] curr_addr,
						input logic stall_fetch_stg
						);
						
logic [31:0] curr_addr_sig = 32'h00000000;

assign curr_addr = curr_addr_sig;
 
	always_ff @(posedge clk) begin
        if (~rst) begin
            curr_addr_sig <= 32'h00000000;
        end else if (!stall_fetch_stg) begin
            curr_addr_sig <= next_addr;
        end
    end
	
endmodule