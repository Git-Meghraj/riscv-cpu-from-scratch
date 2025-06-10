module register_file (	input logic clk,
						input logic wr_rd_en,
						input logic  [31:0] write_port,
						input logic [4:0] addr_wr,
						input logic [4:0] addr_rd_port1,
						input logic [4:0] addr_rd_port2,
						output logic  [31:0] read_port_1,
						output logic  [31:0] read_port_2,
						output logic led);
						
logic [31:0] registers [31:0] ; 
logic [31:0] debug_x10;
logic [31:0] debug_x11;
logic [31:0] debug_x12;
logic [31:0] debug_x14;

assign debug_x10 = registers[5'h0000A];
assign debug_x11 = registers[5'h0000B];
assign debug_x12 = registers[5'h0000C];
assign debug_x14 = registers[5'h0000E];



assign led = (registers[11] == 1) ? 1 : 0; 		

initial begin
  for (int i = 0; i < 32; ++i)
    registers[i] = 32'd0;
end
					
    // Synchronous write, except to register 0 since it is hardwired to 0 in risc 
    always_ff @(posedge clk) begin
        if (wr_rd_en) begin
            registers[addr_wr] <= write_port;
        end
    end

    // Combinational read, register 0 hardwired to 0 in risc 
    assign read_port_1 = (addr_rd_port1 != 5'd0) ? registers[addr_rd_port1] : 32'd0;
    assign read_port_2 = (addr_rd_port2 != 5'd0) ? registers[addr_rd_port2] : 32'd0;

endmodule
						
				