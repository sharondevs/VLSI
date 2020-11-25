`timescale 1ns/1ns

module test_enc();
	reg [31:0]x,y;
	wire [31:0] out;
	encoder enc (.out(out), .x(x), .y(y));
	initial begin 
		#10
		x = 32'h00000000;
		y = 32'h11111111;
		#10
		x = 32'haaaaaaaa;
		y = 32'h55555555;
		#10
		$finish;
	end
endmodule
