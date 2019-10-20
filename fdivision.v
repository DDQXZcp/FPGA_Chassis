module fdivision (RESET,F50M,pulse1,pulse2,pulse3,pulse4,total_pulse_test);
	input F50M,RESET;
	output pulse1;
	output pulse2;
	output pulse3;
	output pulse4;
	output total_pulse_test;
reg flag1,flag2,flag3,flag4;
reg [20:0]j;//2^19 = 524_288
reg flag1_r,flag2_r,flag3_r,flag4_r;
always @(posedge F50M)
	if(!RESET) //低电平复位。
			j <= 0;
	else
		begin
			if(j==21'd2000000) //对计数器进行判断，以确定F50M 信号是否反转。
				j <= 0;
		else
			j <= j+1;
		end
always @(posedge F50M)
	if(!RESET) //低电平复位。
		begin
			flag1 <= 0;
			flag2 <= 0;
			flag3 <= 0;
			flag4 <= 0;
		end
	else
		begin
		if(j==21'd500000)
			flag1 <= ~flag1;
		if(j==21'd1000000)
			flag2 <= ~flag2;
		if(j==21'd1500000)
			flag3 <= ~flag3;
		if(j==21'd2000000)
			flag4 <= ~flag4;
		end
		
always@(posedge F50M)
	flag1_r <= flag1;
always@(posedge F50M)
	flag2_r <= flag2;
always@(posedge F50M)
	flag3_r <= flag3;
always@(posedge F50M)
	flag4_r <= flag4;		

assign pulse1 = flag1_r^flag1;
assign pulse2 = flag1_r^flag1;
assign pulse3 = flag1_r^flag1;
assign pulse4 = flag1_r^flag1;
assign total_pulse_test = pulse1 | pulse2 | pulse3 | pulse4;
	
endmodule