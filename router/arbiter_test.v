`timescale 10ns/10ns

module arbiter_test();
	reg [31:0] arbiter_0,arbiter_1;
	wire [31:0] out;
	arbiter arb(.arb_in_0(arbiter_0), .arb_in_1(arbiter_1), .winner(out));
	initial begin 
	arbiter_0 = 32'h000800c3; // The arbiter 0 flit is the golden flit and have the lowest in packet sequence while the arbiter 1 is golden with the highest in packet sequecee
	arbiter_1 = 32'h111880c7; // The arbiter selects the 0th flit
	#10
	arbiter_0 = 32'h000880c2; // The arbiter 1 flit is golden adn has the lowest inpacket sequence
	arbiter_1 = 32'h111800c7;
	#10
	arbiter_0 = 32'h000800c2; // both flit non-golden, hence random port selection
	arbiter_1 = 32'h111880c6;
	
	$finish;
	end
endmodule 