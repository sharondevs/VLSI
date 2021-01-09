module inverse_shift_rows(input [127:0] inp, output[127:0]out);
wire [127:0]op;

assign op[127:120] = inp[127:120]; // first byte remains unchanged with no shift
assign op[119:112] = inp[23:16]; // the second row is shifted to left by 1, hence the output 119-112 becomes the second row second column
assign op[111:104] =  inp[47:40]; //third row is shifted to left by 2
assign op[103:96] = inp[71:64]; // fourth is shifted by offset 3

assign op[95:88] = inp[95:88]; // first row, second column
assign op[87:80] = inp[119:112]; // second row, second column
assign op[79:72] = inp[15:8];  // third row, second column
assign op[71:64] = inp[39:32]; // fourth row, second column

assign op[63:56] = inp[63:56];
assign op[55:48] = inp[87:80];
assign op[47:40] = inp[111:104];
assign op[39:32] = inp[7:0];

assign op[31:24] = inp[31:24];
assign op[23:16] = inp[55:48];
assign op[15:8] = inp[79:72];
assign op[7:0] = inp[103:96];

assign out = op;
endmodule
