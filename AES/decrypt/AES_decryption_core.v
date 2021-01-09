module AES_decrypt_core(input   [127:0] cipher_text, input   [127:0] cipher_key, output [127:0] plain_text);
	
wire [127:0] out_rnd[10:1]; // 0th out_rnd would be the output 
wire [43:4] rndNo_Reg;
wire [127:0] out_subBytes [9:0];
wire [127:0] out_shiftRow [9:0];
wire [127:0] out_add_rnd [9:0]; // Not there in final round 
wire [127:0] out_key_Schedule [10:1];


module rnd_no_gen(input [3:0]round_start,output [43:4]round_values);
integer j;
reg [43:4] rnd_reg; 
reg [3:0] temp;
always@(*) begin
	temp = round_start;
	for (j = 1; j<11;j = j+1)begin
	rnd_reg[4*j +: 4] = temp;
	temp = temp + 4'h1;
	end
end
assign round_values = rnd_reg;
endmodule

rnd_no_gen rnd_gen(.round_start(4'h1), .round_values(rndNo_Reg));// Generated the round number used in key generation


key_schedule key_sd0(.in_key(cipher_key), .out_key(out_key_Schedule[1]), .round_no(rndNo_Reg[7:4]));
genvar k;
generate
	for (k = 2; k<11;k = k+1)begin
	key_schedule key_sdk(.in_key(out_key_Schedule[k-1]), .out_key(out_key_Schedule[k]), .round_no(rndNo_Reg[k*4 +:4]));
	end
endgenerate

inverse_AddRoundKey add_round_init(.state(cipher_text), .inp_key(out_key_Schedule[10]), .out_state(out_rnd[10])); //Initial addition with last key
// The above step uses the 10th key of the 10th round
genvar i;
generate
	
	//This is for inverse cipher key for the 9th round, as we have already used the 10th/last round key previously  
	inverse_shift_rows invshift_rw10(.inp(out_rnd[10]), .out(out_shiftRow[9]));
	inverse_sub_bytes invsub_bt10(.inp(out_shiftRow[9]), .out(out_subBytes[9]));
	inverse_AddRoundKey add_round10(.state(out_subBytes[9]), .inp_key(out_key_Schedule[9]), .out_state(out_add_rnd[9]));
	inverse_mix_column inv_mix_clm1(.inp(out_add_rnd[9]), .out(out_rnd[9]));
	

	for(i=8; i>0; i=i-1) //from round 9 to round 1
	begin
	
	inverse_shift_rows invshift_rwi(.inp(out_rnd[i+1]), .out(out_shiftRow[i]));
	inverse_sub_bytes invsub_bti(.inp(out_shiftRow[i]), .out(out_subBytes[i]));
	inverse_AddRoundKey add_roundi(.state(out_subBytes[i]), .inp_key(out_key_Schedule[i]), .out_state(out_add_rnd[i]));
	inverse_mix_column mix_clm1(.inp(out_add_rnd[i]), .out(out_rnd[i]));
	end
	// For round 0 with the original key
	inverse_shift_rows invshift_rw1(.inp(out_rnd[1]), .out(out_shiftRow[0]));
	inverse_sub_bytes invsub_bt1(.inp(out_shiftRow[0]), .out(out_subBytes[0]));
	inverse_AddRoundKey add_round1(.state(out_subBytes[0]), .inp_key(cipher_key), .out_state(plain_text));
	
endgenerate

endmodule 
