
//This is the ejector block
module eject_block(output reg[31:0]out, input [31:0] in_0,in_1); // This block accepts the two input flits for arbiteration and winner selection
	wire dual; reg test; 
	arbiter u1( .winner(dual), .arb_in_0(in_0), .arb_in_1(in_1)); //This is for instanstiating the module arbiter module and the port numeber is saved in the wire 'duel'
	always@(*)begin
	if ((in_0[6:4]==3'b100) && (in_1[6:4]==3'b100))begin // The 4,5,6 bits are used for indicating the output port requirement in the router and '100' is the code for local port. 	
		if (dual == 1'b0 )begin // This if is executed when two flits ask for local port, they are compared and arbitered with the above instantiated module an
		test = 1'b1;	
		out = in_0;
		 end
		if (dual == 1'b1)begin
		out = in_1; test=1'b0; end
	end else if(in_0[6:4]==3'b100) begin // Checking if port 0 flit is seeking the local port 
		out = in_0;
	end else if(in_1[6:4]==3'b100)begin // Checking if port 1 flit is seeking thelocal port  
 	 	out = in_1; 
	end else begin
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

