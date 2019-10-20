/////////////////////////////////////////////////////////////////////////////
//����Ӳ��ƽ̨�� Xilinx Spartan 6 FPGA
//�����׼��ͺţ� SF-SP6 ��Ȩ����
//��   Ȩ  ��   ���� �������ɡ�����ǳ����תFPGA�����ߡ���Ȩͬѧ��ԭ����
//				����SF-SP6�����׼�ѧϰʹ�ã�лл֧��
//�ٷ��Ա����̣� http://myfpga.taobao.com/
//�����������أ� �ٶ����� http://pan.baidu.com/s/1jGjAhEm
//��                ˾�� �Ϻ�������ӿƼ����޹�˾
/////////////////////////////////////////////////////////////////////////////
module my_uart_tx(
				input clk,			// 50MHz��ʱ��
				input rst_n,		//�͵�ƽ��λ�ź�
				input clk_bps,		// clk_bps_r�ߵ�ƽΪ��������λ���м������,ͬʱҲ��Ϊ�������ݵ����ݸı��
				input[7:0] rx_data,	//�������ݼĴ���
				input rx_int,		//���������ж��ź�,���յ������ڼ�ʼ��Ϊ�ߵ�ƽ,�ڸ�ģ�������������½������������ڷ�������
				output uart_tx,	// RS232���������ź�
				output reg bps_start	//���ջ���Ҫ�������ݣ�������ʱ�������ź���λ
			);

//---------------------------------------------------------
reg[7:0] tx_data;	//���������ݵļĴ���
reg tx_en;	//��������ʹ���źţ�����Ч
reg[3:0] num;

always @ (posedge clk or negedge rst_n) 
	if(!rst_n) begin
		bps_start <= 1'b0;
		tx_en <= 1'b0;
		tx_data <= 8'd0;
	end
	else if(rx_int) begin	//����������ϣ�׼���ѽ��յ������ݷ���ȥ
		bps_start <= 1'b1;
		tx_data <= rx_data;	//�ѽ��յ������ݴ��뷢�����ݼĴ���
		tx_en <= 1'b1;		//���뷢������״̬��
	end
	else if(num == 4'd10) begin	//���ݷ�����ɣ���λ
		bps_start <= 1'b0;
		tx_en <= 1'b0;
	end

//---------------------------------------------------------
reg uart_tx_r;

always @ (posedge clk or negedge rst_n)
	if(!rst_n) begin
		num <= 4'd0;
		uart_tx_r <= 1'b1;
	end
	else if(tx_en) begin
		if(clk_bps)	begin
			num <= num+1'b1;
			case (num)
				4'd0: uart_tx_r <= 1'b0; 	//������ʼλ
				4'd1: uart_tx_r <= tx_data[0];	//����bit0
				4'd2: uart_tx_r <= tx_data[1];	//����bit1
				4'd3: uart_tx_r <= tx_data[2];	//����bit2
				4'd4: uart_tx_r <= tx_data[3];	//����bit3
				4'd5: uart_tx_r <= tx_data[4];	//����bit4
				4'd6: uart_tx_r <= tx_data[5];	//����bit5
				4'd7: uart_tx_r <= tx_data[6];	//����bit6
				4'd8: uart_tx_r <= tx_data[7];	//����bit7
				4'd9: uart_tx_r <= 1'b1;	//���ͽ���λ
			 	default: uart_tx_r <= 1'b1;
			endcase
		end
		else if(num == 4'd10) num <= 4'd0;	//��λ
	end

assign uart_tx = uart_tx_r;

endmodule


