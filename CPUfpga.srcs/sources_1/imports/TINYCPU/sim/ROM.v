`timescale 1ns / 1ps

`include "bus.v"
`include "pcdef.v"
`include "sim.v"

module ROM(
  input                       clk,
  input                       rst,
  
  input       [`MEM_SEL_BUS]  rom_write_en,
  input       [`DATA_BUS]     rom_write_data,
//实际未用到
  input                       rom_en,
  input       [`ADDR_BUS]     rom_addr,
  output  reg [`DATA_BUS]     rom_read_data//32位
);
//  存储器可以存储8位宽的指令
  reg[7:0] inst_mem[`INST_MEM_BUS];
  // initialize with program
  always @(posedge clk) begin
    if (rst) begin
      { inst_mem[3],inst_mem[2],inst_mem[1],inst_mem[0] } <= 32'hffff_0124;//addiu $1, $0, -1# 将 1 号寄存器赋值为 -1
      { inst_mem[7],inst_mem[6],inst_mem[5],inst_mem[4] } <= 32'h0200_0224;// addiu $2, $0, 2# 将 2 号寄存器赋值为 2
      { inst_mem[11],inst_mem[10],inst_mem[9],inst_mem[8] } <= 32'h2118_2200;//addu $3, $1, $2# 寄存器 1 和 2 的值相加，赋给 3 号寄存器=1
      { inst_mem[15],inst_mem[14],inst_mem[13],inst_mem[12] } <= 32'h0000_438c;// lw $3, 0($2)# 3号寄存器的值1，存入存储到内存地址$2 + 0处
      { inst_mem[19],inst_mem[18],inst_mem[17],inst_mem[16] } <= 32'h0000_44ac;// sw $4, 0($2)# 取出内存地址$2 + 0处的值1，放入4号寄存器=1
      { inst_mem[23],inst_mem[22],inst_mem[21],inst_mem[20] } <= 32'h1800_2200;// mult $1,$2# 寄存器 1 和 2 的值相乘，-2
      { inst_mem[27],inst_mem[26],inst_mem[25],inst_mem[24] } <= 32'h0000_438c;//lw $3, 0($2)# 3号寄存器的值1，存入存储到内存地址$2 + 0处
      { inst_mem[31],inst_mem[30],inst_mem[29],inst_mem[28] } <= 32'h0000_45ac;//sw $5, 0($2) # 取出内存地址$2 + 0处的值1，放入5号寄存器=1
      { inst_mem[35],inst_mem[34],inst_mem[33],inst_mem[32] } <= 32'h1a00_4100;//div $2,$1# 寄存器 2 和 1 的值相除，-2
      { inst_mem[39],inst_mem[38],inst_mem[37],inst_mem[36] } <= 32'h0000_f00b;//# 跳到ROM初始地址跳到ROM初始地址
      { inst_mem[43],inst_mem[42],inst_mem[41],inst_mem[40] } <= 32'h0200_0924;//addiu $9,$0,2
    end
  end
  wire[`ADDR_BUS] addr = rom_addr - `INIT_PC;

  always @(posedge clk) begin
    if (!rom_en) begin
      rom_read_data <= 0;
    end
    else begin
      rom_read_data <= {
        inst_mem[addr[`INST_MEM_ADDR_WIDTH - 1:0] + 0],
        inst_mem[addr[`INST_MEM_ADDR_WIDTH - 1:0] + 1],
        inst_mem[addr[`INST_MEM_ADDR_WIDTH - 1:0] + 2],
        inst_mem[addr[`INST_MEM_ADDR_WIDTH - 1:0] + 3]
      };
    end
  end

endmodule // ROM
