`timescale 1ns / 1ps

module Switch_led(
        input         clk,
 	 	input         rst,
 	 	input  [7:0]  switch,
 	 	output reg [7:0] led
);

	always @( posedge clk or posedge rst )
	    if (rst)
	       led = 8'h80;
	    else
		   led = switch;
endmodule