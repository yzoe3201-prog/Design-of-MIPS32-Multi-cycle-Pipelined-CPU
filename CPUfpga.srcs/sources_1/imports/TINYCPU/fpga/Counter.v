`timescale 1ps / 1ps
//计数器
module Counter(
	input clk,
  	input rst,
  	output clk_bps
 );	
    parameter OVER = 14'd100;
	// 当计数器达到此值时，它将重置为0。
    
 	 	reg [13:0]cnt_first,cnt_second;
		// cnt_second只有在cnt_first溢出时（即等于OVER）才会自增。
		// 这样，它的增速会比cnt_first慢，实现更大范围的计数。
 	 	always @( posedge clk or posedge rst )
 	 	 	if( rst )
 	 			cnt_first <= 14'd0;
 	 		else if( cnt_first == OVER )
 	 			cnt_first <= 14'd0;
 	 		else
 	 			cnt_first <= cnt_first + 1'b1;
 	 	always @( posedge clk or posedge rst )
 	 		if( rst )
 	 			cnt_second <= 14'd0;
 	 		else if( cnt_second == OVER )
 	 			cnt_second <= 14'd0;
 	 		else if( cnt_first == OVER )
 	 			cnt_second <= cnt_second + 1'b1;
 	 	assign clk_bps = cnt_second == OVER ? 1'b1 : 1'b0;
		// cnt_second寄存器的值等于OVER时，表明一个完整的计数周期已经完成。
endmodule