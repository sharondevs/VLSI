
module mux(output reg [31:0]out , input[31:0]in_0,in_1, input sel);
	always@(in_0,in_1, sel)begin
	case(sel)
	0 : out = in_0;
	1 : out = in_1;
	default : out = {32{1'bz}};
	endcase
	end
endmodule 

module five_bit_nor(output reg out, input a,b,c,d,e);
	always@(a,b,c,d,e)begin
	out = (a)&(~b)&(~c)&(~d)&(~e);
	end
endmodule 

module priority_encoder(output outN,outE,outS,outW, input wire N,E,S,W,inject);
	five_bit_nor nor1(.a(inject),.b(1'b0),.c(1'b0),.d(1'b0),.e(N),.out(outN));
	five_bit_nor nor2(.a(inject),.b(1'b0),.c(1'b0),.d(E),.e(outN),.out(outE));
	five_bit_nor nor3(.a(inject),.b(1'b0),.c(S),.d(outE),.e(outN),.out(outS));
	five_bit_nor nor4(.a(inject),.b(W),.c(outE),.d(outN),.e(outS),.out(outW));
endmodule

module injection_engine(output [31:0]outN,outE,outS, outW ,input [31:0]eject_N, eject_E, eject_S, eject_W, inject_port, input inject_req, output reg inject_grand);
	wire N_sel,E_sel, S_sel, W_sel;
	priority_encoder encoder(.N(eject_N[1]), .E(eject_E[1]),.W(eject_W[1]),.S(eject_S[1]),.inject(inject_req), .outN(N_sel),.outE(E_sel),.outS(S_sel),.outW(W_sel));
	mux mux_in_N(.in_0(eject_N), .in_1(inject_port), .sel(N_sel), .out(outN));
	mux mux_in_E(.in_0(eject_E), .in_1(inject_port), .sel(E_sel), .out(outE));
	mux mux_in_S(.in_0(eject_S), .in_1(inject_port), .sel(S_sel), .out(outS));
	mux mux_in_W(.in_0(eject_W), .in_1(inject_port), .sel(W_sel), .out(outW));
	always@(*)begin
	inject_grand = N_sel | E_sel | S_sel | W_sel;
	end
endmodule