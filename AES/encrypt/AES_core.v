module AES_core(
    input   [127:0] plain_text,
    input   [127:0] cipher_key,
    output [127:0] cipher_text);

wire [127:0] out_rnd0;
wire [127:0] out_rnd[10:1];
wire [43:4] rndNo_Reg;
wire [127:0] out_subBytes [10:1];
wire [127:0] out_shiftRow [10:1];
wire [127:0] out_mixColumn [9:1]; // Not there in final round 
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

// since we are not using any clock, we can directly give the input plain text and key to get the cipher text

// AddRoundKey round 0
//rndNo would be 0
AddRoundKey add_round0(.state(plain_text), .inp_key(cipher_key), .out_state(out_rnd0));

genvar i;

generate
	
	key_schedule key_sdl(.in_key(cipher_key), .out_key(out_key_Schedule[1]), .round_no(rndNo_Reg[7:4]));
	sub_bytes sub_bt1(.inp(out_rnd0), .out(out_subBytes[1]));
	shift_rows shift_rw1(.inp(out_subBytes[1]), .out(out_shiftRow[1]));
	mix_column mix_clm1(.inp(out_shiftRow[1]), .out(out_mixColumn[1]));
	AddRoundKey add_round1(.state(out_mixColumn[1]), .inp_key(out_key_Schedule[1]), .out_state(out_rnd[1]));
	for(i=2; i<10; i=i+1) //from round 2 to round 9
	begin
	key_schedule key_shdli(.in_key(out_key_Schedule[i-1]), .out_key(out_key_Schedule[i]), .round_no(rndNo_Reg[4*i +:4]));
	sub_bytes sub_bti(.inp(out_rnd[i-1]), .out(out_subBytes[i]));
	shift_rows shift_rwi(.inp(out_subBytes[i]), .out(out_shiftRow[i]));
	mix_column mix_clmi(.inp(out_shiftRow[i]), .out(out_mixColumn[i]));
	AddRoundKey add_roundi(.state(out_mixColumn[i]), .inp_key(out_key_Schedule[i]), .out_state(out_rnd[i]));
	end
	// For round 10
	key_schedule key_shd10(.in_key(out_key_Schedule[9]), .out_key(out_key_Schedule[10]), .round_no(rndNo_Reg[43: 40]));
	sub_bytes sub_bt10(.inp(out_rnd[9]), .out(out_subBytes[10]));
	shift_rows shift_rw10(.inp(out_subBytes[10]), .out(out_shiftRow[10]));
	AddRoundKey add_round10(.state(out_shiftRow[10]), .inp_key(out_key_Schedule[10]), .out_state(out_rnd[10]));
	
endgenerate

assign cipher_text = out_rnd[10];
endmodule 
