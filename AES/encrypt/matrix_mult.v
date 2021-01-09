module matrix_mult(input [31:0] in, output [31:0] out);
// Referred from Wikipedia
wire [7:0] b0;
wire [7:0] b1;
wire [7:0] b2;
wire [7:0] b3;
wire [7:0] a0;
wire [7:0] a1;
wire [7:0] a2;
wire [7:0] a3;

assign a0 = in[31:24];
assign a1 = in[23:16];
assign a2 = in[15:8];
assign a3 = in[7:0];
 // if the first bit of a is set, then we shift it by 1 and then we xor with "1B" to get 2*a 
 // if its reset (0) , then we just shift by 1 and not do anything else
 // To get 3*a , we multiply the corresponding b value with that a value , b[i]* a[i] = 3*a[i], where b[i] = 2*a[i]
assign b0 = (a0[7]==1'b1)?((a0<<1)^(8'h1b)):(a0<<1); 
assign b1 = (a1[7]==1'b1)?((a1<<1)^(8'h1b)):(a1<<1);
assign b2 = (a2[7]==1'b1)?((a2<<1)^(8'h1b)):(a2<<1);
assign b3 = (a3[7]==1'b1)?((a3<<1)^(8'h1b)):(a3<<1);

assign out[31:24] = b0^a3^a2^b1^a1; 
assign out[23:16] = b1^a0^a3^b2^a2;
assign out[15:8] = b2^a1^a0^b3^a3;
assign out[7:0] = b3^a2^a1^b0^a0;



endmodule 
