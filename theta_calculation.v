module theta_calculation(
	input clk,
	input rst_n,
	input signed [31:0] y_Global,
	input signed [31:0] x_Global,
	output reg signed[15:0] theta
);
parameter L = 50;

wire signed[31:0] delta_temp; //正负各分一半
wire signed[31:0] delta;
assign delta_temp = y_Global - x_Global;
assign delta[31:16] = delta_temp[15:0];//假设两者之差小于65536
assign delta[15:0] = 8'd0;

reg signed[31:0] theta_raw; //theta range from 0-65536 it stands for 0-360 degree or 0-2*3.141592653589793=6.283185307179586476
reg signed[63:0] theta_48;//theta multiplied by 2^32
reg signed[63:0] theta_48_pi;//theta multiplied by 2^32 and then divided by pi*2^32

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		begin
			theta_raw <= 32'd0;
			theta_48 <= 64'd0;
			theta_48_pi <= 64'd0;
			theta <= 16'd0;
		end
	else
		begin
		theta_raw <= delta/L ;//raw difference * 65536 /L
		//The calculation is raw difference/L /2pi *65536 = theta_raw/2pi
		theta_48[63:32] <= theta_raw[31:0]; //theta_raw*2^32
		theta_48[31:0] <= 32'd0;
		theta_48_pi <= theta_48/64'd26986075409;//This number is pi*2^32*2, The result is theta_raw/pi, done
		theta <= theta_48_pi[15:0]; //pick the lowest so the factor of x65536 is automatically ignored
		end
endmodule