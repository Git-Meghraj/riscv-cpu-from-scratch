module TB_RISCV_CPU();

logic clk = 0;

always begin
	#5;
	clk = ~clk;
end

RISCV_CPU_top DUT(.clk(clk));


endmodule