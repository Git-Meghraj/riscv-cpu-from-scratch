module register_file (	input logic clk,
						input logic wr_rd_en,
						input logic [31:0] write_port,
						input logic [4:0] addr_wr,
						input logic [4:0] addr_rd_port1,
						input logic [4:0] addr_rd_port2,
						output logic [31:0] read_port_1,
						output logic [31:0] read_port_2);
						
logic [31:0] registers [31:0] ; 
						
    // Synchronous write, except to register 0 since it is hardwired to 0 in risc 
    always_ff @(posedge clk) begin
        if (wr_rd_en && addr_wr != 5'd0) begin
            registers[addr_wr] <= write_port;
        end
    end

    // Combinational read, register 0 hardwired to 0 in risc 
    assign read_port_1 = (addr_rd_port1 != 5'd0) ? registers[addr_rd_port1] : 32'd0;
    assign read_port_2 = (addr_rd_port2 != 5'd0) ? registers[addr_rd_port2] : 32'd0;


endmodule
						
				