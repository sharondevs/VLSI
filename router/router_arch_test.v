//`timescale 10ns/10ns
//This is the common 2x2 arbiter module in the router
//This decided the priority of the flits going into the arbiter
module arbiter(output reg winner, input [31:0]arb_in_0,arb_in_1);
	always@(arb_in_0,arb_in_1) begin
	if((arb_in_0[0]&arb_in_1[0])==1) // Checking for the golden flit status of the flits and gets fullfilled if both golden
	winner = (arb_in_0[19:15]>arb_in_1[19:15]?1'b1:1'b0);
	else if(arb_in_0[0]==1) // Checking for the golden status of flit at arbiter port 0
	winner = 0;
	else if(arb_in_1[0]==1) // Checking for the golden status of flit at arbiter port 1
	winner=1;	
	else	
	winner = 0; // For fixed assginment, we choose the port 0
end
endmodule

//This is the ejector block
module eject_block(output reg[31:0]out, input [31:0] in_0,in_1); // This block accepts the two input flits for arbiteration and winner selection
	wire dual; reg test; 
	arbiter u1( .winner(dual), .arb_in_0(in_0), .arb_in_1(in_1)); //This is for instanstiating the module arbiter module and the port numeber is saved in the wire 'duel'
	always@(*)begin
	if ((in_0[6:4]==3'b100) && (in_1[6:4]==3'b100))begin // The 4,5,6 bits are used for indicating the output port requirement in the router and '100' is the code for local port. 	
		if (dual == 1'b0 )begin // This if is executed when two flits ask for local port, they are compared and arbitered with the above instantiated module an
		//test = 1'b1;	
		out = in_0;
		 end
		if (dual == 1'b1)begin
		out = in_1; //test=1'b0; 
                end
	end else if(in_0[6:4]==3'b100) begin // Checking if port 0 flit is seeking the local port 
		out = in_0;
	end else if(in_1[6:4]==3'b100)begin // Checking if port 1 flit is seeking thelocal port  
 	 	out = in_1; 
	end else begin
                out = 0;
	end

	//assign out =((~select)&in_0) | (select&in_1);
end
endmodule

module eject_engine( output reg[31:0]outN,outE,outS,outW ,input [31:0]in_0,in_1,in_2,in_3); // This constitutesthe entire eject module with the eject tree and the kill logic 
	wire [31:0]eject_1,eject_2,out;
	//The eject tree is given below 
	eject_block ejectNE(.out(eject_1),.in_0(in_0), .in_1(in_1));  //The eject block takes the flits from port N,E
	eject_block ejectSW(.out(eject_2),.in_0(in_2), .in_1(in_3)); // The eject block takes the flits from port S,W
	eject_block ejectout(.out(out),.in_0(eject_1), .in_1(eject_2)); // The ejected flit in 'out'
// We  are under the assumption that the N,E,S,W is assiged port numbers of 00,01,10,,11 respectively
// The flits have 2 and 3 bits as the input port indication bits
//Now for the eject kill logic, we make use of the inpot indication bits for killing the respective bits that we want to replace
	always@(out)begin  // This block checks for the input port of each flit within the flit bits indicated from 2-3 , agains tthe input port bits of the ejected flit 'out', obtained from the preveous module. 
	if(out[3:2]==in_0[3:2])begin
	outN= in_0;
	outN[1] = 0 ; end
	else
	outN = in_0;
	if (out[3:2] == in_1[3:2])begin
	outE= in_1; 
	outE[1] = 0; end
	else 
	outE= in_1;
	if (out[3:2] == in_2[3:2]) begin
	outS =in_2;
	outS[1] = 0; end
	else
	outS= in_2;
	if (out[3:2] == in_3[3:2])begin
	outW =in_3;
	outW[1] = 0;  end
	else 
	outW= in_3;
end
endmodule 



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
module port_assignment_stage1(output reg port_num,input [31:0]flit);
	always@(*)begin
	case(flit[6:4])
	3'b000 : port_num = 0;
	3'b001 : port_num = 1;
	3'b010 : port_num = 0;
	3'b011 : port_num = 1;
	endcase 
end
endmodule

module exchanger_stage1(output reg[31:0] flit_0_out,flit_1_out, input prio_flit_num, input [31:0]flit_0,flit_1);
	reg [31:0] prio_flit;
	reg stage = 0;
	wire port_num;
	port_assignment_stage1 assign_block1(.port_num(port_num), .flit(prio_flit));
	always@(*)begin
	if(prio_flit_num == 0)begin
	prio_flit = flit_0;
		if(port_num == 0) begin
		flit_0_out = prio_flit;
		flit_1_out = flit_1;
		end
		else begin
		flit_1_out = prio_flit;
		flit_0_out = flit_1;
		end
	end else begin
	prio_flit = flit_1;
		if(port_num == 0) begin
		flit_0_out = prio_flit;
		flit_1_out = flit_0;
		end else begin
		flit_1_out = prio_flit;
		flit_0_out = flit_0;
		end
	end
end
endmodule


module permuter_stage1(output [31:0] per_out_0,per_out_1 ,input [31:0] per_in_0,per_in_1 );
	wire sel_flit_num;
	arbiter arb(.winner(sel_flit_num), .arb_in_0(per_in_0), .arb_in_1(per_in_1));
	exchanger_stage1 exchange(.prio_flit_num(sel_flit_num),.flit_0(per_in_0), .flit_1(per_in_1), .flit_0_out(per_out_0), .flit_1_out(per_out_1));
endmodule 

module port_assignment_stage2(output reg port_num,input [31:0]flit);
	always@(*)begin
	case(flit[6:4])
	3'b000 : port_num = 0;
	3'b001 : port_num = 0;
	3'b010 : port_num = 1;
	3'b011 : port_num = 1;
	endcase 
end
endmodule

module exchanger_stage2(output reg [31:0] flit_0_out,flit_1_out, input prio_flit_num, input [31:0]flit_0,flit_1);
	reg [31:0] prio_flit;
	reg stage = 0;
	wire port_num;
	port_assignment_stage2 assign_block2(.port_num(port_num), .flit(prio_flit));
	always@(*)begin
	if(prio_flit_num == 0)begin
	prio_flit = flit_0;
		if(port_num == 0) begin
		flit_0_out = prio_flit;
		flit_1_out = flit_1;
		end
		else begin
		flit_1_out = prio_flit;
		flit_0_out = flit_1;
		end
	end else begin
	prio_flit = flit_1;
		if(port_num == 0) begin
		flit_0_out = prio_flit;
		flit_1_out = flit_0;
		end else begin
		flit_1_out = prio_flit;
		flit_0_out = flit_0;
		end
	end
end
endmodule

module permuter_stage2(output [31:0] per_out_0,per_out_1 ,input [31:0] per_in_0,per_in_1 );
	wire sel_flit_num;
	arbiter arb(.winner(sel_flit_num), .arb_in_0(per_in_0), .arb_in_1(per_in_1));
	exchanger_stage2 exchange(.prio_flit_num(sel_flit_num),.flit_0(per_in_0), .flit_1(per_in_1), .flit_0_out(per_out_0), .flit_1_out(per_out_1));
endmodule 

/*
The block instantiations in the permuter engine corresponds to the different arbiters in the permutation block
Block1 - The upper block in stage 1 (N,E inputs)
Block2 - The lower block in stage 1 (S,W inputs)
Block3 - The upper block in stage 2
Block4  - The lower block in stage 2
*/
module permutation_engine(output [31:0] PNout,PEout, PSout,PWout, input [31:0] PNin,PEin,PSin,PWin); 
	wire [31:0]inter_con1,inter_con2, inter_con3,inter_con4;
	// Stage 1 -
	permuter_stage1 block1(.per_out_0(inter_con1),.per_out_1(inter_con2) ,.per_in_0(PNin),.per_in_1(PEin));
	permuter_stage1 block2(.per_out_0(inter_con3),.per_out_1(inter_con4) ,.per_in_0(PSin),.per_in_1(PWin));
	// Stage 2 -
	permuter_stage2 block3(.per_out_0(PNout),.per_out_1(PSout) ,.per_in_0(inter_con1),.per_in_1(inter_con3));
	permuter_stage2 block4(.per_out_0(PEout),.per_out_1(PWout) ,.per_in_0(inter_con2),.per_in_1(inter_con4));

endmodule

//  This is the test bench for the above stage

/* Flit bits representations -  0(Golden or not)
				1(From indicating whether the flit was ejected out or not, and to be checked in the injector section)
				2-3(Input port indication bits 00-N, 01-E, 10-S, 11-W)
				4-6(For indicating the output port, 000-N,001-E,010-S,011-W,100-Local port)
				7-10(Source add.)
				11-14(Destination add.)
				15-19(5bit In-packet sequence indication number)
*/	

module router_arch(output [31:0]N_output, E_output, S_output, W_output, input [31:0] in_N, in_E, in_S, in_W, inject_flit, input inj_bit, injection_status);
	//Intermediate wires
	wire [31:0] outN,outE,outS,outW;
	wire [31:0] injNout,injEout,injSout,injWout;
	eject_engine eje(.outN(outN),.outE(outE),.outS(outS),.outW(outW), .in_0(in_N), .in_1(in_E), .in_2(in_S), .in_3(in_W));
	injection_engine inj(.outN(injNout), .outE(injEout),.outS(injSout), .outW(injWout), .eject_N(outN), .eject_E(outE), .eject_S(outS), .eject_W(outW), .inject_port(inject_flit), .inject_req(inj_bit), .inject_grand(injection_status));
	permutation_engine per(.PNout(N_output), .PEout(E_output), .PSout(S_output), .PWout(W_output), .PNin(injNout), .PEin(injEout), .PSin(injSout), .PWin(injWout));
endmodule




//Test Bench
// I have tried out different types of 32 bit flit combinations to evaluate the correctness of the router to supply the end results 
/*
module test();
	reg [31:0]in_N,in_E,in_S,in_W;
	reg [31:0] inject_flit;
	reg inj_bit; 
	wire injection_status;
	wire [31:0] outN,outE,outS,outW;
	wire [31:0] injNout,injEout,injSout,injWout;
	wire [31:0] N_output,E_output,S_output,W_output;
	eject_engine eje(.outN(outN),.outE(outE),.outS(outS),.outW(outW), .in_0(in_N), .in_1(in_E), .in_2(in_S), .in_3(in_W));
	injection_engine inj(.outN(injNout), .outE(injEout),.outS(injSout), .outW(injWout), .eject_N(outN), .eject_E(outE), .eject_S(outS), .eject_W(outW), .inject_port(inject_flit), .inject_req(inj_bit), .inject_grand(injection_status));
	permutation_engine per(.PNout(N_output), .PEout(E_output), .PSout(S_output), .PWout(W_output), .PNin(injNout), .PEin(injEout), .PSin(injSout), .PWin(injWout));
	initial begin
	#10
		//Consider the North flit to be the golden one with lowest in-packet sequence and the other golden flit would be the flit from the east 
		in_N = 32'h000800c3;
		in_E = 32'h111880c7;
		in_S = 32'h1109008a;//The south and the west flit is non-golden and not for local port ejection
		in_W = 32'h1019809e;
		inject_flit = 32'h100800b2; // Here, the golden flit that gets the local port is the north flit, and the injection flit gets injected at that port
		inj_bit = 1;
	#10	//Consider the East flit as the golden flit with the lowest in-packet sequence 
		in_N = 32'h000880c2; 
		in_E = 32'h111800c7;
		in_S = 32'h1109008a;
		in_W = 32'h1019809e;
		inject_flit = 32'h100800b2;
		inj_bit = 1;
	#10  //This is while considering East flit and north flit as the local ejection flit and all flits are non-golden flit. 
		in_N = 32'h000800c2;  //north flit wins 
		in_E = 32'h111880c6;
		in_S = 32'h1109008a;
		in_W = 32'h1019809e;
		inject_flit = 32'h100800b2;
		inj_bit = 1;
	#10 //This is while one of the flits which needs the local port is golden, and in this case the East flit is the golden flit,while the north flit is non-golden, but both of them compete for the local port. 
		in_N = 32'h000800c2;
		in_E = 32'h111880c7;  //In this too, the golden east flit wins against the non-golden north flit
		in_S = 32'h1109008a;
		in_W = 32'h1019809e;
		inject_flit = 32'h100800a3;
		inj_bit = 1;
	#10 // Consider all the flits ,except north and west, are non-golden and the north as well as the west flits are competing for the local ejection port.
 
		in_N = 32'h000980c3;  //The purpose of these inputs are to ensure that the called instantiated blocks in the ejection engine work properly
		in_E = 32'h11188036;  //The West flit is having lower in-packet sequence and hence it will win 
		in_S = 32'h1109009a;  //Here, the west link would be evicted and the inject engine replace the current flit with injection flit in the west link  
		in_W = 32'h111900cf;
		inject_flit = 32'h100800a2;
		inj_bit = 1;
	#10
		
	$finish;
end 
endmodule   */