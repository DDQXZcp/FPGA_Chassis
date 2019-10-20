module pwmmodule(data,reset,clk,pwm,Hbridge1,Hbridge2);
input signed[39:0] data;
input clk;
input reset;
output reg pwm;
output reg Hbridge1,Hbridge2;

reg [39:0] cnt;
reg [39:0] value;

always@*
	if(data[23])
			begin
				value = -data;//value range from 0-32787? The absolute value of data
				Hbridge1 = 1'b0;
				Hbridge2 = 1'b1;
			end
		else
			begin
				value = data;
				Hbridge1 = 1'b1;
				Hbridge2 = 1'b0;
			end
/*always@*
	begin
		value_r[15:1] = value[14:0];
		value_r[0] = 1'b0;
	end
*/
always@(posedge clk or negedge reset)
		if(!reset)
			cnt <= 39'd0;
		else
			cnt <= cnt + 1'b1; 
//pwm	
always@(posedge clk or negedge reset)
		if (!reset)
				pwm <= 1'b0;
		else
			begin
				if(cnt < value)
				pwm <= 1'b1;
				else
				pwm <= 1'b0;
			end
endmodule