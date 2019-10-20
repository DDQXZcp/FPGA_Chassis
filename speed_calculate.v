module speed_calculate
(
	input clk,
	input rst_n,
	input signed[31:0] x_Global,
	input signed[31:0] y_Global,
	output reg signed [31:0]current_x_speed,
	output reg signed [31:0]current_y_speed,
);
// calculate unit: xx count/ms
reg [15:0] cnt;
reg signed [31:0] x_Global_r;
reg signed [31:0] y_Global_r;
always@(posedge clk or negedge rst_n)
	if(!rst_n)
		begin
			current_x_speed <= 32'd0;
			current_y_speed <= 32'd0;
		end
	else if(cnt == 32'd50000)
		begin
			x_Global_r <= x_Global;
			x_Global_r <= x_Global;
			current_x_speed <= x_Global - x_Global_r;
			current_y_speed <= y_Global - y_Global_r;
		end
		

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		cnt <= 0;
	else if(cnt == 32'd50000)//1ms
		cnt <= 0;
	else 
		cnt = cnt + 1'b1;
			
			
		
		
		
