module key_schedule(input [127:0] in_key, output [127:0] out_key, input [3:0] round_no);

wire [31:0] rot_w;
reg [31:0] rcon;
wire [31:0] sub_w;
wire [31:0] word [3:0];
//Rot_word()
assign rot_w ={in_key[23:0], in_key[31:24]};

//sub_word()

genvar i;
generate  // Instantiate 4 AES sbox modules
	for (i = 0; i <4; i=i+1)
	begin 
	aes_sbox sbox(.ip(rot_w[i*8 +: 8]), .out(sub_w[i*8 +: 8]));
	end
endgenerate 

// XOR operation 

assign word[0] = in_key[127:96] ^ sub_w ^ rcon; // The special transformation case where the position is a multiple of Nk=4
assign word[1] = in_key[95:64] ^ word[0]; //Normal XOR
assign word[2] = in_key[63:32] ^ word[1];
assign word[3] = in_key[31:0]  ^ word[2];

assign out_key = {word[0], word[1], word[2], word[3]};
always@(round_no) begin
	case(round_no)
	4'h1: rcon=32'h01000000;
	4'h2: rcon=32'h02000000;
        4'h3: rcon=32'h04000000;
        4'h4: rcon=32'h08000000;
        4'h5: rcon=32'h10000000;
        4'h6: rcon=32'h20000000;
        4'h7: rcon=32'h40000000;
        4'h8: rcon=32'h80000000;
        4'h9: rcon=32'h1b000000;
        4'ha: rcon=32'h36000000;
        default: rcon=32'h00000000;
	endcase 
end
endmodule