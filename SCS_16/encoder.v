
module enc_module(output [15:0]out, input wire[15:0] x, input wire[15:0]y);
	reg inv;
	reg test;
	wire [14:0]inT2, inT4stst;
	wire [3:0]countT2,countT4stst;
	//reg [4:0]ctT2, ctT4stst;

	//Module instantiation
	// Here the flit size is 32 bits, and the 0th bit indicates the inverted condition, and hence is reserved
	// for that. Care must be taken that while encoding(inverting), this 0th bit should be excluded.
	T2  t2[14:0](.out(inT2), .a(x[14:0]), .b(x[15:1]), .c(y[14:0]), .d(y[15:1]));
	T4stst t4stst[14:0](.out(inT4stst),.a(x[14:0]), .b(x[15:1]), .c(y[14:0]), .d(y[15:1]));
	ones oneT2(.count(countT2) , .in(inT2));
	ones oneT4stst(.count(countT4stst) , .in(inT4stst));
	exor xr[14:0](.out(out[14:0]), .a(x[14:0]), .b({15{inv}}));
	assign out[15] = inv;
	always@(*) begin
	if (countT2> countT4stst) begin
		inv = 1;
		//test= 1;
		
	end else 
		inv = 0;
	end
endmodule

module encoder(output [31:0]out, input wire[31:0] x, input wire[31:0]y);
	enc_module enc1(.out(out[15:0]),.x(x[15:0]), .y(y[15:0]));
	enc_module enc2(.out(out[31:16]), .x(x[31:16]), .y(y[31:16])); 
endmodule
