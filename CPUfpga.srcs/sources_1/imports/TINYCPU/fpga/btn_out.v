`timescale 1ns / 1ps
//处理按键输入的抖动并生成稳定的输出信号
module btn_out(
	input clk, //50MHz
	input rst,
	input sw_in_n,
	output reg sw_out_n
);


	reg sw_mid_r1, sw_mid_r2, sw_valid;
//	sw_mid_r1, sw_mid_r2这两级寄存器确保输入信号至少稳定了两个时钟周期
//  sw_valid检测sw_in_n的下降沿，即从未按下到按下的变化
	always@(posedge clk or posedge rst) begin
		if(rst) begin
			sw_mid_r1 <= 1; // synchronize 1 clock 同步
			sw_mid_r2 <= 1; // delay 1 clock
			sw_valid <= 0; // gen negedge
		end
		else begin
			sw_mid_r1 <= sw_in_n;
			sw_mid_r2 <= sw_mid_r1;
			sw_valid <= sw_mid_r2 & (~sw_mid_r1);
		end
	end

	reg [19:0] key_cnt;

	always@(posedge clk or posedge rst) begin
		if(rst) begin
			key_cnt <= 0;
		end
		else if(sw_valid) begin
//		检测到了输入信号sw_in_n的下降沿（即按键从未激活变为激活状态）
			key_cnt <= 0;
		end
		else begin
			key_cnt <= key_cnt + 1; //20ms
		end
	end

	always@(posedge clk or posedge rst) begin
		if(rst) begin
			sw_out_n <= 1;
		end
		else if(key_cnt == 20'hfffff) begin
//		当计数器key_cnt达到它的上限值20'hfffff时，表示输入信号已经稳定了足够长的时间（约20ms）
			sw_out_n <= sw_in_n;
		end
	end

endmodule


