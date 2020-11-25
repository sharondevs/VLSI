module ones(output [4:0]count ,input [30:0]in);
	reg [4:0]temp;
	integer i;
	assign count = temp;
	always@(in) begin
	temp = 0;
	for (i=0;i<31;i=i+1) begin
		temp = temp + in[i];
	end
	end
	
endmodule
