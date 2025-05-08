module register_file (	input logic clk,
						input logic rst,
						input logic wr_rd_en,
						input logic [31:0] write_port,
						input logic [4:0] addr_wr,
						input logic [4:0] addr_rd_port1,
						input logic [4:0] addr_rd_port2,
						input logic [31:0] read_port_1,
						output logic [31:0] read_port_2);
						
logic [31:0] registers [31:0]; 
						
always_ff@(posedge clk) begin
	if(~rst) begin
		read_port_1 <= 32'hDEADBEEF;
		read_port_2 <= 32'hDEADBEEF;
	end
	else if(wr_rd_en) begin
		registers[addr_wr] <= write_data;
	end
	else if(~wr_rd_en) begin
		 read_port_1 <= registers[addr_rd_port1];
		 read_port_2 <= registers[addr_rd_port2];
		//based on instructions we use either 2 ports or 1 read port
		
	end	
endmodule
						
				