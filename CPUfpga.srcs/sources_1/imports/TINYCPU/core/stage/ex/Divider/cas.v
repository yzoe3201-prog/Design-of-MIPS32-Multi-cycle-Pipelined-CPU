`timescale 1ns / 1ps
// 可控加减法单元
module cas (
    input  add_sub_en_in,
    // 控制信号，决定CAS单元的操作模式。
    // 当为0时，执行加法：Si = Ai ⊕ Bi ⊕ Ci              Ci+1 = AiBi + BiCi + AiCi；
    // 当为1时，执行减法：Si = Ai ⊕ (Bi ⊕ P) ⊕ Ci       Ci+1 = (Ai + Ci)·(Bi ⊕ P) + AiCi。
    input  cin,
    // 进位输入，即上一位运算的进位或借位
    input  op1,
    input  op2,
    output result,
    output cout
    // cout：进位输出，传递给下一位更高位的运算。
);

    assign   result = op1 ^ op2 ^ cin ; 
    assign   cout = add_sub_en_in ? 
                    ( ~op1 & op2 ) | ( ~op1 & cin ) | ( op2 & cin ) 
                    : op1 & op2 | ( cin & ( op1 ^ op2 ) );
                    
endmodule