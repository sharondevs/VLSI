module exor(output out,input a,b);
	reg temp ;
	assign out = temp;
	always@(a,b) begin
	temp = a ^ b;
	end
endmodule

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

module ones(output [4:0]count ,input [30:0]in);
	reg [4:0]temp;
	integer i;
	assign count = temp;
	always@(in) begin
	temp = 0;
	for (i=0;i<31;i=i+1) begin
		temp = temp + in[i];
	end
	end
	
endmodule


module encoder(output [31:0]out, input wire[31:0] x, input wire[31:0]y);
	reg inv;
	reg test;
	wire [30:0]inT2, inT4stst;
	wire [4:0]countT2,countT4stst;
	//reg [4:0]ctT2, ctT4stst;

	//Module instantiation
	// Here the flit size is 32 bits, and the 0th bit indicates the inverted condition, and hence is reserved
	// for that. Care must be taken that while encoding(inverting), this 0th bit should be excluded.
	T2  t2[30:0](.out(inT2), .a(x[30:0]), .b(x[31:1]), .c(y[30:0]), .d(y[31:1]));
	T4stst t4stst[30:0](.out(inT4stst),.a(x[30:0]), .b(x[31:1]), .c(y[30:0]), .d(y[31:1]));
	ones oneT2(.count(countT2) , .in(inT2));
	ones oneT4stst(.count(countT4stst) , .in(inT4stst));
	exor xr[30:0](.out(out[30:0]), .a(x[30:0]), .b({31{inv}}));
	assign out[31] = inv;
	always@(*) begin
	if (countT2> countT4stst) begin
		inv = 1;
		//test= 1;
		
	end else 
		inv = 0;
	end
endmodule
