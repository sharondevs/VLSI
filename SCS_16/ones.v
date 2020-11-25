module ones(output [3:0]count ,input [14:0]in);
	reg [3:0]temp;
	integer i;
	assign count = temp;
	always@(in) begin
	temp = 0;
	for (i=0;i<15;i=i+1) begin
		temp = temp + in[i];
	end
	end
	
endmodule
