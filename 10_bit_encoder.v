/*
module encoder(input wire [1023:0]x, output reg[9:0]y);
	integer i;
	integer count=0;
	always@(x) begin: my_encoder
	reg [1023:0]temp;
	reg [9:0]out;
	out= 16'd0;
	for(temp=1024'd1 ;; temp= temp+1) begin
	if(temp==x)
	break;
	for(i=0;i<1024;i=i+1)begin
	count=count + temp[i];
	end
	if(count>1)
	continue;
	out<=out+1;
	end
	y<=out;
end: my_encoder
endmodule

*/
module testbench1();
reg [1023:0]x;
	wire [9:0]y;
	encoder enco(x,y);
	initial begin 
	x = 1024'd0;
	#10 
	x= 1024'd2;
#10
	x= 1024'd4;
#10
        x = 1024'd1024;
	$display("The output is : %b",y);
	#20;
    $finish;
end
endmodule


module encoder(input [1023:0]x, output reg[9:0]y);
	integer i,prior;
	always@(x) begin
	for(i=0;i<1024;i=i+1)begin
	if(x[i]==1)begin
	prior=i;
	end
	end
	y=prior;
	end
endmodule

	




