/*module prog(input reg[3:0]a,input reg[3:0]b,output reg[4:0]res);
integer i;
reg c= 1'b0,inter=1'b0;
always@(a,b)begin
for(i=0;i<=3;i=i+1)begin
	inter = a[i] + b[i];
	inter=inter +c;
	if((a[i]==1 && b[i]==1 && c==0)|| (a[i]==0&&b[i]==1&&c==1) || (a[i]==1&&b[i]==0&&c==1)|| (a[i]==1&&b[i]==1&&c==1))
	c=1;
	else
	c=0;
	res[i]=inter;
	end
res[i]=c;
end    
endmodule

*/
module prog(output reg[7:0]out, input [31:0]in );
integer i,count;
always@* begin
count=0;
for(i=0;i<32;i=i+1)begin
	count = count +in[i];
	end
out = count;
if(count>=16)
	$display("The input is having 1's more than 16");
end 
endmodule
