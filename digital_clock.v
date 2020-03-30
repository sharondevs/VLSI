`timescale 1s/1s
module digital();
reg clk;
reg [3:0] hour_10, hour_unit,min_10,min_unit;
reg [5:0]sec;
initial begin
	hour_10=0;
	hour_unit =0;
	min_10=0;
	min_unit=0;
	sec=0;
	clk=1;
end
always #0.5 clk=~clk;
always@(posedge clk)begin
	if(sec==6'h3c)
	sec =0;
	else 	
	sec=sec+1;
end 
always@(*)begin
	if(sec== 6'h3c)begin
	if(min_unit==4'ha)begin 
		min_unit=0;	
		min_10= min_10+1;
		if(min_10==4'h6)begin
			min_10=0;
			hour_unit= hour_unit + 1;
			if(hour_unit==4'ha)begin
				hour_unit=0;
				hour_10=hour_10 +1;
				if(hour_10==4'h2 && hour_unit==4'h4)begin
					min_unit=0;
					min_10=0;
					hour_unit=0;
					hour_10=0;
				end
			end else begin
				hour_unit=hour_unit+1;
			end
		end else begin
		min_10=min_10 +1;
		end						
	end else begin
		min_unit = min_unit+1;
	end 
	end

end 
endmodule
