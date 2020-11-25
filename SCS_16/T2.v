module T2(output reg out, input a, b, c, d);
	always@(a,b,c,d) begin
	if ({b,a} ==2'b10 && {d,c} == 2'b01) begin
		out = 1;
	end else if({b,a} ==2'b01 && {d,c} == 2'b10) begin
		out = 1;
	end else begin
		out = 0;
	end
end
endmodule
