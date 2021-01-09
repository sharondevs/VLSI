module sub_bytes(input [127:0] inp,  output [127:0] out);
wire [127:0] out_sbox;

assign out = out_sbox;
genvar i;
generate 
	for( i =0; i<16; i = i+1)begin
	aes_sbox sbox(.ip(inp[8*i +: 8]), .out(out_sbox[8*i +: 8]) );
	end

endgenerate 

endmodule
