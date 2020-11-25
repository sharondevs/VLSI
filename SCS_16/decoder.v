module decoder(output [15:0] out, input [15:0]in);
	reg [15:0]temp;
	always@(in) begin
	temp[14:0] = in[14:0] ^ {15{in[15]}};
	temp[15] = in[15];
	end
	assign out = temp;
endmodule


module decoder(output [31:0]out, input wire[31:0] in);
	dec_module dec1(.out(out[15:0]),.in(in[15:0]));
	dec_module dec2(.out(out[31:16]), .in(in[31:16])); 
endmodule