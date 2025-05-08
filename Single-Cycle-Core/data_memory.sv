module data_memory(	input logic clk,
						input logic rst,
						input logic wr_rd_en,
						input logic [31:0] write_data,
						input logic [4:0] addr,
						output logic [31:0] read_data);
						
logic [31:0] registers [31:0]; 
						
always_ff@(posedge clk) begin
	if(~rst) begin
		read_data <= 32'hDEADBEEF;
	end
	else if(wr_rd_en) begin
		registers[addr] <= write_data;
	end
	else if(~wr_rd_en) begin
		read_data <= registers[addr];
	end	
endmodule