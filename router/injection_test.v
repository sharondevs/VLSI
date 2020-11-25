
//  This is the test bench for the above stage

/* Flit bits representations -  0(Golden or not)
				1(Fro indicating whether the flit was ejected out or not, and to be checked in the injector section)
				2-3(Input port indication bits 00-N, 01-E, 10-S, 11-W)
				4-6(For indicating the output port, 000-N,0001-E,010-S,011-W,100-Local port)
				7-10(Source add.)
				11-14(Destination add.)
				15-19(5bit In-packet sequence indication number)
*/	



//Test Bench
// I have tried out different types of 32 bit flit combinations to evaluate the correctness of the router to supply the end results 

module test();
	reg [31:0]in_N,in_E,in_S,in_W;
	reg [31:0] inject_flit;
	reg inj_bit;
	wire injection_status;
	wire [31:0] injNout,injEout,injSout,injWout;
	injection_engine inj(.outN(injNout), .outE(injEout),.outS(injSout), .outW(injWout), .eject_N(in_N), .eject_E(in_E), .eject_S(in_S), .eject_W(in_W), .inject_port(inject_flit), .inject_req(inj_bit), .inject_grand(injection_status));
	initial begin
	#10
		//Consider the North flit to be the golden one with lowest in-packet sequence and the other golden flit would be the flit from the east 
		//The north flit is already ejected and the new flit to be injected (inject_flit) is injected at its place
		in_N = 32'h000800c1;
		in_E = 32'h111880c7;
		in_S = 32'h1109008a;//The south and the west flit is non-golden and not for local port ejection
		in_W = 32'h1019809e;
		inject_flit = 32'h100800b2; 
		inj_bit = 1;
	#10	//Consider the East flit as the golden flit with the lowest in-packet sequence and the other golden flit being the North flit
		//The east flit is already ejected and the new flit to be injected (inject_flit) is injected at its place
		in_N = 32'h000880c2; 
		in_E = 32'h111800c5;
		in_S = 32'h1109008a;
		in_W = 32'h1019809e;
		inject_flit = 32'h100800b2;
		inj_bit = 1;
	#10  //This is while considering East flit as the local ejection flit and all flits are non-golden flit. 
		//The east flit is already ejected and the new flit to be injected (inject_flit) is injected at its place
		in_N = 32'h000800c2;   
		in_E = 32'h111880c4;
		in_S = 32'h1109008a;
		in_W = 32'h1019809e;
		inject_flit = 32'h100800b2;
		inj_bit = 1;
	#10 //This is while one of the flits which needs the local port is golden, and in this case the East flit is the golden flit,while the north flit is non-golden, but both of them compete for the local port. 
		//The east flit is already ejected and the new flit to be injected (inject_flit) is injected at its place
		in_N = 32'h000800c2;
		in_E = 32'h111880c5;  //In this too, the golden east flit wins against the non-golden north flit
		in_S = 32'h1109008a;
		in_W = 32'h1019809e;
		inject_flit = 32'h100800a3;
		inj_bit = 1;
	#10 // Consider all the flits ,except north and west, are non-golden and the north as well as the west flits are competing for the local ejection port.
 		//The west flit is already ejected and the new flit to be injected (inject_flit) is injected at its place
		in_N = 32'h000980c3;  //The purpose of these inputs are to ensure that the called instantiated blocks in the ejection engine work properly
		in_E = 32'h11188036;  //The West flit is having lower in-packet sequence and hence it will win 
		in_S = 32'h1109009a;  //Here, the west link would be evicted and the inject engine replace the current flit with injection flit in the west link  
		in_W = 32'h111900cd;
		inject_flit = 32'h100800a2;
		inj_bit = 1;
	#10
		
	$finish;
end 
endmodule   