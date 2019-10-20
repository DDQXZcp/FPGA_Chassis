module multiple_uart(
	input clk,
	input rst_n,
	input [7:0] data1,
	input [7:0] data2,
	input [7:0] data3,
	input [7:0] data4,
	output uart_tx,
	output total_pulse_test
);	




wire uart_clk1,uart_clk2,uart_clk3,uart_clk4;//按1，2，3，4顺序进行脉冲，分别高电平一个时钟周期，依次启动四组传输
wire uart_tx1,uart_tx2,uart_tx3,uart_tx4;
assign 	uart_tx = uart_tx1|uart_tx2|uart_tx3|uart_tx4;	//将四个信号整合到一条线上


wire bps_start1;	//接收到数据后，波特率时钟启动信号置位
wire clk_bps1;		// clk_bps_r高电平为接收数据位的中间采样点,同时也作为发送数据的数据改变点 
wire bps_start2;	
wire clk_bps2;		
wire bps_start3;	
wire clk_bps3;		
wire bps_start4;	
wire clk_bps4;	
	//UART发送信号波特率设置		
// 第一组				
	//UART发送数据处理
speed_setting		speed_tx1(	
							.clk(clk),	//波特率选择模块,每个发送模块都需要一个
							.rst_n(rst_n),
							.bps_start(bps_start1),
							.clk_bps(clk_bps1)
						);
my_uart_tx			my_uart_tx1(		
							.clk(clk),	//发送数据模块
							.rst_n(rst_n),
							.rx_data(data1),
							.rx_int(uart_clk1),
							.uart_tx(uart_tx1),
							.clk_bps(clk_bps1),
							.bps_start(bps_start1)
						);
// 第二组
	//UART发送数据处理	
speed_setting		speed_tx2(	
							.clk(clk),	//波特率选择模块,每个发送模块都需要一个
							.rst_n(rst_n),
							.bps_start(bps_start2),
							.clk_bps(clk_bps2)
						);
my_uart_tx			my_uart_tx2(		
							.clk(clk),	//发送数据模块
							.rst_n(rst_n),
							.rx_data(data2),
							.rx_int(uart_clk2),
							.uart_tx(uart_tx2),
							.clk_bps(clk_bps2),
							.bps_start(bps_start2)
						);
// 第三组						
	//UART发送数据处理
speed_setting		speed_tx3(	
							.clk(clk),	//波特率选择模块,每个发送模块都需要一个
							.rst_n(rst_n),
							.bps_start(bps_start3),
							.clk_bps(clk_bps3)
						);
my_uart_tx			my_uart_tx3(		
							.clk(clk),	//发送数据模块
							.rst_n(rst_n),
							.rx_data(data3),
							.rx_int(uart_clk3),
							.uart_tx(uart_tx3),
							.clk_bps(clk_bps3),
							.bps_start(bps_start3)
						);
// 第四组						
	//UART发送数据处理
speed_setting		speed_tx4(	
							.clk(clk),	//波特率选择模块,每个发送模块都需要一个
							.rst_n(rst_n),
							.bps_start(bps_start4),
							.clk_bps(clk_bps4)
						);
my_uart_tx			my_uart_tx4(		
							.clk(clk),	//发送数据模块
							.rst_n(rst_n),
							.rx_data(data4),
							.rx_int(uart_clk4),
							.uart_tx(uart_tx4),
							.clk_bps(clk_bps4),
							.bps_start(bps_start4)
						);
/// 分频///
///9600bps, 一个字节10个bit理论上一秒钟可发960字节
///这里定义一秒钟最高发100字节
///新时钟频率为100Hz
fdivision fdivision(
    .RESET(rst_n), 
    .F50M(clk), 
    .pulse1(uart_clk1), 
    .pulse2(uart_clk2), 
    .pulse3(uart_clk3), 
    .pulse4(uart_clk4), 
    .total_pulse_test(total_pulse_test)
    );						
endmodule		