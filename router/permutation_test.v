

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
	
	reg [31:0] injNout,injEout,injSout,injWout;
	wire [31:0] N_output,E_output,S_output,W_output;
	permutation_engine per(.PNout(N_output), .PEout(E_output), .PSout(S_output), .PWout(W_output), .PNin(injNout), .PEin(injEout), .PSin(injSout), .PWin(injWout));
	initial begin
	#10
		//Consider the North flit to be the golden one with lowest in-packet sequence and the other golden flit would be the flit from the east 
		injNout = 32'h100800b2;
		injEout = 32'h111880c7;
		injSout = 32'h1109008a;//The south and the west flit is non-golden and not for local port ejection
		injWout = 32'h1019809e; // Here, the golden flit that gets the local port is the north flit, and the injection flit gets injected at that port(North)
		//The north golden flit was ejected and teh injection flit was injected into its place and passed on to the permutation block
		
	#10	//Consider the East flit as the golden flit with the lowest in-packet sequence and the other golden flit being the North flit
		injNout = 32'h000880c2; // In this, the east flit was ejected and replaced by the injection flit that was given in the injection test bench, and then passed on the permutation
		injEout = 32'h100800b2;
		injSout = 32'h1109008a;
		injWout = 32'h1019809e;
	#10  //This is while considering East flit as the local ejection flit and all flits are non-golden flit. 
		injNout = 32'h000800c2;  //East flit wins 
		injEout = 32'h100800b2;  // In this, the east flit was ejected and replaced by the injection flit that was given in the injection test bench, and then passed on the permutation
		injSout = 32'h1109008a;
		injWout = 32'h1019809e;
	#10 //This is while one of the flits which needs the local port is golden, and in this case the East flit is the golden flit,while the north flit is non-golden, but both of them compete for the local port. 
		injNout = 32'h000800c2;
		injEout = 32'h100800a3;  //In this too, the golden east flit wins against the non-golden north flit
		injSout = 32'h1109008a;
		injWout = 32'h1019809e;
	#10 // Consider all the flits ,except north and west, are non-golden and the north as well as the west flits are competing for the local ejection port.
 
		injNout = 32'h000980c3;  //The purpose of these inputs are to ensure that the called instantiated blocks in the ejection engine work properly
		injEout = 32'h11188036;  //The West flit is having lower in-packet sequence and hence it will win 
		injSout = 32'h1109009a;  //Here, the west link would be evicted and the inject engine replace the current flit with injection flit in the west link as that specified in the injection testbench 
		injWout = 32'h100800a2;
	#10
		
	$finish;
end 
endmodule  
/* The permutation does the permutation as according to the given logic and outputs the flits */
