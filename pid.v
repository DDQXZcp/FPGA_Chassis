/*module pid(
	input clk,
	input rst_n,
	input [63:0]current_value, 
	input [63:0]desired_value,
	output [63:0] output_value

);
parameter ki = 4; //kp = 0.04
parameter kp = 4; //ki = 0.04
parameter kd = 0; //kd = 0

wire [63:0] current_error;
reg [63:0] past_error;
reg [63:0] past_past_error;

reg[63:0] pout,iout,dout;
reg[63:0] delta;
reg[63:0] delta_out;

	p_term = error * m_conf->s_pid_kp * (1.0 / 20.0);
	i_term += error * (m_conf->s_pid_ki * dt) * (1.0 / 20.0);
	d_term = (error - prev_error) * (m_conf->s_pid_kd / dt) * (1.0 / 20.0);
	
	pid->pout = pid->p * (pid->err[NOW] - pid->err[LAST]);
	pid->iout = pid->i * pid->err[NOW];
	pid->dout = pid->d * (pid->err[NOW] - 2 * pid->err[LAST] + pid->err[LLAST]);

	pid->delta_u   = pid->pout + pid->iout + pid->dout;
	pid->delta_out += pid->delta_u;
	abs_limit(&(pid->delta_out), pid->MaxOutput);
	
assign current_error = desired_value - current_value;
	
	

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		begin
			past_error <= 64'd0;
			past_past_error <= 64'd0;
		end
	else 
		begin
			past_error <= current_error;
			past_past_error <= past_error;
		end

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		begin
			pout <= 64'd0;
			iout <= 64'd0;
			dout <= 64'd0;
		end
	else
		begin
			pout <= kp * (current_error - past_error);
			iout <= ki*current_error;
			dout <= kd*(current_error - 2* past_error + past_past_error);
			delta <= pout + iout + dout;
			delta_out <= delta;
		end
assign output_value = delta_out + current_value;			
endmodule	*/	

//The following is without d_term
module pid(
	input	clk,
	input	nRst,
	input    wire  signed   [31:0]   target,
    input    wire  signed   [31:0]   process,
    input    wire  signed   [31:0]   Kp,// need to prescale to a much lower level
    input    wire  signed   [31:0]   Ki,
    input    wire  signed   [31:0]   Kd,
	output   reg   signed   [39:0]   drive//多加一个byte，防止加起来数据溢出
);
//问题出在pid变化的太快
   wire  signed   [31:0]   error;
   wire  signed   [31:0]   int_error_new;
   reg   signed   [31:0]   int_error_old;

   assign error = target - process;
   assign int_error_new = error + int_error_old;

	always@(posedge clk or negedge nRst) begin
		if(!nRst) begin
	     drive          <= 32'd0;	
         int_error_old  <= 32'd0;
		end 
		else begin 
         drive <= process + ((Kp*error)>> 3) + ((Ki*int_error_new)>> 3);
         int_error_old <= int_error_new;
		end
	end
endmodule