module inverse_mix_column(input [127:0] inp, output[127:0] out);

wire [127:0] out_mix_colmn;
assign out = out_mix_colmn;

genvar i;
generate 
	for(i = 0; i<4;i =i+1)begin
	inverse_matrix_mult matr_mul(.in(inp[i*32 +: 32]), .out(out_mix_colmn[i*32 +: 32]));
	end
endgenerate
endmodule
