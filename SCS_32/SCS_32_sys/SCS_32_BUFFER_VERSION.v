module pseudo_encoder_buffer(output [31:0]out ,input [31:0]x,y);
	reg [31:0]temp;
	reg [31:0] temp1;
	always@(*) begin
	temp = x ^ y;
	end
	assign out = temp;
endmodule
