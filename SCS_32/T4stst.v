module T4stst(output reg out, input a,b,c,d);
	always@(a,b,c,d)begin
	if ({b,a}== 2'b01 && {d,c}== 2'b01)
		out = 1;
	else if({b,a}== 2'b10 && {d,c}== 2'b10)
		out = 1;
	else
		out = 0;
end
endmodule
