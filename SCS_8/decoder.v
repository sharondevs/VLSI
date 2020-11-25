module dec_module(output [7:0] out, input [7:0]in);
	reg [7:0]temp;
	always@(*) begin
	temp[6:0] = in[6:0] ^ {7{in[7]}};
	temp[7] = in[7];
	end
	assign out = temp;
endmodule

module decoder(output [31:0]out, input wire[31:0] in);
	dec_module dec1(.out(out[7:0]),.in(in[7:0]));
	dec_module dec2(.out(out[15:8]), .in(in[15:8])); 
	dec_module dec3(.out(out[23:16]),.in(in[23:16]));
	dec_module dec4(.out(out[31:24]), .in(in[31:24])); 
endmodule
