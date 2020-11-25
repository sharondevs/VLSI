module decoder(output [31:0] out, input [31:0]in);
	reg [31:0]temp;
	always@(in) begin
	temp[30:0] = in[30:0] ^ {31{in[31]}};
	temp[31] = in[31];
	end
	assign out = temp;
endmodule