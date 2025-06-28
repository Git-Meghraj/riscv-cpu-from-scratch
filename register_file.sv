module register_file (	input logic clk,
						input logic wr_rd_en,
						input logic [31:0] write_port,
						input logic [4:0] addr_wr,
						input logic [4:0] addr_rd_port1,
						input logic [4:0] addr_rd_port2,
						output logic [31:0] read_port_1,
						output logic [31:0] read_port_2,
						output logic led);
						
logic [31:0] registers [31:0]; //= '{default:32'd0}; // initializing for simulation 
assign led = (registers[32'h0000000B] == 1) ? 1 : 0; 							
    // Synchronous write, except to register 0 since it is hardwired to 0 in risc 
	
	// Write occurs on the falling edge to ensure that the result of an instruction
	// is stored in the register file before the next instruction reads from it.
	// Since register reads are combinational and happen during the decode stage,
	// writing on the falling edge allows immediate subsequent instructions to see
	// the updated value in the same clock cycle, avoiding read-after-write hazards.
    always_ff @(negedge clk) begin
        if (wr_rd_en) begin
            registers[addr_wr] <= write_port;
        end
    end

    //always_ff @(posedge clk) begin
      //  read_port_1 <= (addr_rd_port1 != 5'd0) ? registers[addr_rd_port1] : 32'd0;
        //read_port_2 <= (addr_rd_port2 != 5'd0) ? registers[addr_rd_port2] : 32'd0;
    //end

    // Combinational read, register 0 hardwired to 0 in risc 
    assign read_port_1 = (addr_rd_port1 != 5'd0) ? registers[addr_rd_port1] : 32'd0;
    assign read_port_2 = (addr_rd_port2 != 5'd0) ? registers[addr_rd_port2] : 32'd0;


endmodule
						
				