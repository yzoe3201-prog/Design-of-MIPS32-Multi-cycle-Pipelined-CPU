`timescale 1ns / 1ps
`include "bus.v"

module Done_gate (
    input [`DATA_BUS] data_in,
    output  done
);
    wire [`DATA_BUS] data_out;
    genvar i;
    for ( i=0 ; i < `DATA_BUS_WIDTH ; i = i + 1) begin
        assign data_out[i] =  data_in[i] == 0 ? 0 
                            : data_in[i] == 1 ? 0 : data_in[i];
    // 相当于简化成:assign data_out[i] = 0;
    end
    assign done = ( data_out == 0 ) ? 1 : 0;
endmodule