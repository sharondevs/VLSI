module ones(output [2:0]count ,input [6:0]in);
	reg [2:0]temp;
	integer i;
	assign count = temp;
	always@(in) begin
	temp = 0;
	for (i=0;i<7;i=i+1) begin
		temp = temp + in[i];
	end
	end
	
endmodule
