module router_arch(output [31:0]N_output, E_output, S_output, W_output, input [31:0] in_N, in_E, in_S, in_W, inject_flit, input inj_bit, injection_status);
	//Intermediate wires
	wire [31:0] outN,outE,outS,outW;
	wire [31:0] injNout,injEout,injSout,injWout;
	eject_engine eje(.outN(outN),.outE(outE),.outS(outS),.outW(outW), .in_0(in_N), .in_1(in_E), .in_2(in_S), .in_3(in_W));
	injection_engine inj(.outN(injNout), .outE(injEout),.outS(injSout), .outW(injWout), .eject_N(outN), .eject_E(outE), .eject_S(outS), .eject_W(outW), .inject_port(inject_flit), .inject_req(inj_bit), .inject_grand(injection_status));
	permutation_engine per(.PNout(N_output), .PEout(E_output), .PSout(S_output), .PWout(W_output), .PNin(injNout), .PEin(injEout), .PSin(injSout), .PWin(injWout));
endmodule


