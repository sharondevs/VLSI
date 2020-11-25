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
	winner = 0; // For pseudorandom assginment, we choose the port 0
end
endmodule

