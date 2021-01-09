
module inverse_matrix_mult(input [31:0] in, output [31:0] out);

wire [7:0] a0;
wire [7:0] a1;
wire [7:0] a2;
wire [7:0] a3;

assign a0 = in[31:24];
assign a1 = in[23:16];
assign a2 = in[15:8];
assign a3 = in[7:0];

function automatic reg[7:0] mul_2(input [7:0] in);
begin
mul_2=(in[7]==1'b1)?((in<<1)^(8'h1b)):(in<<1);
end
endfunction


assign out[31:24] = ( mul_2(mul_2((mul_2(a0)^a0))^a0) )^( mul_2(mul_2(mul_2(a1))^a1)^a1 )^( mul_2(mul_2(mul_2(a2)^a2))^a2 )^( mul_2(mul_2(mul_2(a3)))^a3 );
assign out[23:16] = ( mul_2(mul_2(mul_2(a0)))^a0 )^(mul_2(mul_2((mul_2(a1)^a1))^a1) )^(mul_2(mul_2(mul_2(a2))^a2)^a2 )^( mul_2(mul_2(mul_2(a3)^a3))^a3 );
assign out[15:8] =  ( mul_2(mul_2(mul_2(a0)^a0))^a0 )^( mul_2(mul_2(mul_2(a1)))^a1 )^( mul_2(mul_2((mul_2(a2)^a2))^a2) )^( mul_2(mul_2(mul_2(a3))^a3)^a3 );
assign out[7:0] =  ( mul_2(mul_2(mul_2(a0))^a0)^a0 )^( mul_2(mul_2(mul_2(a1)^a1))^a1 )^( mul_2(mul_2(mul_2(a2)))^a2 )^( mul_2(mul_2((mul_2(a3)^a3))^a3) );


endmodule 
