module exor(output out,input a,b);
	reg temp ;
	assign out = temp;
	always@(a,b) begin
	temp = a ^ b;
	end
endmodule
