`timescale 1ns / 1ps
`include "bus.v"
// cas_row模块通过将多个cas单元串联起来，实现了一整行的加法或减法操作，
// 这在执行阵列除法时是非常重要的。每个cas单元都参与到这个行操作中，
// 共同决定了最终的余数（rem）和进位（cout）

module cas_row (
    input [`DATA_BUS] op1,
    input [`DATA_BUS] op2,
    input add_sub_en_in,
    output cout,
    // 表示计算的最终进位输出
    output [`DATA_BUS] divisor,
    // 直接输出op2，作为除法中的除数部分
    output [`DATA_BUS] rem
    // rem：表示计算后的余数或结果。
);

wire[`DATA_BUS_WIDTH:0] temp;
wire[`DATA_BUS] add_sub_en_link = { `DATA_BUS_WIDTH{add_sub_en_in} };
// 它的每一个比特都连接到一个cas单元，以控制加法或减法。

assign divisor = op2;
assign cout = temp[`DATA_BUS_WIDTH];
assign temp[0] = 0; 

genvar i;
// i就是一个生成变量，它在for循环中用来生成多个实例或结构。
for( i=0; i<`DATA_BUS_WIDTH; i=i+1) begin
    // 为每一个比特位实例化cas模块:
    cas u_cas(
        .add_sub_en_in ( add_sub_en_link[i] ),
        .cin (temp[i]),
        .op1 (op1[i]),
        .op2 (op2[i]),
        .result (rem[i]),
        .cout (temp[i+1])
        // 这些cas单元串联起来，使得每个单元的进位输出(cin)成为下一个单元的进位输入(cout)
    );
end

endmodule