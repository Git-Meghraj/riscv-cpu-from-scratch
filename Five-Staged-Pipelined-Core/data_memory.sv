module data_memory(	input logic clk,
						input logic rst,
						input logic wr_rd_en,
						input logic  [31:0] write_data,
						input logic [31:0] addr,
						output logic  [31:0] read_data);
						
logic [31:0] registers [63:0]; 
						
always_ff@(posedge clk) begin
    if(wr_rd_en) begin
		registers[addr[31:2]] <= write_data;
	end
end

	assign read_data = registers[addr[31:2]];
	
endmodule