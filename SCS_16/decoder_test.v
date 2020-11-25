`timescale 1ns/1ns

module test_dec();
	reg [31:0]x;
	wire [31:0] out;
	decoder dec (.out(out), .in(x));
	initial begin 
		#10
		x = 32'h00000000;
		
		#10
		x = 32'haaaaaaaa;
		
		#10
		$finish;
	end
endmodule